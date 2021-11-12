-- This script is modified since we there is a conflict in status value list where values already exists which is (apparently, a wild customisation)

--INSERT INTO qwat_vl.object_reference (id, value_fr, value_en, value_ro) VALUES (9010,'fond de fouille','excavation bed','bază săpătură');
--INSERT INTO qwat_vl.object_reference (id, value_fr, value_en, value_ro) VALUES (9020,'sur vanne','on valve','pe supapă');
--INSERT INTO qwat_vl.object_reference (id, value_fr, value_en, value_ro) VALUES (9021,'sur tige de vanne','on valve shaft','pe arborele supapei');
--INSERT INTO qwat_vl.object_reference (id, value_fr, value_en, value_ro) VALUES (9022,'sur cape de vanne','on valve bonnet','pe capota supapelor');

UPDATE qwat_vl.object_reference
SET value_fr = 'fond de fouille', value_en = 'excavation bed', value_ro = 'bază săpătură'
WHERE id = 9010;

UPDATE qwat_vl.object_reference
SET value_fr = 'sur vanne', value_en = 'on valve', value_ro = 'pe supapă'
WHERE id = 9020;

UPDATE qwat_vl.object_reference
SET value_fr = 'sur tige de vanne', value_en = 'on valve shaft', value_ro = 'pe arborele supapei'
WHERE id = 9021;

UPDATE qwat_vl.object_reference
SET value_fr = 'sur cape de vanne', value_en = 'on valve bonnet', value_ro = 'pe capota supapelor'
WHERE id = 9022;
