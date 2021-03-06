#!/usr/bin/env bash

GNUGETOPT="getopt"
if [[ "$OSTYPE" =~ FreeBSD* ]] || [[ "$OSTYPE" =~ darwin* ]]; then
  GNUGETOPT="/usr/local/bin/getopt"
elif [[ "$OSTYPE" =~ openbsd* ]]; then
  GNUGETOPT="gnugetopt"
fi

# Exit on error
set -e

usage() {
cat << EOF
Usage: $0 [options]

-p|--pgservice       PG service to connect to the database.
-s|--srid            PostGIS SRID. Default to 21781 (ch1903)
-d|--drop-schema     Drop schema (cascaded) if it exists
EOF
}

ARGS=$(${GNUGETOPT} -o p:s:d -l "pgservice:,srid:,drop-schema" -- "$@");
if [[ $? -ne 0 ]]
then
  usage
  exit 1
fi

eval set -- "$ARGS";

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Default values
SRID=2056
DROPSCHEMA=0

while true; do
  case "$1" in
    -p|--pgservice)
      shift
      if [[ -n "$1" ]]
      then
        PGSERVICE=$1
        shift
      fi
      ;;
    -s|--srid)
      shift;
      if [[ -n "$1" ]]; then
        SRID=$1
        shift;
      fi
      ;;
    -d|--drop-schema)
      DROPSCHEMA=1
      shift;
      ;;
    --)
      shift
      break
      ;;
  esac
done

if [[ -z $PGSERVICE ]]
then
  echo "Error: no PG service provided; either use -p or set the PGSERVICE environment variable."
  exit 1
fi

if [[ "$DROPSCHEMA" -eq 1 ]]; then
	psql service=${PGSERVICE} -v ON_ERROR_STOP=1 \
         -c "DROP SCHEMA IF EXISTS usr_sige"
fi

# dumb test
psql service=$PGSERVICE -v ON_ERROR_STOP=1 -c "CREATE SCHEMA IF NOT EXISTS dumb3"

# 1.1 Create the qwat_ch_vd_sire schema
psql service=$PGSERVICE -v ON_ERROR_STOP=1 -c "CREATE SCHEMA IF NOT EXISTS qwat_ch_vd_sire"

# 1.2 Create custom sige schemas
psql service=$PGSERVICE -v ON_ERROR_STOP=1 -c "CREATE SCHEMA IF NOT EXISTS usr_sige"

# 2.1 Add the ch_vd_sire columns
psql service=$PGSERVICE -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sire/sire_columns.sql

# 2.2 Add the custom sige columns
psql service=$PGSERVICE -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sige/columns/sige_columns.sql

# 3.1 Add the custom sige tables
psql service=$PGSERVICE -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sige/tables/aec_vs_export_pipe.sql
psql service=$PGSERVICE -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sige/tables/aec_vs_export_installation.sql

# 4.1 Re-create the QWAT views, for the new ch_vd_sire columns to be taken into account
QWAT_REPO="$(git rev-parse --show-toplevel)/data-model" # this line should be improved in qwat extension template because it does not work if only the qwat-data-model is git cloned.
PGSERVICE=${PGSERVICE} SRID=${SRID} ${QWAT_REPO}/ordinary_data/views/rewrite_views.sh

# 5.1 create the ch_vd_sire views
PGSERVICE=${PGSERVICE} SRID=${SRID} ${DIR}/insert_views.sh

# 5.2 Create the custom sige views
PGSERVICE=${PGSERVICE} SRID=${SRID} ${DIR}/insert_views.sh

exit 0
