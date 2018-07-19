---
title: "GraphQL Persisted Queries with HTTP Caching [Part 4]"

description: "This is the last of four parts on GraphQL Persisted Queries with HTTP Caching. We end by adding HTTP caching to our Express, Rails and React applications."

tags:
- graphql
- rails
- express
- http caching

pull_image: "/images/2018-07-18-graphql-persisted-queries-with-http-caching-part-4/post-query.png"
pull_image_attribution: 'Generated with [Carbon.now.sh](https://carbon.now.sh/)'
---

This is the last part of a four-part series on GraphQL Persisted Queries with HTTP Caching. As a recap of [part three](/graphql-persisted-queries-with-http-caching-part-3/), we created a Rails application capable of handling persisted queries.

In part four we will cover the following topics:

  1. Add HTTP Caching to React Application
  2. Add HTTP Caching to Express Server
  3. Add HTTP Caching to Rails Server
  4. Alternative Caching with Gateways

# Caching with GraphQL

There are different ways to _cache_ with GraphQL:

 - [Caching on the Apollo client](https://www.apollographql.com/docs/react/advanced/caching.html).
 - [Caching the parsed and validated GraphQL query](http://mgiroux.me/2016/graphql-query-caching-with-rails/).
 - [Caching field and response resolutions](https://github.com/chatterbugapp/cacheql).
 - Amongst other mechanisms and techniques.

For our situation, we're interested in HTTP caching, and the way to achieve this is to make our GraphQL network requests use `GET` instead of `POST`.

The main benefit for HTTP caching is that it allows CDNs and reverse proxy's (i.e., [Varnish](https://varnish-cache.org/)) to cache intermediate responses based on the response's headers (i.e., `Cache-Control`). This results in fewer requests hitting your server as the results might be cached, perfect for scaling your API. Even a short cache (i,e., < 10 seconds) could be extremely valuable as this cache could be shared across all consumers of the API.

I want to bring up an article by [Corey Clark](https://twitter.com/_CoreyClark) which tackles a very similar problem on how to use [`GET` requests with GraphQL Persisted Queries](https://medium.com/@coreyclark/graphql-persisted-queries-using-get-requests-8a6704aba9eb). Both the current post and Corey's article reach a similar state in achieving HTTP cacheability using `GET` requests.

In the following sections, we will augment our Express and Rails servers as well as our React application to use `GET` requests. To simplify things, we're going to apply a simple 10-second cache on all our responses (ideally you could tailor this to the individual query). In addition, we're going to make an assumption that we don't have any personalized data in our query responses.

## Add HTTP Caching to React Application

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/5cbb630c4780d20bc2747b0b62035a3702e87a3b)

Fortunately, the `apollo-link-persisted-queries` link has a simple option (`useGETForHashedQueries`) to enable `GET` requests for queries (but not mutations):

```js
const client = new ApolloClient({
  link: createPersistedQueryLink({ useGETForHashedQueries: true }).concat(
    createHttpLink({ uri: 'http://localhost:5000/graphql' })
  ),
  cache: new InMemoryCache(),
});
```

Now the outbound requests look like the following (a bit messy, but gets the job done):

```
http://localhost:5000/graphql?operationName=ConsolesByYear&variables=%7B%22afterYear%22%3A1990%2C%22beforeYear%22%3A2000%7D&extensions=%7B%22persistedQuery%22%3A%7B%22version%22%3A1%2C%22sha256Hash%22%3A%22a38e6d5349901b395334b5fd3b14e84a7ca7c4fc060a4089f2c23b5cf76f0f80%22%7D%7D
```

To better see the requests being cached on the HTTP layer, we're going to modify the `Query` in our `ConsoleContainer`:

```jsx
<Query query={QUERY} variables={{ afterYear, beforeYear }} fetchPolicy='network-only'>
```

By adding `fetchPolicy` of `network-only` the `apollo-client` will not cache responses, and thus each query will be sent to the GraphQL API.

## Add HTTP Caching to Express Server

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/0bf8d6bccc5649b00dda77b4dfdce523c22b4796)

We have to do a couple things to get our Express server in shape to serve `GET` requests. First thing is to remove the `bodyParser` middleware as we aren't parsing a `POST` anymore. We will also adjust our `GraphQLServer` options to toggle the `getEndpoint`, which adds a `GET` endpoint using our defined GraphQL route. Finally, we have to modify our `persistedQueriesMiddleware` to be on the `GET` route for `/graphql`. Those changes looks like the following:

```js
// server.js
const { GraphQLServer } = require('graphql-yoga')

const { typeDefs } = require('./graphql/typeDefs')
const { resolvers } = require('./graphql/resolvers')
const { persistedQueriesMiddleware } = require('./persistedQueriesMiddleware')

const server = new GraphQLServer({ typeDefs, resolvers })
const options = {
  port: 5000,
  getEndpoint: true,
  endpoint: '/graphql',
  playground: '/playground',
}

server.express.get('/graphql', persistedQueriesMiddleware)
server.start(options, ({ port }) =>
  console.log(
    `Server started, listening on port ${port} for incoming requests.`,
  ),
)
```

We also have to modify our `persistedQueriesMiddleware` itself to parse the `GET` query parameters and specify the response's `Cache-Control` header for a `max-age` of 10 seconds:

```js
// persistedQueriesMiddleware.js
const { invert } = require('lodash');
const extractedQueries = invert(require('./extracted_queries.json'))

persistedQueriesMiddleware = (req, res, next) => {
  console.log('Handling request to: ' + req.url)
  res.set('Cache-Control', 'public, max-age=10')

  const extensions = JSON.parse(req.query.extensions)
  const querySignature = extensions.persistedQuery.sha256Hash;
  const persistedQuery = extractedQueries[querySignature]

  if (!persistedQuery) {
    res.status(400).json({ errors: ['Invalid querySignature'] })
    return next(new Error('Invalid querySignature'))
  }

  req.query.query = persistedQuery
  next()
}

module.exports = { persistedQueriesMiddleware }
```

## Add HTTP Caching to Rails Server

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/c3bcc3588012a9b4b22bd582c80de3e0dd208078)

For our Rails server, we have a few small changes to make to allow for `GET` requests. First, we'll add a new route to allow for `GET` requests, under the same URL and controller action:

```ruby
Rails.application.routes.draw do
  # .. other routes
  post "/graphql", to: "graphql#execute"
  get "/graphql", to: "graphql#execute"
end
```

Like before, we handle the persisted queries within the `GraphqlController`. We need to tweak the controller to conform to the new query parameters structure of the React application's requests. We will also add an `expires_in` to add in the 10-seconds of `max-age` for the response's `Cache-Control` header:

```ruby
class GraphqlController < ApplicationController
  def execute
    expires_in(10.seconds, public: true)

    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    if query.present?
      result = RailsGraphqlSchema.execute(query, variables: variables, operation_name: operation_name)
    else
      extensions = JSON.parse(params[:extensions]) || {}
      signature = extensions.dig("persistedQuery", "sha256Hash")
      persisted_query = PersistedQuery.find_by!(signature: signature)
      result = RailsGraphqlSchema.execute(persisted_query.query, variables: variables, operation_name: operation_name)
    end

    render json: result
  rescue StandardError => e
    render json: { errors: [e.message] }
  end
```

## Alternative Caching with Gateways

I didn't mention [Apollo Engine](https://www.apollographql.com/engine), but this is a recent development in the GraphQL caching space. It provides a layer which sits in front of your GraphQL server and handles caching, query execution tracing, and error tracking. It is a paid solution if you need to handle more than 1 million requests per month.

Part of the secret sauce for caching with Apollo Engine is that it introduced the [Apollo Cache Control](https://github.com/apollographql/apollo-cache-control) GraphQL extension. This allows the GraphQL API to return cache hints on a per field-level. Effectively, this allows the caching to be smarter than simply a blanket solution.

For additional reading on these technologies and techniques, I recommend the following article on [Caching GraphQL Results in your CDN](https://dev-blog.apollodata.com/caching-graphql-results-in-your-cdn-54299832b8e2
) as it uses Automatic Persisted Queries, Apollo Cache Control, and Apollo Engine.

Another paid solution (if you exceed 5,000 requests per months) is [FastQL](https://fastql.io/). This is a new gateway solution which acts as its own CDN, handling caching and expiration of fields. You are able to manually invalidate field-level caches through an API, or automatically invalidate by sending mutations through their CDN (which expires fields related to the mutation object type).

# Reflection

There are a lot of options available for caching with GraphQL. It is possible to do so at different layers of the flow using different techniques and technologies. In this last post of the series we mainly took a look at HTTP caching. By enabling `GET` requests we were half-way there -- the last bit remaining is attaching the appropriate `Cache-Control` headers. Admittedly, we took an easy approach of blanketing all responses with a 10 second `max-age`.

Depending on your situation, you might need to further explore the field-level caching options like Apollo Cache Control, or even using a Gateway to help out, like FastQL. Even though being aware of the data within your queries is important, is it all cacheable? If you have personalized data you have to approach this in a different way. There might not be value in caching if every response is personalized to a user, or maybe you have to split your queries into two queries (i.e., personalized, non-personalized). The cache configuration (i.e., CDN and/or a reverse proxy) is a huge piece we skipped over, but it likely will need some tweaking for your specific use cases (i.e., split caching based on the header).

Overall, I am pleased with the solutions we arrived too. We built a simple GraphQL API in Express and Rails. Both of these can communicate with a React application using persisted queries. Our Express server used a JSON file for its data and persisted queries, while for our Rails server we had everything in a database. We overcame the issues with the existing tooling for determining a signature for each query, and created the ability to synchronize persisted queries via HTTP `POST` requests. We were able to implement `GET` requests and apply a 10-second cache for intermediate CDN and reverse proxies.

> This topic was presented at [GraphQL Toronto July 2018](https://www.meetup.com/GraphQL-Toronto/events/251760335/):
>
> - [Watch the talk](https://www.youtube.com/watch?v=ocX_jf81LwE)
> - [Read the slides](https://speakerdeck.com/kevinjalbert/graphql-persisted-queries-with-http-caching)
