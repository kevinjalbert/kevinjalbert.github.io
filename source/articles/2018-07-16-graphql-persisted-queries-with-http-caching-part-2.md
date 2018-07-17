---
title: "GraphQL Persisted Queries with HTTP Caching [Part 2]"

description: "This is the second of four parts on GraphQL Persisted Queries with HTTP Caching. We'll setup a React application and Express server, both using GraphQL. We will refactor these applications to support persisted queries."

tags:
- graphql
- rails
- express
- http caching

pull_image: "/images/2018-07-16-graphql-persisted-queries-with-http-caching-part-2/post-query.png"
pull_image_attribution: 'Generated with [Carbon.now.sh](https://carbon.now.sh/)'
---

This is the second part of a four part series on GraphQL Persisted Queries with HTTP Caching. As a recap of part one, we described some issues with GraphQL and how persisted queries can be a solution for them. We also covered what persisted queries were from a high-level.

In part two we will cover the following topics:

  1. Setup Express Server
  2. Setup React Application
  3. Refactor React Application to use Persisted Queries
  4. Extract GraphQL Queries from Client
  5. Refactor Express Server to use Persisted Queries

# Setup Express Server

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/5ac1a2a8dcc1757d145503ca0d209bcccca0ed97)

To begin, we're going to setup up a very simple Express server that'll serve up a GraphQL API. Let's break down the following file:

```js
// server.js
const { GraphQLServer } = require('graphql-yoga')

const { typeDefs } = require('./graphql/typeDefs')
const { resolvers } = require('./graphql/resolvers')

const server = new GraphQLServer({ typeDefs, resolvers })
const options = {
  port: 5000,
  endpoint: '/graphql',
  playground: '/playground',
}

server.start(options, ({ port }) =>
  console.log(
    `Server started, listening on port ${port} for incoming requests.`,
  ),
)
```

We have our GraphQL types and resolvers defined under the `./graphql` directory. The resolvers are pulling data from `data.json`, which is just an easier way to get this API started. In our example, we're serving up data on video game consoles, so the data doesn't change that often.

Using `graphql-yoga` we can create a `GraphQLServer`, supply it with the type definitions and resolvers. We set a couple of _options_ then we start the server.

# Setup React Application

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/c992730643a39f72bd5f5b6e335eb103b3646949)

To take advantage of our Express Server that is exposing a GraphQL API, we're going to create a simple React application to use it. We'll use `create-react-app` for our foundation, and add in `react-apollo` and `apollo-boost` to bootstrap the GraphQL.

**Note:** we need to use the [_next_ version (2.x) of `react-scripts` so that we can take advantage of a `graphql-tag/loader`](https://github.com/facebook/create-react-app/pull/3909) to load up [static `.graphql` files](https://dev-blog.apollodata.com/5-benefits-of-static-graphql-queries-b7fa90b0b69a).

We'll first initialize our Apollo client and render our `App` to the DOM. In addition, we need to set up the Apollo Client and point it to our GraphQL API. The following `index.js` file accomplishes all this setup:

```jsx
// index.js
import React from 'react';
import ReactDOM from 'react-dom';
import registerServiceWorker from './registerServiceWorker';

import { ApolloClient, InMemoryCache } from 'apollo-boost';
import { ApolloProvider } from 'react-apollo';
import { createHttpLink } from 'apollo-link-http';

import App from './components/App';
import './index.css';

const client = new ApolloClient({
  link: createHttpLink({ uri: 'http://localhost:5000/graphql' }),
  cache: new InMemoryCache(),
});

const AppWithProvider = () => (
  <ApolloProvider client={client}>
    <App />
  </ApolloProvider>
);

ReactDOM.render(<AppWithProvider />, document.getElementById('root'));
registerServiceWorker();
```

Nothing special is happening in our `App` component, as we're just creating some input controls and passing the data to our `ConsoleContainer` component. All our GraphQL data loading and usage is handled within the `ConsoleContainer`:

```jsx
// components/ConsoleContainer.js
import React from 'react';
import PropTypes from 'prop-types';
import { Query } from 'react-apollo';
import QUERY from '../graphql/ConsolesByYear.graphql';

const ConsolesAndCompany = ({ afterYear, beforeYear }) => (
  <Query query={QUERY} variables={{ afterYear, beforeYear }} fetchPolicy='network-only'>
    {({ data, error, loading }) => {
      if (error) return 'Error!';
      if (loading) return 'Loading';

      return (
        <React.Fragment>
          {
            data.consoles.map(console => (
              <div key={console.name}>
                <h3>{console.name}</h3>
                <h4>Release Year: {console.releaseYear}</h4>
                <h4>Company: {console.company.name}</h4>
                <br />
              </div>
            ))
          }
        </React.Fragment>
      );
    }}
  </Query>
);

ConsolesAndCompany.propTypes = { afterYear: PropTypes.number, beforeYear: PropTypes.number };

export default ConsolesAndCompany;
```

Notice that we're loading the `QUERY` from a static file. The `Query` component then allows the Apollo client to handle the networking, storage, and retrieval of the query. Our component finally renders new `React.Fragments` to the DOM with the resolved data.

# Refactor React Application to use Persisted Queries

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/f8b91be248c3b5c41813fc01dd99f05e3f62bf69)

In the last two sections we created a simple React application using Apollo client that uses a GraphQL API being served on Express. With a small change on our React application we can make it _persisted query_ enabled.

We take advantage of the [`apollo-link-persisted-queries`](https://github.com/apollographql/apollo-link-persisted-queries) (an _Apollo Link_) to modify the Apollo client. While it isn't _too difficult_ to roll our own implementation, it is best to lean on community supported projects. Using this package will help us narrow down what our future implementation needs to conform to on the server-side. In addition, it provides some _portability/compatibility_ with different projects due to being a community solution.

```js
// index.js
import { createPersistedQueryLink } from 'apollo-link-persisted-queries';

// ... rest of file

const client = new ApolloClient({
  link: createPersistedQueryLink().concat(
    createHttpLink({ uri: 'http://localhost:5000/graphql' })
  ),
  cache: new InMemoryCache(),
});

// ... rest of file
```

At this point our React application will be sending outbound `POST` requests with the following body:

```
{
  extensions: {
    persistedQuery: {
      version: 1,
      sha256Hash: "a38e6d5349901b395334b5fd3b14e84a7ca7c4fc060a4089f2c23b5cf76f0f80"
    }
  },
  operationName: "ConsolesByYear",
  variables: {
    afterYear: 1990,
    beforeYear: 1999
  }
}
```

We have our `operationName`, `variables` and the `extensions` properties present. Within the `extensions` property, we really only care about the `persistedQuery.sha256Hash` value. The `sha256Hash` value is automatically computed on-the-fly based on the outgoing query (it is worth noting you can [calculate the hashes at build-time](https://github.com/apollographql/apollo-link-persisted-queries#build-time-generation)). Thus, we now need a way to identify the queries by this signature on the server.

# Extract GraphQL Queries from React Application

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/078b3d2784add9b54b831b7e0b662ebea2bd9d4e)

We can use the [persistgraphql](https://github.com/apollographql/persistgraphql) tool from Apollo to help extract queries from the client application. This tool recursively scans a directory and looks for GraphQL queries (i.e., `.graphql` files), then it generates a JSON file of `query_string` keys mapped to `id` values. Unfortunately, this tool's major flaw is that the `id` ends up being an auto-incremented number:

```json
{
  "<query_string_1>": 1,
  "<query_string_2>": 2,
  "<query_string_3>": 3,
}
```

Auto-incrementing ids aren't going to uniquely identify the query string, thus causing long-term concerns when you need to extract the queries multiple times or from multiple clients. Ideally, you could use some cryptographic hash function to come up with the unique ids, which effectively becomes the query's signature). Currently, there are GitHub issues discussing these concerns ([pull request #35](https://github.com/apollographql/persistgraphql/pull/35) and [issue #34](https://github.com/apollographql/persistgraphql/issues/34)).

There are general questions and concerns with the tool's operation and how to use the output:

 * How do you sync them to the server ([issue #52](https://github.com/apollographql/persistgraphql/issues/52))?
 * How do you use them in the client ([issue #42](https://github.com/apollographql/persistgraphql/issues/42))?
 * How can you retain previous queries for a build process ([issue #17](https://github.com/apollographql/persistgraphql/issues/17))?

Apollo has another tool, [apollo-codegen](https://github.com/apollographql/apollo-codegen), that handles extracting queries for the purpose of generating code for other languages and types (i.e., Swift, Scala, Flow, etc...). It has been brought up in [issue #314](https://github.com/apollographql/apollo-codegen/issues/314) that a unification of `persistgraphql` and `apollo-codegen` would be ideal. In an article titled [GraphQL Persisted Documents](https://leoasis.github.io/posts/2018/04/27/graphql-persisted-documents/) (by [Leonardo Garcia Crespo](https://twitter.com/leogcrespo)), the landscape for extracting and using persisted queries can be confusing.

For the purpose of what we want to do, we will reuse the existing logic that `persistgraphql` has to extract the queries and add in a post-process that will determine a unique signature for each query to match what we need. I created a script, [`persistgraphql-signature-sync`](https://github.com/kevinjalbert/graphql-persisted-queries/tree/master/persistgraphql-signature-sync), to extract the queries from the client and augmented the `id`s to be a hash of the query acting as the unique signature. A SHA 256 hashing algorithm is used so that the generated hash value is the same as the ones generated by `apollo-link-persisted-queries`. It also handles synchronization of queries to an endpoint, which we will explore in a later section.

The following command:

```
node index.js --input-path=../react-graphql/src --output-file=./extracted_queries.json
```

produces a JSON file holding the query strings and their signatures:

```json
{
  "query ConsolesByYear($afterYear: Int, $beforeYear: Int) {\n  consoles(afterYear: $afterYear, beforeYear: $beforeYear) {\n    ...ConsoleFieldsFragment\n    company {\n      name\n      __typename\n    }\n    __typename\n  }\n}\n\nfragment ConsoleFieldsFragment on Console {\n  name\n  releaseYear\n  __typename\n}\n":"a38e6d5349901b395334b5fd3b14e84a7ca7c4fc060a4089f2c23b5cf76f0f80"
}
```

# Refactor Express Server to use Persisted Queries

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/a386f13fdc4e97ff0ceb4f159038eb924ced8386)

We now have our `extracted_queries.json` file containing our mapping of queries to signatures. We can go back and refactor our express server to use the output file containing the mapping to support persisted queries.

```js
const { GraphQLServer } = require('graphql-yoga')
const bodyParser = require('body-parser');

const { typeDefs } = require('./graphql/typeDefs')
const { resolvers } = require('./graphql/resolvers')
const { persistedQueriesMiddleware } = require('./persistedQueriesMiddleware')

const server = new GraphQLServer({ typeDefs, resolvers })
const options = {
  port: 5000,
  endpoint: '/graphql',
  playground: '/playground',
}

server.express.use(bodyParser.json());
server.express.post('/graphql', persistedQueriesMiddleware)
server.start(options, ({ port }) =>
  console.log(
    `Server started, listening on port ${port} for incoming requests.`,
  ),
)
```

We have added two things here:

  1. We use the `bodyParser` middleware that will allow us to access the `body` parameters on `POST` requests.
  2. We have a new `persistedQueriesMiddleware` that attaches onto the `/graphql` `POST` route.

We add the first middleware so that we can access the `req.body` in our custom `persistedQueriesMiddleware` middleware.

```js
// persistedQueriesMiddleware.js
const { invert } = require('lodash');
const extractedQueries = invert(require('./extracted_queries.json'))

persistedQueriesMiddleware = (req, res, next) => {
  console.log("Handling request to: " + req.url)

  const querySignature = req.body.extensions.persistedQuery.sha256Hash;
  const persistedQuery = extractedQueries[querySignature]

  if (!persistedQuery) {
    res.status(400).json({ errors: ['Invalid querySignature'] })
    return next(new Error('Invalid querySignature'))
  }

  req.body.query = persistedQuery
  next()
}

module.exports = { persistedQueriesMiddleware }
```

Recall the persisted query request body from our React application. We need to pull out the `sha256Hash` value as our signature and do a lookup in our `extracted_queries.json` file for the matching query. If we find a match, then we can set the _query_ to the actual query string and pass the request through to the underlying server to be resolved.

# Reflection

At this point we've built:

 - An Express server that exposes a GraphQL API.
 - A React application that uses Apollo to communicate with our GraphQL API.
 - A script to help to with extracting persisted queries from our React application.

 Our Express server is using a static file, `extracted_queries.json`, to do the mapping of the query to the signature. While this approach gets the job done, you might want to take it to the next level where this information is stored in a database (or similar storage). This adaptation comes with the following:

 - If we're using a database, it becomes possible to create more analytics and administration around persisted queries.
 - If you have multiple clients, they would all produce their own JSON file of persisted queries. You will then have to track/manage/merge these and possible commit them to your server code.
 - Each time you update your persisted queries you will require a restart or redeployment of the server. With a database synchronization approach, you can send the queries to be persisted while the server is running.

We will take a look at the next iteration of our persisted queries implementation, one that'll use synchronization -- using a Rails server backed by a database. We will cover this in the third part of our series.
