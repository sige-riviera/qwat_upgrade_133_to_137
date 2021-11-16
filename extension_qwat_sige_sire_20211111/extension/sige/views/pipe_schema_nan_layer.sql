-- View: usr_sige.pipe_schema_nan_layer

-- DROP VIEW usr_sige.pipe_schema_nan_layer;

CREATE OR REPLACE VIEW usr_sige.pipe_schema_nan_layer
 AS
 WITH sub AS (
        ( WITH sub1 AS (
                 SELECT pipe.id,
                    st_z((st_dumppoints(pipe.geometry)).geom) AS z,
                    0 AS geom_schema_value,
                    'z'::text AS geom_schema_type,
                    pipe.geometry,
                    pipe.geometry_alt1,
                    pipe.geometry_alt2
                   FROM qwat_od.pipe
                )
         SELECT sub1.id,
            sub1.z,
            sub1.geom_schema_value,
            sub1.geom_schema_type,
            sub1.geometry
           FROM sub1
          WHERE sub1.z = 'NaN'::double precision)
        UNION
        ( WITH sub2 AS (
                 SELECT pipe.id,
                    st_z((st_dumppoints(pipe.geometry_alt1)).geom) AS z,
                    1 AS geom_schema_value,
                    'z_alt1'::text AS geom_schema_type,
                    pipe.geometry,
                    pipe.geometry_alt1,
                    pipe.geometry_alt2
                   FROM qwat_od.pipe
                )
         SELECT sub2.id,
            sub2.z,
            sub2.geom_schema_value,
            sub2.geom_schema_type,
            sub2.geometry_alt1
           FROM sub2
          WHERE sub2.z = 'NaN'::double precision)
        UNION
        ( WITH sub3 AS (
                 SELECT pipe.id,
                    st_z((st_dumppoints(pipe.geometry_alt2)).geom) AS z,
                    2 AS geom_schema_value,
                    'z_alt2'::text AS geom_schema_type,
                    pipe.geometry,
                    pipe.geometry_alt1,
                    pipe.geometry_alt2
                   FROM qwat_od.pipe
                )
         SELECT sub3.id,
            sub3.z,
            sub3.geom_schema_value,
            sub3.geom_schema_type,
            sub3.geometry_alt2
           FROM sub3
          WHERE sub3.z = 'NaN'::double precision)
        )
 SELECT row_number() OVER () AS id,
    sub.id AS pipe_id,
    sub.z,
    sub.geom_schema_value,
    sub.geom_schema_type,
    sub.geometry
   FROM sub
  ORDER BY (row_number() OVER ()), sub.geom_schema_value;

ALTER TABLE usr_sige.pipe_schema_nan_layer
    OWNER TO sige;

