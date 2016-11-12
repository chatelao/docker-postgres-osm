# DOCKER-VERSION 1.5.0
# VERSION 0.2

FROM postgres:9.3.6
MAINTAINER James Badger <james@jamesbadger.ca>

ENV DEBIAN_FRONTEND noninteractive
# https://de.wikipedia.org/wiki/PostgreSQL
ENV PG_MAJOR 9.3
# https://de.wikipedia.org/wiki/PostGIS
ENV PGPG_MAJOR 2.1

# RUN apt-get install -y -q squid-deb-proxy-client
RUN apt-get update && apt-get install -y -q postgresql-${PG_MAJOR}-postgis-${PGPG_MAJOR} postgresql-contrib postgresql-server-dev-${PG_MAJOR}

ENV OSM_USER osm
ENV OSM_DB gis
# OpenTopoMap database
ENV OTO_DB lowzoom

RUN mkdir -p /docker-entrypoint-initdb.d
ADD ./postgres-entry.sh /docker-entrypoint-initdb.d/postgres-entry.sh
RUN chmod +x /docker-entrypoint-initdb.d/*.sh
