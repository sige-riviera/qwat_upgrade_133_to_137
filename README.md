# qwat_upgrade_133_to_137
Upgrade scripts for QWAT SIGE datamodel from version 1.3.3 to 1.3.7.

## Some definitions and notes for using PUM

- production db: the production database is the production database, which is the source of data for test db and will be updated after confirmation according to delta files.
- test db: the test database is used to test the upgrade (empty db filled with data from production db, but then upgraded to targeted model version).
- comp db: the comparison database is an empty database (except maybe value lists) initialized in the targeted model version.
- `-N` option: skip schema, meaning that differences will not be logged in output log script. Either way, the schema will be kept in test and production databases. Syntax is -N schema1 -N schema2.
- `-` in differences log means that this line is missing in the comp database but present in the test database, hence it will not be kept in production database after upgrade.
- `+`  differences log  means that this ligne is present in the comp database but missing in the test database, hence it will be added in production database after upgrade.
- if a view inside a custom schema within qwat database reads a view in qwat core, an extension should be created, even if this schema is prefixed with usr_ because PUM will not be able to drop qwat core views during upgrade.
- qwat_sys.info : all applied deltas on database (during upgrade events)
- qwat_sys.upgrades : upgrades events table (par exemple 1.3.3 to 1.3.7)

## Upgrade process step by step

### Install PUM
`sudo pip3 install pum`

### Get some utility scripts
`mkdir ~/sit/production/qwat_upgrade_133_to_137`

`cd ~/sit/production/qwat_upgrade_133_to_137`

`git clone git@github.com:kandre/utils.git`

### Download QWAT project with its datamodel
`git clone --recurse-submodules git@github.com:qwat/QWAT.git`

-> Next time, better use:

 `git clone --recurse-submodules --branch 1.3.7 git@github.com:qwat/QWAT.git`

### Exceptionnaly some deltas need to be edited
- delta_1.3.4_003 is edited because there is a conflict in status value list where existing waiting (1308) value is, apparently, a wild customisation.
- delta_1.3.5_000 is edited because there is a conflict in status value list where values already exists (apparently, a wild customisation).

### Check checksum md5 values in upgrade tables
The checksum attribute values in qwat_sys.upgrades production database should be the same as the ones in released datamodel. If not, make sure delta corrections are correctly applied and copy paste the correct md5 values.

### Download SIGE+SIRE extension. It can be placed anywhere but more convenient to store it under data-model
`cd 	~/sit/production/qwat_upgrade_133_to_137/QWAT/data-model`

`git clone git@github.com:sige-riviera/extension_qwat_sige_sire.git`

`cd ~/sit/production/qwat_upgrade_133_to_137/QWAT`

### Disconnect current production database connections to allow production database copy at next step
`./utils/psql/kick_db_connections.sh -u sige -p qwat_prod -d qwat_prod`

-> Do not forget to manually disconnect pgAdmin connections if pgAdmin is opened

-> Make sure postgres service exists in defined in pg_service.conf

### Create a production database duplicate and clean both test and comparison databases (method using prefixed "pum_" databases)
`psql -U sige -d postgres -c "DROP DATABASE IF EXISTS pum_qwat_prod"`

`psql -U sige -d postgres -c "CREATE DATABASE pum_qwat_prod WITH TEMPLATE qwat_prod"`

`psql -U sige -d pum_qwat_prod -c "ALTER SCHEMA cartoriviera RENAME TO usr_cartoriviera"`

`psql -U sige -d postgres -c "DROP DATABASE IF EXISTS pum_qwat_test"`

`psql -U sige -d postgres -c "DROP DATABASE IF EXISTS pum_qwat_comp"`

### Pre-processing and patches, drop some content whom we don't have a better option
`psql -U sige -d pum_qwat_prod -c "DROP SCHEMA IF EXISTS chenyx06 CASCADE;"`

`psql -U sige -d pum_qwat_prod -f ../patches/fix_valve_trigger_name.sql`

Do not drop fineltra, it is used by cartoriviera export scripts and sometimes no some easy to add to the database.

### Edit QWAT upgrade.sh and init_qwat.sh scripts
- in data-model/update/upgrade_db.sh, replace qwat_test, qwat_comp and qwat_prod to pum_qwat_test, pum_qwat_comp and pum_qwat_prod
- in data-model/update/upgrade_db.sh, replace SRID=21781 to SRID=2056
- in init_qwat.sh, replace SRID=21781 to SRID=2056
- in ordinary_data/views/export/export_pipe.py replace SRID = 21781 to SRID = 2056
- if applicable, in ch_vd_sire/init.sh replace SRID=21781 to SRID=2056

### Get some info about status in upgrade table, check especially old deltas with pending status
`pum info -p pum_qwat_prod -t qwat_sys.info -d data-model/update/delta`

### Disconnect duplicated production database for next step execution
`./utils/psql/kick_db_connections/kick_db_connections.sh -p pum_qwat_prod -d pum_qwat_prod -u sige`

- >Also manually disconnect pgAdmin connections

### Launch edited upgrade.sh script
`cd ~/sit/production/qwat_upgrade_133_to_137/QWAT`

`./data-model/update/upgrade_db.sh -c -e data-model/extension_qwat_sige_sire/extension -t ../qwat_1_3_3_17.dump > ../pum_log_qwat_$(date +"%Y_%m_%d_%H_%M").txt`

Some escape characters are logged in file output, such as `^[[0m or ESC[0m.` This is due to the script that outputs colors in console output. Just ignore them.

At some point, the script should ask the user to apply deltas to pum_qwat_prod. Type in y or yes to proceed.
The message "Apply deltas to pum_qwat_prod? [n]|y" does not show up to the user if standard output is redirected to a file. In order to display the standard output in console, use :

`./data-model/update/upgrade_db.sh -c -e data-model/extension_qwat_sige_sire/extension -t ../qwat_1_3_3_17.dump`

Complete execution of the upgrade onto SIGE database takes around 12 minutes.

### Check results 
- check if no console errors
- check differences log
- check qwat_test and qwat_comp
- Check upgrades table : `pum info -p pum_qwat_prod -t qwat_sys.info -d ./data-model/update/delta`
- check checksum attribute values in qwat_sys.upgrades production database should be the same as the ones in master. If not, make sure delta corrections are correctly applied and copy paste the correct md5 values.

### Remount dropped schema chenyx06 used for cartoriviera exports
`pg_dump -U sige -n chenyx06 qwat_prod_v133_20211111 | psql -U sige -d qwat_prod`

### Go to production and create an archive of old database version
`psql -U sige -d postgres -c "ALTER DATABASE qwat_prod RENAME TO qwat_prod_v133_20211111;"`
`psql -U sige -d postgres -c "CREATE DATABASE qwat_prod WITH TEMPLATE pum_qwat_prod;"`

### Archive
Publish edited scripts, readme and logs on github sige-riviera to help future upgrades.

### Others remarks
About using upgrade_db.sh script: best practice is to use `-e`parameter. One should not need to directly in the script EXTDIRS and DELTADIRS parameters as it adds automatically `/delta` to each EXTDIRS value. However if needed, according to the documentation, multiple values in these variable should be space-separated.

About error `fatal: Not a git repository (or any of the parent directories): .git`
This console error should be corrected, otherwise nothing goes correctly. It can happen when an extension is used but whithout being a GIT repository.

Verbose level of differences log can be set: 0 -> nothing, 1 -> print first 80 char of each difference, 2 -> print all the difference details
