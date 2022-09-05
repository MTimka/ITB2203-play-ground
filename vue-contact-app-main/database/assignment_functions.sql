

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




CREATE OR REPLACE FUNCTION fun_add_assignment(_category_id             int
                                            , _teacher_id              int
                                            , _course_id               int
                                            , _assignment_name         text
                                            , _assignment_comment      text
                                            , _assignment_max_points   int
                                            , _assignment_weight       float)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
DECLARE
    var_teacher_in_course_id int;
BEGIN
    var_teacher_in_course_id := (SELECT id FROM teacher_in_course WHERE course_id = _course_id AND teacher_id = _teacher_id);
    IF var_teacher_in_course_id IS NULL THEN
        RAISE EXCEPTION 'there are no teacher in course';
    ELSE
        INSERT INTO assignment(category_id, creator_id, course_id, name, comment, max_points, weight)
        VALUES (_category_id, var_teacher_in_course_id, _course_id, _assignment_name, _assignment_comment, _assignment_max_points, _assignment_weight);
    END IF;

END
$func$;





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




