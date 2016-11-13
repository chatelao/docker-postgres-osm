# DOCKER-VERSION 1.5.0
# VERSION 0.2

FROM postgres:9.3.6
MAINTAINER Olivier Chatelain <olivier.chatelain@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
# https://de.wikipedia.org/wiki/PostgreSQL
# ENV PG_MAJOR 9.3 # inherited from postgres
# https://de.wikipedia.org/wiki/PostGIS
ENV PGPG_MAJOR 2.1

RUN apt-get update && apt-get install -y -q \
        postgresql-${PG_MAJOR}-postgis-${PGPG_MAJOR} \
        postgresql-server-dev-${PG_MAJOR}=$PG_VERSION
# postgresql-contrib # already installed

ENV OSM_USER osm
ENV OSM_DB gis
# OpenTopoMap database
ENV OTO_DB lowzoom

RUN mkdir -p /docker-entrypoint-initdb.d
ADD ./postgres-entry.sh /docker-entrypoint-initdb.d/postgres-entry.sh
RUN chmod +x /docker-entrypoint-initdb.d/*.sh
