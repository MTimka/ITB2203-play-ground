

create table person (
    id int generated always as identity,
    full_name text,
    primary key(id)
);

create table teacher (
    id int generated always as identity,
    person_id int,
    primary key(id),
    constraint fk_person foreign key (person_id) references person(id)
);


create table student (
    id int generated always as identity,
    person_id int,
    student_code text,
    primary key(id),
    constraint fk_person foreign key (person_id) references person(id)
);

create table course (
    id int generated always as identity,
    course_creator_id int,
    name text,
    code text,
    primary key(id),
    constraint fk_course_creator foreign key (course_creator_id) references teacher(id)
);

create table teacher_in_course (
    id int generated always as identity,
    teacher_id int,
    course_id int,
    primary key(id),
    constraint fk_teacher foreign key (teacher_id) references teacher(id),
    constraint fk_course foreign key (course_id) references course(id)
);

create table student_in_course (
    id int generated always as identity,
    student_id int,
    course_id int,
    primary key(id),
    constraint fk_student foreign key (student_id) references student(id),
    constraint fk_course foreign key (course_id) references course(id)
);

create table category (
    id int generated always as identity,
    course_id int,
    parent_category_id int,
    name text,
    primary key(id),
    constraint fk_course foreign key (course_id) references course(id),
    constraint fk_parent_category foreign key (parent_category_id) references category(id)
);

create table assignment (
    id int generated always as identity,
    category_id int,
    creator_id int,
    course_id int,
    name text,
    comment text,
    max_points int,
    weight float,
    primary key(id),
    constraint fk_category foreign key (category_id) references category(id),
    constraint fk_creator foreign key (creator_id) references teacher_in_course(id),
    constraint fk_course foreign key (course_id) references course(id)
);

create table evaluation (
    id int generated always as identity,
    student_in_course_id int,
    assignment_id int,
    teacher_in_course_id int,
    points int,
    primary key(id),
    constraint fk_student_in_course foreign key (student_in_course_id) references student_in_course(id),
    constraint fk_assignment foreign key (assignment_id) references assignment(id),
    constraint fk_teacher_in_course foreign key (teacher_in_course_id) references teacher_in_course(id)
);







WITH var_constants(var_course_id) AS (
    values (1)
), var_course AS (
    SELECT SUM(a.max_points * a.weight) as max_course_points
    FROM var_constants as vc, assignment as a
    WHERE a.course_id = vc.var_course_id
), var_grouped_category AS (
    WITH var_assignment AS (
        SELECT * FROM assignment
        WHERE id IN (
            SELECT assignment_id
            FROM evaluation
            WHERE student_in_course_id IN (
                SELECT id
                FROM student_in_course
                WHERE course_id = var_constants.var_course_id))
    )
    SELECT a.id as assignment_id,
        array_agg(cat.id) as category_id,
        array_agg(cat.parent_category_id) as parent_category_id,
        array_agg(cat.name) as category_name
    FROM var_assignment as a
    INNER JOIN category as cat
    ON cat.id IN (
        WITH RECURSIVE blabla AS (
            SELECT id, name, parent_category_id FROM category WHERE id = a.category_id
            UNION
            SELECT t.id, t.name, t.parent_category_id FROM category as t
            INNER JOIN blabla AS d ON d.parent_category_id = t.id
        )
        SELECT id FROM blabla
    )
    GROUP BY a.id
)
SELECT            e.id, e.points, a.max_points, a.weight, s.student_code,
                  p.full_name as "Student Name(Person)",
                  c.name as "Course Name", a.name as "Assignment Name",
                  var_course.max_course_points,
                  var_grouped_category.category_name as "In Category(Grouped)"
FROM              var_constants, var_course, evaluation as e
INNER JOIN        assignment as a
ON                a.id = e.assignment_id
INNER JOIN        student as s
ON                s.id IN (
                      SELECT student_id
                      FROM student_in_course
                      WHERE id = e.student_in_course_id)
INNER JOIN        course as c
ON                c.id IN (
                      SELECT course_id
                      FROM student_in_course
                      WHERE id = e.student_in_course_id)
INNER JOIN        person as p
ON                p.id = s.person_id
INNER JOIN        var_grouped_category
ON                var_grouped_category.assignment_id = a.id
WHERE e.student_in_course_id IN (
  SELECT id
  FROM student_in_course
  WHERE course_id = var_constants.var_course_id);









-- just testing recursively group
--
-- WITH var_assignment AS (
--     SELECT * FROM assignment
--     WHERE id IN (SELECT assignment_id FROM evaluation)
-- )
-- SELECT a.id as assignment_id,
--        array_agg(cat.id) as category_id,
--        array_agg(cat.parent_category_id) as parent_category_id,
--        array_agg(cat.name) as category_name
-- FROM var_assignment as a
-- INNER JOIN category as cat
-- ON cat.id IN (
--     WITH RECURSIVE blabla AS (
--         SELECT id, name, parent_category_id FROM category WHERE id = a.category_id
--         UNION
--         SELECT t.id, t.name, t.parent_category_id FROM category as t
--         INNER JOIN blabla AS d ON d.parent_category_id = t.id
--     )
--     SELECT id FROM blabla
-- )
-- GROUP BY a.id;
--
--
-- WITH RECURSIVE blabla AS (
--     SELECT id, name, parent_category_id FROM category WHERE id = 3
--     UNION
--     SELECT t.id, t.name, t.parent_category_id FROM category as t
--     INNER JOIN blabla AS d ON d.parent_category_id = t.id
-- )
-- SELECT * FROM blabla;
--
-- DEALLOCATE blinblin;
-- PREPARE blinblin (int) AS
--     WITH RECURSIVE blabla AS (
--         SELECT id, name, parent_category_id FROM category WHERE id = $1
--         UNION
--         SELECT t.id, t.name, t.parent_category_id FROM category as t
--         INNER JOIN blabla AS d ON d.parent_category_id = t.id
--     )
--     SELECT * FROM blabla;
-- EXECUTE blinblin(3);


-- more useful commands
--https://stackoverflow.com/questions/7945932/how-to-return-result-of-a-select-inside-a-function-in-postgresql



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


CREATE OR REPLACE FUNCTION fun_get_all_students_in_course(_course_id int)
    RETURNS TABLE (student_id        int
                 , student_code      text
                 , student_name      text)
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    SELECT s.id
         , s.student_code
         , p.full_name
    FROM student_in_course as sic
    INNER JOIN student as s
    ON s.id = sic.student_id
    INNER JOIN person as p
    ON p.id = s.person_id
    WHERE sic.course_id = _course_id;
END
$func$;

SELECT * FROM fun_get_all_students_in_course(1);


CREATE OR REPLACE FUNCTION fun_add_course(_teacher_id int, _course_name text)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    INSERT INTO course(course_creator_id, name) VALUES (_teacher_id, _course_name);
END
$func$;

SELECT fun_add_course(1, 'test');


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




CREATE OR REPLACE FUNCTION fun_get_all_assignments_simple()
    RETURNS TABLE (assignment_id                   int
                 , assignment_name                 text
                 , assignment_comment              text
                 , assignment_max_points           int
                 , assignment_weight               float
                 , category_id_list                int[]
                 , category_name_list              text[]
                 , course_id                       int
                 , course_name                     text
                 , course_code                     text
                 , creator_teacher_in_course_id    int
                 , creator_teacher_name            text)
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    WITH var_grouped_category AS (
        WITH var_assignments AS (
            SELECT * FROM assignment
        )
        SELECT a.id as assignment_id
             , array_agg(cat.id) as category_id
             , array_agg(cat.parent_category_id) as parent_category_id
             , array_agg(cat.name) as category_name
        FROM var_assignments as a
        INNER JOIN category as cat
        ON cat.id IN (
            WITH RECURSIVE blabla AS (
                SELECT id, name, parent_category_id FROM category WHERE id = a.category_id
                UNION
                SELECT t.id, t.name, t.parent_category_id FROM category as t
                INNER JOIN blabla AS d ON d.parent_category_id = t.id
            )
            SELECT id FROM blabla
        )
        GROUP BY a.id
    )
    SELECT a.id
         , a.name
         , a.comment
         , a.max_points
         , a.weight
         , var_grouped_category.category_id
         , var_grouped_category.category_name
         , c.id
         , c.name
         , c.code
         , tic.id
         , p.full_name
    FROM                 assignment as a
    INNER JOIN           category as cat
    ON                   cat.id = a.category_id
    INNER JOIN           course as c
    ON                   c.id = a.course_id
    INNER JOIN           teacher_in_course as tic
    ON                   tic.id = a.creator_id
    INNER JOIN           teacher as t
    ON                   t.id = tic.teacher_id
    INNER JOIN           person as p
    ON                   p.id = t.person_id
    INNER JOIN           var_grouped_category
    ON                   var_grouped_category.assignment_id = a.id;
END
$func$;

SELECT * FROM fun_get_all_assignments_simple();




CREATE OR REPLACE FUNCTION fun_get_assignment_info(_assignment_id int)
    RETURNS TABLE (assignment_id                   int
                 , assignment_name                 text
                 , assignment_comment              text
                 , assignment_max_points           int
                 , assignment_weight               float
                 , category_id_list                int[]
                 , category_name_list              text[]
                 , course_id                       int
                 , course_name                     text
                 , course_code                     text
                 , creator_teacher_in_course_id    int
                 , creator_teacher_name            text
                 , in_group_max_points_weighted    float)
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    WITH var_grouped_category AS (
        WITH var_assignments AS (
            SELECT * FROM assignment
        )
        SELECT a.id as assignment_id
             , array_agg(cat.id) as category_id
             , array_agg(cat.parent_category_id) as parent_category_id
             , array_agg(cat.name) as category_name
        FROM var_assignments as a
        INNER JOIN category as cat
        ON cat.id IN (
            WITH RECURSIVE blabla AS (
                SELECT id, name, parent_category_id FROM category WHERE id = a.category_id
                UNION
                SELECT t.id, t.name, t.parent_category_id FROM category as t
                INNER JOIN blabla AS d ON d.parent_category_id = t.id
            )
            SELECT id FROM blabla
        )
        GROUP BY a.id
    ), var_grouped_category_points AS (
        SELECT a.category_id, SUM(a.max_points * a.weight) as max_points_weighted
        FROM assignment as a
        INNER JOIN var_grouped_category as vgc
        ON vgc.assignment_id = a.id
        WHERE a.category_id IN (SELECT unnest(vgc2.category_id)
                                FROM var_grouped_category as vgc2
                                WHERE vgc.assignment_id = a.id)
        GROUP BY a.category_id
    )
    SELECT a.id
         , a.name
         , a.comment
         , a.max_points
         , a.weight
         , var_grouped_category.category_id
         , var_grouped_category.category_name
         , c.id
         , c.name
         , c.code
         , tic.id
         , p.full_name
         , vgcp.max_points_weighted
    FROM                 assignment as a
    INNER JOIN           category as cat
    ON                   cat.id = a.category_id
    INNER JOIN           course as c
    ON                   c.id = a.course_id
    INNER JOIN           teacher_in_course as tic
    ON                   tic.id = a.creator_id
    INNER JOIN           teacher as t
    ON                   t.id = tic.teacher_id
    INNER JOIN           person as p
    ON                   p.id = t.person_id
    INNER JOIN           var_grouped_category
    ON                   var_grouped_category.assignment_id = a.id
    INNER JOIN           var_grouped_category_points as vgcp
    ON                   vgcp.category_id = a.category_id
    WHERE a.id = _assignment_id;
END
$func$;






CREATE OR REPLACE FUNCTION fun_get_all_categories_simple()
    RETURNS TABLE (category_id           int
                 , category_name         text
                 , category_parent_id    int
                 , category_parent_name  text
                 , course_id             int
                 , course_name           text
                 , course_code           text)
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    SELECT cat.id
         , cat.name
         , cat.parent_category_id
         , p_cat.name
         , c.id
         , c.name
         , c.code
    FROM category as cat
    INNER JOIN course as c
    ON c.id = cat.course_id
    LEFT JOIN category as p_cat
    ON p_cat.id = cat.parent_category_id
    ORDER BY cat.course_id, cat.parent_category_id NULLS FIRST, cat.id;
END
$func$;

SELECT * FROM fun_get_all_categories_simple();





CREATE OR REPLACE FUNCTION fun_get_categories_simple_by_course(_course_id int)
    RETURNS TABLE (category_id           int
                 , category_name         text
                 , category_parent_id    int
                 , category_parent_name  text
                 , course_id             int
                 , course_name           text
                 , course_code           text)
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    SELECT cat.id
         , cat.name
         , cat.parent_category_id
         , p_cat.name
         , c.id
         , c.name
         , c.code
    FROM category as cat
    INNER JOIN course as c
    ON c.id = cat.course_id
    LEFT JOIN category as p_cat
    ON p_cat.id = cat.parent_category_id
    WHERE cat.course_id = _course_id;
END
$func$;

SELECT * FROM fun_get_categories_simple_by_course(1);





CREATE OR REPLACE FUNCTION fun_get_category_info(_category_id int)
    RETURNS TABLE (category_id           int
                 , category_name         text
                 , category_parent_id    int
                 , category_parent_name  text
                 , course_id             int
                 , course_name           text
                 , course_code           text)
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    SELECT cat.id
         , cat.name
         , cat.parent_category_id
         , p_cat.name
         , c.id
         , c.name
         , c.code
    FROM category as cat
    INNER JOIN course as c
    ON c.id = cat.course_id
    LEFT JOIN category as p_cat
    ON p_cat.id = cat.parent_category_id
    WHERE cat.id = _category_id;
END
$func$;




CREATE OR REPLACE FUNCTION fun_add_assignment(_category_id             int
                                            , _teacher_in_course_id    int
                                            , _course_id               int
                                            , _assignment_name         text
                                            , _assignment_comment      text
                                            , _assignment_max_points   int
                                            , _assignment_weight       float)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    INSERT INTO assignment(category_id, creator_id, course_id, name, comment, max_points, weight)
    VALUES (_category_id, _teacher_in_course_id, _course_id, _assignment_name, _assignment_comment, _assignment_max_points, _assignment_weight);
END
$func$;






CREATE OR REPLACE FUNCTION fun_update_assignment(_assignment_id           int
                                               , _category_id             int
                                               , _course_id               int
                                               , _assignment_name         text
                                               , _assignment_comment      text
                                               , _assignment_max_points   int
                                               , _assignment_weight       float)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    UPDATE assignment SET category_id = _category_id
                        , course_id = _course_id
                        , name = _assignment_name
                        , comment = _assignment_comment
                        , max_points = _assignment_max_points
                        , weight = _assignment_weight
    WHERE id = _assignment_id;
END
$func$;





CREATE OR REPLACE FUNCTION fun_update_category(_category_id           int
                                             , _course_id             int
                                             , _parent_category_id    int
                                             , _category_name         text)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    UPDATE category SET course_id = _course_id
                      , parent_category_id = _parent_category_id
                      , name = _category_name
    WHERE id = _category_id;
END
$func$;





CREATE OR REPLACE FUNCTION fun_add_category(_course_id             int
                                          , _parent_category_id    int
                                          , _category_name         text)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    INSERT INTO category(course_id, parent_category_id, name)
    VALUES (_course_id, _parent_category_id, _category_name);
END
$func$;






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






CREATE OR REPLACE FUNCTION fun_get_assignments_simple_by_course(_course_id int)
    RETURNS TABLE (assignment_id                   int
                 , assignment_name                 text
                 , assignment_comment              text
                 , assignment_max_points           int
                 , assignment_weight               float
                 , category_id_list                int[]
                 , category_name_list              text[]
                 , course_id                       int
                 , course_name                     text
                 , course_code                     text
                 , creator_teacher_in_course_id    int
                 , creator_teacher_name            text
                 , in_group_max_points_weighted    float)
    LANGUAGE plpgsql AS
$func$
BEGIN
    RETURN QUERY
    WITH var_assignments AS (
        SELECT * FROM assignment as a1 WHERE a1.course_id = _course_id
    ), var_grouped_category AS (
        SELECT a.id as assignment_id
             , array_agg(cat.id) as category_id
             , array_agg(cat.parent_category_id) as parent_category_id
             , array_agg(cat.name) as category_name
        FROM var_assignments as a
        INNER JOIN category as cat
        ON cat.id IN (
            WITH RECURSIVE blabla AS (
                SELECT id, name, parent_category_id FROM category WHERE id = a.category_id
                UNION
                SELECT t.id, t.name, t.parent_category_id FROM category as t
                INNER JOIN blabla AS d ON d.parent_category_id = t.id
            )
            SELECT id FROM blabla
        )
        GROUP BY a.id
    ), var_grouped_category_points AS (
        SELECT a.category_id, SUM(a.max_points * a.weight) as max_points_weighted
        FROM assignment as a
        INNER JOIN var_grouped_category as vgc
        ON vgc.assignment_id = a.id
        WHERE a.category_id IN (SELECT unnest(vgc2.category_id)
                                FROM var_grouped_category as vgc2
                                WHERE vgc.assignment_id = a.id)
        GROUP BY a.category_id
    )
    SELECT a.id
         , a.name
         , a.comment
         , a.max_points
         , a.weight
         , vgc.category_id
         , vgc.category_name
         , c.id
         , c.name
         , c.code
         , tic.id
         , p.full_name
         , vgcp.max_points_weighted
    FROM                 assignment as a
    INNER JOIN           category as cat
    ON                   cat.id = a.category_id
    INNER JOIN           course as c
    ON                   c.id = a.course_id
    INNER JOIN           teacher_in_course as tic
    ON                   tic.id = a.creator_id
    INNER JOIN           teacher as t
    ON                   t.id = tic.teacher_id
    INNER JOIN           person as p
    ON                   p.id = t.person_id
    INNER JOIN           var_grouped_category as vgc
    ON                   vgc.assignment_id = a.id
    INNER JOIN           var_grouped_category_points as vgcp
    ON                   vgcp.category_id = a.category_id
    WHERE a.course_id = _course_id;
END
$func$;

SELECT * FROM fun_get_assignments_simple_by_course(1);






