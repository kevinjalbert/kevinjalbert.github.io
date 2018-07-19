---
title: "GraphQL Persisted Queries with HTTP Caching [Part 3]"

description: "This is the third of four parts on GraphQL Persisted Queries with HTTP Caching. We continue our journey with creating a Rails GraphQL API, synchronizing queries to it, and adapting it to use persisted queries."

tags:
- graphql
- rails
- express
- http caching

pull_image: "/images/2018-07-17-graphql-persisted-queries-with-http-caching-part-3/post-query.png"
pull_image_attribution: 'Generated with [Carbon.now.sh](https://carbon.now.sh/)'
---

This is the third part of a four-part series on GraphQL Pesisted Queries with HTTP Caching. As a recap of [part two](/graphql-persisted-queries-with-http-caching-part-2/), we created an Express server and React application, both using persisted queries.

In part three we will cover the following topics:

  1. Setup Rails Server
  2. Synchronize GraphQL Queries to Rails Server
  3. Refactor Rails Server to use Persisted Queries

# Setup Rails Server

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/5f78ac6dd2840a8690d82e4b50a752471332c8c2)

We'll create a basic Rails server that uses [`graphql-ruby`](https://github.com/rmosolgo/graphql-ruby). We will gloss over the busy work of setting up the models, database, and GraphQL types. First, we have our route defined that will accept `POST` requests to `/graphql` and passes them to our controller.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
end
```

The controller then extracts the variables, query, and operation name from the request's parameters. All this information is then executed against the GraphQL schema.

```ruby
# app/controllers/graphql_controller.rb
class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    result = RailsGraphqlSchema.execute(query, variables: variables, operation_name: operation_name)
    render json: result
  end

  private

  def ensure_hash(ambiguous_param)
    # ... Generated code provided by graphql-ruby's graphql:install
  end
end
```

# Synchronize GraphQL Queries to Rails Server

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/9f72e132f88e6f551e07700fd35539890d9e2a44)

To accommodate persisted queries, we will have to _synchronize_ the queries from our React application to our Rails server. Fortunately, `persistgraphql-signature-sync` (our script from earlier to extract queries) does this already.

> It is possible to sync the persisted queries to a specified endpoint. The endpoint needs to accept a POST request with body parameters of query and signature.

We will need to do a few things to support this new synchronization endpoint.

Let's create a new `PersistedQuery` model and migration:

```ruby
# app/models/persisted_query.rb
class PersistedQuery < ApplicationRecord
end
```

```ruby
# db/migrate/20180617011135_create_persisted_queries.rb
class CreatePersistedQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :persisted_queries do |t|
      t.string :signature, index: { unique: true }
      t.string :query

      t.timestamps
    end
  end
end
```

We will store the persisted queries in this newly created table -- notice that we have a unique index on the signature. Now let's add the required route and controller that will accept the synchronization request.

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # ... existing routes
  post "/graphql_persist", to: "graphql_persist#execute"
end
```

```ruby
# app/controllers/graphql_persist_controller.rb
class GraphqlPersistController < ApplicationController
  def execute
    document = GraphQL.parse(params[:query])

    if valid_query?(document)
      persisted_query = PersistedQuery.create(
        signature: params[:signature],
        query: params[:query],
      )

      render json: persisted_query.attributes
    else
      render json: { errors: @errors }, status: 500
    end
  rescue StandardError => e
    render json: { errors: [e.message] }, status: 500
  end

  private

  def valid_query?(document)
    query = GraphQL::Query.new(RailsGraphqlSchema, document: document)
    validator = GraphQL::StaticValidation::Validator.new(schema: RailsGraphqlSchema)

    results = validator.validate(query)
    errors = results[:errors] || []

    @errors = errors.map(&:message)
    @errors.empty?
  end
end
```

In this controller, we are parsing out the _query_ and validating it against our schema. If the query is okay from a schema perspective, then we create a new `PersistedQuery` database record with the `query` and the `signature`. When we get to using the persisted queries, we can do a quick look up and pull the query to be used.

We can now run the `persistgraphql-signature-sync` command:

```
node index.js --input-path=../react-graphql/src --sync-endpoint=http://localhost:3000/graphql_persist
```

This will attempt to synchronize each query to the server. It is not the prettiest, but the command will print out the server's response for each query.

```
Synching persisted query a38e6d5349901b395334b5fd3b14e84a7ca7c4fc060a4089f2c23b5cf76f0f80
{ id: 1,
  signature: 'a38e6d5349901b395334b5fd3b14e84a7ca7c4fc060a4089f2c23b5cf76f0f80',
  query: 'query ConsolesByYear($afterYear: Int, $beforeYear: Int) {\n  consoles(afterYear: $afterYear, beforeYear: $beforeYear) {\n    ...ConsoleFieldsFragment\n    company {\n      name\n      __typename\n    }\n    __typename\n  }\n}\n\nfragment ConsoleFieldsFragment on Console {\n  name\n  releaseYear\n  __typename\n}\n',
  created_at: '2018-07-03T19:52:54.717Z',
  updated_at: '2018-07-03T19:52:54.717Z' }
```

# Refactor Rails Server to use Persisted Queries

> Follow along with the complete code changes on [GitHub](https://github.com/kevinjalbert/graphql-persisted-queries/commit/802dcc0d9aef28b117f926d7638a4a2115d304e1)

The finish line is near! Our Rails server has the queries persisted in the database. Now we just have to adjust our `GraphqlController` to pull the appropriate query when receiving the persisted query request from our React application.

```ruby
# app/controllers/graphql_controller.rb
class GraphqlController < ApplicationController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]

    if query.present?
      result = RailsGraphqlSchema.execute(query, variables: variables, operation_name: operation_name)
    else
      signature = params.dig(:extensions, :persistedQuery, :sha256Hash)
      persisted_query = PersistedQuery.find_by!(signature: signature)
      result = RailsGraphqlSchema.execute(persisted_query.query, variables: variables, operation_name: operation_name)
    end

    render json: result
  rescue StandardError => e
    render json: { errors: [e.message] }
  end

  # ... rest of class
end
```

Our controller's action now handles the situation when we don't have a query present, which is the case when we're using persisted queries. In this situation, we pull out the `sha256Hash` value from the parameters and look up the persisted query. We then execute the persisted query's query against the schema.

In the event that we want to _lock down_ the API to only use persisted queries, we can use a conditional like `Rails.env.production?` to gate the flow, allowing only the persisted queries through.

# Reflection

In this post, we created a Rails server that exposes a GraphQL API. We used [`persistgraphql-signature-sync`](https://github.com/kevinjalbert/graphql-persisted-queries/tree/master/persistgraphql-signature-sync) to assist in synchronizing the queries from the React application (that we built in [part two](/graphql-persisted-queries-with-http-caching-part-2/)) to our Rails server.

**Note:** there does exist a paid pro version of `graphql-ruby` called [GraphQL::Pro](http://graphql.pro/), which has its own support for [persisted queries](http://graphql-ruby.org/operation_store/overview). It is a great solution as it covers synchronization of queries, admin dashboard, and connection to clients (Apollo/Relay). If you can afford the cost and want an _off the shelf_ solution, it is something you could consider. For the purpose of this article, however, we will skip out on it.

In the next and last part of this series, we will look at the final goal of adding HTTP caching to our GraphQL API servers. With HTTP caching we can lessen the load on our servers and offer faster response times to the consumers of the API.

> This topic was presented at [GraphQL Toronto July 2018](https://www.meetup.com/GraphQL-Toronto/events/251760335/):
>
> - [Watch the talk](https://www.youtube.com/watch?v=ocX_jf81LwE)
> - [Read the slides](https://speakerdeck.com/kevinjalbert/graphql-persisted-queries-with-http-caching)
