


CREATE OR REPLACE FUNCTION fun_add_or_update_evaluation(_assignment_id          int
                                                      , _student_in_course_id   int
                                                      , _teacher_id             int
                                                      , _points                 int)
    RETURNS VOID
    LANGUAGE plpgsql AS
$func$
DECLARE
    var_row_exists boolean;
    var_teacher_in_course_id int;
BEGIN
    var_teacher_in_course_id := (SELECT id FROM teacher_in_course
                                 WHERE course_id IN (SELECT course_id FROM student_in_course WHERE id =_student_in_course_id)
                                   AND teacher_id = _teacher_id);

    IF var_teacher_in_course_id IS NULL THEN
        RAISE EXCEPTION 'there are no teacher in course';
    ELSE
        var_row_exists := (SELECT EXISTS(SELECT * FROM evaluation
                                         WHERE assignment_id = _assignment_id
                                           AND student_in_course_id = _student_in_course_id));
        IF var_row_exists THEN
            UPDATE evaluation SET points = _points, teacher_in_course_id = var_teacher_in_course_id
            WHERE assignment_id = _assignment_id AND student_in_course_id = _student_in_course_id;
        ELSE
            INSERT INTO evaluation (assignment_id, student_in_course_id, teacher_in_course_id, points)
            VALUES (_assignment_id, _student_in_course_id, var_teacher_in_course_id, _points);
        END IF;
    END IF;
END
$func$;


