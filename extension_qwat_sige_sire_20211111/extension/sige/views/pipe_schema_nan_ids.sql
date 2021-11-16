-- View: usr_sige.pipe_schema_nan_ids

-- DROP VIEW usr_sige.pipe_schema_nan_ids;

CREATE OR REPLACE VIEW usr_sige.pipe_schema_nan_ids
 AS
 WITH sub AS (
         SELECT pipe.id,
            st_z((st_dumppoints(pipe.geometry)).geom) AS z,
            st_z((st_dumppoints(pipe.geometry_alt1)).geom) AS z_alt1,
            st_z((st_dumppoints(pipe.geometry_alt2)).geom) AS z_alt2
           FROM qwat_od.pipe
          ORDER BY (st_z((st_dumppoints(pipe.geometry)).geom)), (st_z((st_dumppoints(pipe.geometry_alt1)).geom)), (st_z((st_dumppoints(pipe.geometry_alt2)).geom)) DESC
        )
 SELECT sub.id,
    sub.z,
    sub.z_alt1,
    sub.z_alt2
   FROM sub
  WHERE sub.z = 'NaN'::double precision OR sub.z_alt1 = 'NaN'::double precision OR sub.z_alt2 = 'NaN'::double precision
  ORDER BY sub.id;

ALTER TABLE usr_sige.pipe_schema_nan_ids
    OWNER TO sige;

