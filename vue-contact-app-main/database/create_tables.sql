

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
    constraint fk_teacher_in_course foreign key (teacher_in_course_id) references teacher_in_course(id) on delete cascade
);
