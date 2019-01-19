## Overview
![Hugo](https://raw.githubusercontent.com/gohugoio/hugoDocs/master/static/img/hugo-logo.png)

Docker image for hugo (https://gohugo.io), a fast and flexible static site generator written in Go. It is optimized for speed, ease of use, and configurability. Hugo takes a directory with content and templates and renders them into a full HTML website. Hugo relies on Markdown files with front matter for metadata, and you can run Hugo from any directory.

## Environment Variables

* `HUGO_THEME`
* `HUGO_WATCH` (set to any value to enable watching)
* `HUGO_DESTINATION` (Path where hugo will render the site. By default `/output`)
* `HUGO_REFRESH_TIME` (in seconds, only applies if not watching, if not set, the container will build once and exit)
* `HUGO_BASEURL`

## Building The Image Yourself (optional)

```
docker-compose build
```

The docker images build are based on [Alpine](https://hub.docker.com/_/alpine/), with an extremelly low footprint (less than 10 MB for nginx, and less than 70MB for hugo.

## Executing

    docker run --name "my-hugo" -P -v $(pwd):/src talmai/docker-hugo

Or, more verbosely, and with a specified output mapping:

    docker run --name "my-hugo" --publish-all \
           --volume $(pwd):/src \
           --volume /tmp/hugo-build-output:/output \
           talmai/docker-hugo

Find your container:

    docker ps | grep "my-hugo"
    CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS                   NAMES
    ba00b5c238fc        talmai/docker-hugo:latest   "/run.sh"              7 seconds ago       Up 6 seconds        1313/tcp      my-hugo

### docker-compose

Using this docker image together with nginx for serving static data.

`docker-compose.yml`

```
hugo:
  image: talmai/docker-hugo:latest
  volumes:
    - ./src/:/src
    - ./output/:/output
  expose:
    - 1313
  environment:
    - HUGO_REFRESH_TIME=3600
    - HUGO_THEME=mytheme
    - HUGO_BASEURL=mydomain.com
    - VIRTUAL_HOST=mydomain.com
  restart: always

proxy:
  image: jwilder/nginx-proxy
  ports:
    - 80:80
    - 443:443
  volumes:
    - /var/run/docker.sock:/tmp/docker.sock
    - vhost.d:/etc/nginx/vhost.d:ro
  restart: always
```
