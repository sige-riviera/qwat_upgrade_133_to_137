#!/usr/bin/env bash

# Exit on error
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 1.1 Insert sire views
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sire/views/conduite.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sire/views/vanne_clapet.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sire/views/regulation_pression.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sire/views/station_pompage.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sire/views/station_traitement.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sire/views/reservoir.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sire/views/captage.sql

# 1.2 Insert sige views
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sige/views/pipe_schema_nan_ids.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sige/views/pipe_schema_nan_layer.sql
psql service=${PGSERVICE} -v ON_ERROR_STOP=1 -v SRID=$SRID -f ${DIR}/sige/views/statistics_ssige.sql
