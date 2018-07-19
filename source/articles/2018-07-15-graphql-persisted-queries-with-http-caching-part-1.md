---
title: "GraphQL Persisted Queries with HTTP Caching [Part 1]"

description: "This is the first of four parts on GraphQL Persisted Queries with HTTP Caching. We start by describing some problems with GraphQL due to its flexibility, and how we can solve the issues with persisted queries."

tags:
- graphql
- rails
- express
- http caching

pull_image: "/images/2018-07-15-graphql-persisted-queries-with-http-caching-part-1/post-query.png"
pull_image_attribution: 'Generated with [Carbon.now.sh](https://carbon.now.sh/)'
---

GraphQL is a fast growing API specification, with aims of replacing REST APIs. A GraphQL server describes the data capabilities through the use of a type system and resolvers. A client is able to send a descriptive GraphQL query of what they want. The structure of the response then matches the query, providing a predictable result. There are many benefits to GraphQL servers and clients, to which I am not going to cover here as there is plenty of material on the Internet talking about those.

This four-part blog post series is specifically covering the topic of _GraphQL Persisted Queries_. A persisted query is a slight modification to the GraphQL specification that allows for better performance and security, at the cost of less flexibility. I will cover a bit of history regarding persisted GraphQL queries, along with the problems it solves. We will look at how to implement persisted queries in Rails and Express. As an extension to persisted queries, we will look at how to adapt them to take advantage of HTTP caching.

# Problems with GraphQL

GraphQL presents a flexible endpoint to which clients can send queries, however, this flexibility comes at a cost. The following three concerns are specifically targeting performance and security:

 - Queries could be large (i.e., data being sent) when compared to a standard REST endpoint
 - Queries could be inefficiently constructed (i.e., resource expensive)
 - Queries could be maliciously constructed (i.e., circular in nature)

As a consumer of a GraphQL API, it possible to construct _any query_ for the server to process. You can hope that the consumers are doing their best to create good queries, but in a public API that might not be the case. You might have ill-informed users creating very expensive queries, or even a bad actor trying to timeout or cripple your server by sending deeply cyclical queries.

There are several ways to mitigate these issues, as further outlined by [Max Stoiber's](https://twitter.com/mxstbr) article on [_Securing Your GraphQL API from Malicious Queries_](https://dev-blog.apollodata.com/securing-your-graphql-api-from-malicious-queries-16130a324a6b). In particular:
 - _Depth Limiting_: Rejecting queries which are too deeply nested
 - _Amount Limiting_: Rejecting queries which ask for too much information (i.e., via pagination arguments)
 - _Query Cost Analysis_: Rejecting queries which are too expensive (by assigning complexity values to fields)
 - _Query Whitelisting_: Rejecting queries that are not whitelisted

I would like to also add _Time Limiting_, which would reject queries that take too long to resolve.  _Query Whitelisting_ is only applicable for private APIs, but otherwise, these are all good approaches for preventing malicious or expensive queries from hitting your API. As per the topic we are covering, we'll focus on Query Whitelisting (otherwise known as Persisted Queries).

# Persisted Queries

[Facebook has been using persisted queries since 2013](https://twitter.com/leeb/status/829434814402945026), and comes highly recommended for production usage from them. The essence of a persisted query is that the query is _persisted_ on the server's side and that a client can _reference_ it using some unique identifier. A great primer on persisted queries can be found on [Apollo's blog article for this topic](https://dev-blog.apollodata.com/persisted-graphql-queries-with-apollo-client-119fd7e6bba5).

For the sake of completeness, I want to demonstrate a scenario where persisted queries shine.

A client sends the following query to the server:

```graphql
query {
  company {
    name
    consoles {
      name
      releaseYear
    }
  }
}
```

No problems so far! Now a bad actor sends the following query:

```graphql
query {
  company {
    consoles {
      company {
        consoles {
          company {
            consoles {
              name
              # ... continues nesting till happy with the damage
            }
          }
        }
      }
    }
  }
}
```

The server evaluating this query can experience performance or stability issues due to the deep nesting and complex nature of the query. Going forward, we will make some assumptions about our API:
 - We control both the server and the clients (i.e., web/mobile clients)
 - We don't expose a public API (it is accessible, but it isn't promoted for external usage)
 - The data being returned from the queries is not personalized

In our specific case, we can use persisted queries to remedy the issue of malicious users sending bad queries to our API. In addition, we will also gain some performance benefits (i.e., reducing the request's network size).

1. Persist the query on the server and make note of the signature of the query (i.e., a hash of the query)
2. The client sends the query signature to the server, along with any query variables
3. Using the signature, the server looks up the matching query from a set of persisted queries
4. The server executes the query and returns the data

That sounds great, but how can we go about implementing this? As previously mentioned, persisted queries are not part of the official specification. There are many implementations that exist, as well as some tooling for supporting persisted queries. In my experience at the time of writing this, there wasn't a standard way to implement persisted queries.

I want to stress the following: **Persisted Queries only work if you control the server and the client**. In theory, you could use persisted queries on public APIs, although the _security_ gains are not present. I do want to mention that [Automatic Persisted Queries](https://dev-blog.apollodata.com/improve-graphql-performance-with-automatic-persisted-queries-c31d27b8e6ea) is one way which uses the concept of persisted queries solely for performance gains.

# Implementing GraphQL Persisted Queries with HTTP Caching

For the sake of brevity and focus, this series will focus on the following platforms:

  - [React](https://github.com/facebook/react/) with [Apollo Client](https://github.com/apollographql/apollo-client)
  - [Express](https://github.com/expressjs/express) with [GraphQL Yoga](https://github.com/prismagraphql/graphql-yoga)
  - [Rails](https://github.com/rails/rails) with [GraphQL Ruby](https://github.com/rmosolgo/graphql-ruby)

[Part two](/graphql-persisted-queries-with-http-caching-part-2/) will cover the following sections:

  1. Setup Express Server
  2. Setup React Application
  3. Refactor React Application to use Persisted Queries
  4. Extract GraphQL Queries from Client
  5. Refactor Express Server to use Persisted Queries

[Part three](/graphql-persisted-queries-with-http-caching-part-3/) will cover the following sections:

  1. Setup Rails Server
  2. Synchronize GraphQL Queries to Rails Server
  3. Refactor Rails Server to use Persisted Queries

[Part four](/graphql-persisted-queries-with-http-caching-part-4/) will cover the following sections:

  1. Add HTTP Caching to React Application
  2. Add HTTP Caching to Express Server
  3. Add HTTP Caching to Rails Server
  4. Alternative Caching with Gateways

  > This topic was presented at [GraphQL Toronto July 2018](https://www.meetup.com/GraphQL-Toronto/events/251760335/):
  >
  > - [Watch the talk](https://www.youtube.com/watch?v=ocX_jf81LwE)
  > - [Read the slides](https://speakerdeck.com/kevinjalbert/graphql-persisted-queries-with-http-caching)
