


CREATE OR REPLACE FUNCTION fun_get_all_students_simple()
    RETURNS TABLE (student_id              int
                 , student_name            text
                 , student_code            text
                 , in_courses_id_list      int[]
                 , in_courses_name_list    text[])
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    WITH var_grouped_courses AS (
        SELECT sic.student_id
             , array_agg(c.id) as course_id
             , array_agg(c.name) as course_name
        FROM student_in_course AS sic
        INNER JOIN course as c
        ON c.id = sic.course_id
        GROUP BY sic.student_id
    )
    SELECT s.id
         , p.full_name
         , s.student_code
         , var_grouped_courses.course_id
         , var_grouped_courses.course_name
    FROM student as s
    INNER JOIN person as p
    ON p.id = s.person_id
    LEFT JOIN var_grouped_courses
    ON var_grouped_courses.student_id = s.id;
END
$func$;

SELECT * FROM fun_get_all_students_simple();





CREATE OR REPLACE FUNCTION fun_get_student_info(_student_id int)
    RETURNS TABLE (student_id              int
                 , student_name            text
                 , student_code            text
                 , in_courses_id_list      int[]
                 , in_courses_name_list    text[])
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    WITH var_grouped_courses AS (
        SELECT sic.student_id
             , array_agg(c.id) as course_id
             , array_agg(c.name) as course_name
        FROM student_in_course AS sic
        INNER JOIN course as c
        ON c.id = sic.course_id
        WHERE sic.student_id = _student_id
        GROUP BY sic.student_id
    )
    SELECT s.id
         , p.full_name
         , s.student_code
         , var_grouped_courses.course_id
         , var_grouped_courses.course_name
    FROM student as s
    INNER JOIN person as p
    ON p.id = s.person_id
    LEFT JOIN var_grouped_courses
    ON var_grouped_courses.student_id = s.id
    WHERE s.id = _student_id;
END
$func$;

SELECT * FROM fun_get_student_info(1);






CREATE OR REPLACE FUNCTION fun_get_students_by_course(_course_id int)
    RETURNS TABLE (student_id                   int
                 , student_name                 text
                 , student_code                 text
                 , student_in_course_id         int
                 , weighted_evaluation          float
                 , evaluation_id_list           int[]
                 , assignment_id_list           int[]
                 , evaluation_points_list       int[]
                 , assignment_max_points_list   int[]
                 , assignment_weight_list       float[]
                 , assignment_name_list         text[])
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    WITH var_grouped_evaluations AS (
        SELECT sic.student_id
             , array_agg(e.id) as evaluation_ids
             , array_agg(e.points) as evaluation_points
             , array_agg(a.id) as assignment_ids
             , array_agg(a.name) as assignment_names
             , array_agg(a.max_points) as assignment_max_points
             , array_agg(a.weight) as assignment_weights
             , SUM(e.points * a.weight) as weighted_evaluation
        FROM student_in_course AS sic
        INNER JOIN evaluation as e
        ON e.student_in_course_id = sic.id
        INNER JOIN assignment as a
        ON a.id = e.assignment_id
        GROUP BY sic.student_id
    )
    SELECT s.id
         , p.full_name
         , s.student_code
         , sic.id
         , var_grouped_evaluations.weighted_evaluation
         , var_grouped_evaluations.evaluation_ids
         , var_grouped_evaluations.assignment_ids
         , var_grouped_evaluations.evaluation_points
         , var_grouped_evaluations.assignment_max_points
         , var_grouped_evaluations.assignment_weights
         , var_grouped_evaluations.assignment_names
    FROM student as s
    INNER JOIN person as p
    ON p.id = s.person_id
    INNER JOIN student_in_course as sic
    ON sic.student_id = s.id
    LEFT JOIN var_grouped_evaluations
    ON var_grouped_evaluations.student_id = s.id
    WHERE sic.course_id = _course_id;
END
$func$;

SELECT * FROM fun_get_students_by_course(1);






CREATE OR REPLACE FUNCTION fun_update_student(_student_id int, _student_name text, _student_code text)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    UPDATE student SET student_code = _student_code WHERE id = _student_id;
    UPDATE person SET full_name = _student_name WHERE id IN (SELECT person_id
                                                             FROM student
                                                             WHERE id = _student_id);
END
$func$;





CREATE OR REPLACE FUNCTION fun_add_student(_student_name text, _student_code text)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
DECLARE
    var_inserted_id int;
BEGIN
    INSERT INTO person (full_name) VALUES (_student_name);
    var_inserted_id := (SELECT currval('person_id_seq'));
    INSERT INTO student (person_id, student_code) VALUES (var_inserted_id, _student_code);
END
$func$;

