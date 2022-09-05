


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
