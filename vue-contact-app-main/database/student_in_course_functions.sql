


CREATE OR REPLACE FUNCTION fun_add_student_to_course(_student_id int, _course_id int)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    INSERT INTO student_in_course (student_id, course_id) VALUES (_student_id, _course_id);
END
$func$;




CREATE OR REPLACE FUNCTION fun_remove_student_from_course(_student_id int, _course_id int)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
BEGIN
    DELETE FROM student_in_course WHERE student_id = _student_id AND course_id = _course_id;
END
$func$;
