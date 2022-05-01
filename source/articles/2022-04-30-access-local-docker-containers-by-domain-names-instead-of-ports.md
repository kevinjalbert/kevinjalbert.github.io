---
title: "Access Local Docker Containers by Domain Names instead of Ports"

description: "Read how to use domain names instead for your containers during development. You'll have an easier time remembering the container names instead of their ports."

tags:
- docker
- development
- nginx

pull_image: "/images/2022-04-30-access-local-docker-containers-by-domain-names-instead-of-ports/shipping-container-house.jpg"
pull_image_attribution: '[Jones-Glotfelty Shipping Container House, Flagstaff AZ](https://flickr.com/photos/glamourschatz/6045962800 "Jones-Glotfelty Shipping Container House, Flagstaff AZ") by [Glamour Schatz](https://flickr.com/people/glamourschatz) is licensed under [CC BY](https://creativecommons.org/licenses/by/2.0/)'
---

## Avoiding Ports when Accessing Local Docker Containers

When using [Docker](https://www.docker.com/) during development, you'll expose your application on localhost. Typically, you simply forward the exposed port from the application to the host machine. This allows you to access it via `localhost:8080` (based on whatever port you specified in the configuration).

I like to have nice _vanity_ URLs for my local applications like `whoami-one.localhost` and avoid using ports. I'll demonstrate an easy way to get them using [`nginxproxy/nginx-proxy`](https://github.com/nginx-proxy/nginx-proxy).

<div style="display: flex">
  <img src="/images/2022-04-30-access-local-docker-containers-by-domain-names-instead-of-ports/with-port.png" style="width: 49%; height: 80%"/>
  <img src="/images/2022-04-30-access-local-docker-containers-by-domain-names-instead-of-ports/with-domain-name.png" style="width: 49%; height: 80%"/>
</div>

It can be error-prone remembering what port corresponds to what application during development.

## The Setup

I'm using [Docker Compose](https://docs.docker.com/compose/), but in theory, you can do this with just `docker` commands as well.

The core of the solution involves using `nginxproxy/nginx-proxy`, which generates reverse proxy configurations for [nginx](https://www.nginx.com/) (and reloads it) when containers are started/stopped.

In the following snippet, you'll see how I'm specifying two services: `nginx-proxy` and `whoami-one`. The `whoami-one` service is just for demonstration purposes, but ideally is an application you are developing. The `VIRTUAL_HOST` environment variable specifies the domain name that you will use to reach that service.

```yml
version: '3'

services:
  nginx-proxy:
    image: nginxproxy/nginx-proxy
    ports:
      - '80:80'
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro

  whoami-one:
    image: containous/whoami
    environment:
    - VIRTUAL_HOST=whoami-one.localhost
```

Now go and visit `whoami-one.localhost` and you should see it all work!

_Note: I've used [`localhost` as the Top-Level-Domain (TLD)](https://en.wikipedia.org/wiki/.localhost) as it is reserved and avoids conflicts. I also use Chrome as my browser, which I believe automatically directs `.localhost` domains to localhost -- otherwise you'd have to do a bit more work to get that TLD to work._

## Multiple Services and Projects

One issue with the above solution is that it doesn't work _across_ services between different projects. Each `docker compose` sets up a default network that includes the name of the current directory. We can instead specify a consistent docker network to work around this limitation.

First, we'll specify just the `nginx-proxy` container, but with a _default named_ network. This makes it so all containers on this network can communicate.

```yml
version: '3'

services:
  nginx-proxy:
    image: nginxproxy/nginx-proxy
    ports:
      - '80:80'
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro

networks:
  default:
    name: local-network
```

Now, we can make a new `whoami` project (in a different directory) belonging to the same network that we defined for the `nginx-proxy`. This allows the two containers to see each other and we can visit `whoami.localhost` with no problems

```yml
version: '3'

services:
  whoami:
    image: containous/whoami
    environment:
    - VIRTUAL_HOST=whoami.localhost

networks:
  default:
    name: local-network
```

Overall, I enjoy using this to help differentiate local Docker containers using domain names instead of ports.

## Other Resources
- There are plenty of other options that [`nginx-proxy`](https://github.com/nginx-proxy/nginx-proxy) has, like SSL support.
- This also isn't a unique solution, as [Traefik](https://github.com/traefik/traefik) can also be used in a similar fashion.
- A throwback to an older project I made is [Docker Compose DNS Consistency (DCDC)](/docker-compose-dns-consistency-dcdc/), which provides consistent DNS resolution for services (not only for HTTP) internal and external to the Docker network.
