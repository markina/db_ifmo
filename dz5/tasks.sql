CREATE TABLE student (
	student_id  INT NOT NULL PRIMARY KEY,
	student_name VARCHAR(50) NOT NULL,
	group_id INT NOT NULL 
);

CREATE TABLE student_group (
	group_id INT NOT NULL PRIMARY KEY,
	group_name VARCHAR(10) NOT NULL
);

CREATE TABLE course (
	course_id INT NOT NULL PRIMARY KEY,
	course_name VARCHAR(100) NOT NULL
);

CREATE TABLE lecturer (
	lecturer_id INT NOT NULL PRIMARY KEY,
	lecturer_name VARCHAR(50) NOT NULL
);

CREATE TABLE student_mark (
	mark VARCHAR(1),
	lecturer_id INT NOT NULL, 
	student_id INT NOT NULL,
	course_id INT NOT NULL,
	PRIMARY KEY(student_id, course_id)
);

   ALTER TABLE student
ADD CONSTRAINT student_group 
   FOREIGN KEY (group_id) 
    REFERENCES student_group(group_id);

   ALTER TABLE student_mark 
ADD CONSTRAINT mark_lecturer 
   FOREIGN KEY (lecturer_id) 
    REFERENCES lecturer(lecturer_id);

   ALTER TABLE student_mark 
ADD CONSTRAINT mark_course 
   FOREIGN KEY (course_id) 
    REFERENCES course(course_id);

   ALTER TABLE student_mark 
ADD CONSTRAINT mark_student 
   FOREIGN KEY (student_id) 
    REFERENCES student(student_id);

INSERT INTO student_group
	(group_id, group_name) VALUES
	(1, 'M3437'),
	(2, 'M3438'),
	(3, 'M3439');

INSERT INTO student
	(student_id, student_name, group_id) VALUES
	(1, 'Руслан', 2),
	(2, 'Сережа', 2),
	(3, 'Лера', 3),
	(4, 'Юра', 1),
	(5, 'Лена', 3),
	(6, 'Никита', 2),
	(7, 'Дима', 2);

INSERT INTO course
	(course_id, course_name) VALUES
	(1, 'Базы данных'),
	(2, 'c++'),
	(3, 'Матан'),
	(4, 'Java');

INSERT INTO lecturer
	(lecturer_id, lecturer_name) VALUES
	(1, 'Корнеев'),
	(2, 'Сорокин'),
	(3, 'Додонов'),
	(4, 'Кохась'),
	(5, 'Суслина');

INSERT INTO student_mark 
	(student_id, course_id, lecturer_id) VALUES
	(1, 1, 1),
	(1, 2, 2),
	(1, 3, 3),
	(1, 4, 1),
	(2, 1, 1),
	(2, 2, 2),
	(2, 3, 3),
	(2, 4, 1),
	(3, 1, 1),
	(3, 2, 2),
	(3, 3, 3),
	(3, 4, 1),
	(4, 1, 1),
	(4, 2, 2),
	(4, 3, 4), -- У этого студнта иной препод по матану, чем у других
	(4, 4, 1),
	(5, 1, 1),
	(5, 2, 2),
	(5, 3, 3),
	(5, 4, 1),
	(6, 1, 1),
	(6, 2, 2),
	(6, 3, 3),
	(6, 4, 1);


-- INSERT INTO student_mark 
-- 	(student_id, course_id, lecturer_id) VALUES
-- 	(1, 1, 3); <------------- ERROR

UPDATE student_mark
   SET mark = 'A'
 WHERE student_id = 1 
   AND course_id = 1 
   AND lecturer_id = 1;

-- Тут надо указать лектора, чтобы не любой лектор мог поставить 
-- оценку по курсу.

UPDATE student_mark
   SET mark = 'C'
 WHERE student_id = 2 
   AND course_id = 1 
   AND lecturer_id = 1;

UPDATE student_mark
   SET mark = 'D'
 WHERE student_id = 4 
   AND course_id = 1 
   AND lecturer_id = 1;

UPDATE student_mark
   SET mark = 'B'
 WHERE student_id = 3 
   AND course_id = 1 
   AND lecturer_id = 1;


-- SELECT st.student_name, c.course_name, l.lecturer_name, sm.mark 
--   FROM student_mark sm, student st, course c, lecturer l 
--  WHERE sm.student_id = st.student_id 
--    AND sm.course_id = c.course_id 
--    AND sm.lecturer_id = l.lecturer_id;

--  student_name | course_name | lecturer_name | mark 
-- --------------+-------------+---------------+------
--  Руслан       | c++         | Сорокин       | 
--  Руслан       | Матан       | Додонов       | 
--  Руслан       | Java        | Корнеев       | 
--  Сережа       | c++         | Сорокин       | 
--  Сережа       | Матан       | Додонов       | 
--  Сережа       | Java        | Корнеев       | 
--  Лера         | c++         | Сорокин       | 
--  Лера         | Матан       | Додонов       | 
--  Лера         | Java        | Корнеев       | 
--  Юра          | c++         | Сорокин       | 
--  Юра          | Матан       | Кохась        | 
--  Юра          | Java        | Корнеев       | 
--  Руслан       | Базы данных | Корнеев       | A
--  Сережа       | Базы данных | Корнеев       | C
--  Юра          | Базы данных | Корнеев       | D
--  Лера         | Базы данных | Корнеев       | B
-- (16 rows)

-- 1
SELECT student.*
  FROM student INNER JOIN student_mark ON student.student_id = student_mark.student_id AND mark = 'A' AND course_id = 1;


-- 2.1
SELECT * FROM student EXCEPT SELECT student.*
  FROM student INNER JOIN student_mark ON student.student_id = student_mark.student_id AND (mark IS NOT NULL) AND course_id = 1;

-- 2.2
SELECT student.*
  FROM student INNER JOIN student_mark ON student.student_id = student_mark.student_id AND mark IS NULL AND course_id = 1;

-- 3 
SELECT student.*
  FROM student INNER JOIN student_mark ON student.student_id = student_mark.student_id AND mark IS NOT NULL AND lecturer_id = 1;

-- 4 
SELECT student.student_id FROM student EXCEPT SELECT student.student_id
  FROM student INNER JOIN student_mark ON student.student_id = student_mark.student_id AND mark IS NOT NULL AND lecturer_id = 1;

-- 5
-- 6
SELECT student_name, course_id 
  FROM student INNER JOIN student_mark ON student.student_id = student_mark.student_id AND mark IS NULL;

-- 7
SELECT DISTINCT student.*  
  FROM student INNER JOIN student_mark ON student.student_id = student_mark.student_id AND lecturer_id = 1;

-- 8 
