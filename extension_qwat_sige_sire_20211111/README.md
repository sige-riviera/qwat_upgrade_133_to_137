# This is the custom SIGE+SIRE extension for QWAT Datamodel

Because PUM does not yet manage upgrade while having multiple extensions, this extension is a merge of the SIGE and SIRE extensions.

To prevent any incompatibility with qwat initialisation and PUM upgrades, following filenames and filepath in this extension are reserved and should not be modified are:
- /extension/init.sh
- /extension/insert_views.sql
- /extension/rewrite_views.sh
- /extension/drop_views.sql 

However and with care it is possible to edit their content.

The following schemas are automatically kept during PUM data model upgrades with PUM because they are prefixed with usr_:
- usr_cartoriviera
- usr_sige

Other data structures such as custom fields and custom tables are handled with this extension.

# Information about this template repository to add an extension to QWAT

## Naming rule

It is recommended to use this template and to name the extension_xxx repository.

## Extension

The template contains an example script for initializing the extension in QWAT. You can also take an example from qwat/extension_sire.

## Integration test

If you want to test your code with Travis CI, you have the pre-configured scripts at your disposal. For this step you must declare the CI in your project and generate a token and declare it in Travis under the name GH_TOKEN.
