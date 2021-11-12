-- This delta is exceptionnaly not applied because it drop the SIRE columns but since we need the extension, they are not dropped but not recreated during upgrade in qwat_test database (bug). They are only created in qwat_comp database thanks to the sirextension, which is correct.
-- Write dumb query instead to allow execution:
SELECT current_database() AS dumb_query;

--ALTER TABLE qwat_vl.pipe_function DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.pipe_material DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.precision DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.precisionalti DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.pump_operating DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.pump_type DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.remote_type DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.source_quality DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.source_type DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.status DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.survey_type DROP COLUMN code_sire;
--ALTER TABLE qwat_vl.watertype DROP COLUMN code_sire;
