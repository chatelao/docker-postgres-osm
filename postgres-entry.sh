#!/bin/bash
set -e

# gosu postgres postgres --single -jE <<-EOL
# gosu postgres pg_ctl -w start
# gosu postgres 
psql <<-EOL
  CREATE USER "$OSM_USER";

  CREATE DATABASE "$OSM_DB";
  CREATE DATABASE "$OTO_DB";
  CREATE DATABASE "contours";

  GRANT ALL ON DATABASE "$OSM_DB" TO "$OSM_USER";
  GRANT ALL ON DATABASE "$OTO_DB" TO "$OSM_USER";
  GRANT ALL ON DATABASE "contours" TO "$OSM_USER";
EOL

# Postgis extension cannot be created in single user mode.
# So we will do it the kludge way by starting the server,
# updating the DB, then shutting down the server so the
# rest of the docker-postgres init scripts can finish.

# gosu postgres 
psql "$OSM_DB" <<-EOL
  CREATE EXTENSION postgis;
  CREATE EXTENSION hstore;
  CREATE EXTENSION dblink;
  ALTER TABLE geometry_columns OWNER TO "$OSM_USER";
  ALTER TABLE spatial_ref_sys OWNER TO "$OSM_USER";
EOL

# gosu postgres 
psql "$OTO_DB" <<-EOL
  CREATE EXTENSION postgis;
  CREATE EXTENSION hstore;
  CREATE EXTENSION dblink;
EOL
# gosu postgres 
pg_ctl stop
