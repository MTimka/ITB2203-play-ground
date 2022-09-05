


CREATE OR REPLACE FUNCTION fun_get_all_courses_simple()
  RETURNS TABLE (course_id                    int
               , course_name                  text
               , course_code                  text
               , course_creator_id            int
               , course_creator_name          text
               , course_max_points            bigint
               , course_max_points_weighted   float)
  LANGUAGE plpgsql AS
$func$
BEGIN
   RETURN QUERY
   WITH var_course_max_points AS (
       SELECT c.id
            , SUM(a.max_points) as course_max_points
            , SUM(a.max_points * a.weight) as course_max_points_weighted
       FROM assignment AS a
       INNER JOIN course AS c
       ON c.id = a.course_id
       GROUP BY c.id
   )
   SELECT c.id
        , c.name
        , c.code
        , t.id
        , p.full_name
        , var_course_max_points.course_max_points
        , var_course_max_points.course_max_points_weighted
   FROM course as c
   INNER JOIN teacher as t
   ON t.id = c.course_creator_id
   INNER JOIN person as p
   ON p.id = t.person_id
   LEFT JOIN var_course_max_points
   ON var_course_max_points.id = c.id;
END
$func$;

SELECT * FROM fun_get_all_courses_simple();




CREATE OR REPLACE FUNCTION fun_add_course(_teacher_id int, _course_name text)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
DECLARE
    var_inserted_course_id int;
BEGIN
    INSERT INTO course(course_creator_id, name) VALUES (_teacher_id, _course_name);
    var_inserted_course_id := (SELECT currval('person_id_seq'));
    -- also add teacher who created course to "teacher_in_course" table
    INSERT INTO teacher_in_course(teacher_id, course_id) VALUES (_teacher_id, var_inserted_course_id);
END
$func$;




CREATE OR REPLACE FUNCTION fun_delete_course(_course_id int)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    DELETE FROM course where id = _course_id;
END
$func$;





CREATE OR REPLACE FUNCTION fun_get_course_info(_course_id int)
    RETURNS TABLE (course_id                    int
                 , course_name                  text
                 , course_code                  text
                 , course_creator_id            int
                 , course_creator_name          text
                 , course_max_points            bigint
                 , course_max_points_weighted   float)
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    WITH var_course_max_points AS (
        SELECT c.id
             , SUM(a.max_points) as course_max_points
             , SUM(a.max_points * a.weight) as course_max_points_weighted
        FROM assignment AS a
        INNER JOIN course AS c
        ON c.id = a.course_id
        WHERE a.course_id = _course_id
        GROUP BY c.id
    )
    SELECT c.id
         , c.name
         , c.code
         , t.id
         , p.full_name
         , var_course_max_points.course_max_points
         , var_course_max_points.course_max_points_weighted
    FROM course as c
    INNER JOIN teacher as t
    ON t.id = c.course_creator_id
    INNER JOIN person as p
    ON p.id = t.person_id
    LEFT JOIN var_course_max_points
    ON var_course_max_points.id = c.id
    WHERE c.id = _course_id;
END
$func$;

SELECT * FROM fun_get_course_info(1);





CREATE OR REPLACE FUNCTION fun_update_course(_course_id int, _course_name text, _course_code text)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    UPDATE course SET name = _course_name, code = _course_code WHERE id = _course_id;
END
$func$;

