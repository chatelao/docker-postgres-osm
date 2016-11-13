#!/bin/bash
set -e

gosu postgres psql <<-EOL
  CREATE USER "$OSM_USER";

  CREATE DATABASE "$OSM_DB";
  GRANT ALL ON DATABASE "$OSM_DB" TO "$OSM_USER";

  CREATE DATABASE "$OTOL_DB";
  CREATE DATABASE "$OTOC_DB";
  GRANT ALL ON DATABASE "$OTOL_DB" TO "$OSM_USER";
  GRANT ALL ON DATABASE "$OTOC_DB" TO "$OSM_USER";
EOL

gosu postgres psql "$OSM_DB" <<-EOL
  CREATE EXTENSION postgis;
  CREATE EXTENSION hstore;
  CREATE EXTENSION dblink;
  ALTER TABLE geometry_columns OWNER TO "$OSM_USER";
  ALTER TABLE spatial_ref_sys  OWNER TO "$OSM_USER";
EOL

gosu postgres psql "$OTOL_DB" <<-EOL
  CREATE EXTENSION postgis;
  CREATE EXTENSION hstore;
  CREATE EXTENSION dblink;
EOL

gosu postgres psql "$OTOC_DB" <<-EOL
  CREATE EXTENSION postgis;
  CREATE EXTENSION hstore;
EOL
