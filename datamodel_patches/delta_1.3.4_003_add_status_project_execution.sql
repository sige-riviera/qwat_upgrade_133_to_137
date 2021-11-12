-- This script is modified since we there is a conflict in status value list where existing waiting (1308) value which is, apparently, a wild customisation.
-- Write dumb query instead to allow execution:
SELECT current_database() AS dumb_query;

--INSERT INTO qwat_vl.status (id, active, functional, value_en, value_fr, value_ro, description_en, description_fr, description_ro) VALUES (1308, true, false, 'project in execution',        'projet en execution',       'Proiect în execuție',      '', 'L''objet est un projet validé en cours de réalisation', 'Obiectul face parte dintr-un proiect care este în curs de execuție');

--UPDATE qwat_vl.status SET active = true, value_fr = 'projet planifie', value_en = 'project planned', value_ro = 'Proiect planificat', description_fr = 'L''objet est un projet validé en attente', description_ro = 'Obiectul face parte dintr-un proiect care se va face', description_en = 'The object is part of a project that''s already in execution' WHERE id = 1306;
