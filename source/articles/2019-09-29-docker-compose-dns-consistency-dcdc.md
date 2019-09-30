---
title: "Docker Compose DNS Consistency (DCDC)"

description: "Introducing DCDC: a way to work with multiple Docker Compose projects locally with consistent service URLs, internal and external to the Docker network."

tags:
- docker
- tools

pull_image: "/images/2019-09-29-docker-compose-dns-consistency-dcdc/docker.jpg"
pull_image_attribution: '[Docker-2](https://flickr.com/photos/134416355@N07/31744142112 "Docker-2") by [maijou2501](https://flickr.com/people/134416355@N07) is licensed under [CC BY-SA](https://creativecommons.org/licenses/by-sa/2.0/)'
---

While I'm no longer at [theScore](https://scoremediaandgaming.com/), I do recall the larger _dockerization_ efforts that happened near the end of my employment there. It wasn't uncommon to have several services running for the product you were working on. At theScore we used [Docker Compose](https://docs.docker.com/compose/) for local development as it eased the setup and took care of running dependencies.

This eventually leads to the overall problem of dealing with Docker Compose networking and DNS resolution. I ended up creating a tool called _Docker Compose DNS Consistency_, [`dcdc`](https://github.com/scoremedia/dcdc), as a way to solve this. The following sections are from the `dcdc` README file, and I would highly recommend going there right after for more in-depth details on how `dcdc` actually works.

# Problem

We have a project (i.e., `proj1`) that contains an API (`api`) service. With Docker, we are able to expose the API server's default port (`3000`). Thus, `localhost:3000` routes to the API of `proj1`. We have another project (i.e., `proj2`) that also contains an API (`api`) service, and is also exposed on the default port of `3000`.

Both projects exist as separate repositories and therefore have different `docker-compose.yml` files. In isolation, both projects run without any problem and expose their respective API service on `localhost:3000`. The issue is when you want to run both projects at the same time -- which might be needed for the development of a new feature or testing a complete flow.

The naive solution is to change one of the exposed ports for a project to `3001` so that there is no clashing of ports. So for example, `proj2`'s API is now exposed on port `3001` and is reachable at `localhost:3001`.

There are a few problems here:

  1. This process of ensuring we have no conflicting ports on the host can be painful. Even if the projects aren't related, you can have conflicting ports being exposed. As the number of projects grows, this becomes more challenging. It's likely that a document is needed to keep track of used ports (or port ranges).
  2. If the two projects have to communicate to each other internally (i.e., not via the host's web browser), the projects cannot see each other as they are on a different network (by default).
  3. Externally to the Docker network, we refer to the APIs as `localhost:<port>`, but internally we need to use the _service name_ like `proj1`'s `api`. There is a disconnect in how we _refer_ to the services internally and externally to the Docker network.

# Solution

DCDC's purpose is to provide an easy way to work with multiple Docker Compose projects locally by:

1. Exposing fully qualified domain names for each service (ending in `.test`) using DNS and reverse proxy.
2. Providing consistent DNS resolution for services internal and external to the Docker network (i.e., `db.proj.test` is accessible on the host machine and also from a service's container).
3. Requiring as little configuration to projects to make them work with DCDC.

_NOTE: at the time of publication, DCDC only works with macOS. It's likely possible to work for other operating systems, although it will require some rejigging._

The following is the test output of `dcdc` that demonstrates accessibility to services external and internal to the Docker network. Not only are HTTP services accessible, but also non-HTTP services (i.e., a database).

![](/images/2019-09-29-docker-compose-dns-consistency-dcdc/dcdc-tests.png)
