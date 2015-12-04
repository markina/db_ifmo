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
	points INT DEFAULT 0,
	lecturer_id INT NOT NULL, 
	student_id INT NOT NULL,
	course_id INT NOT NULL,
	PRIMARY KEY(student_id, course_id),
	CHECK (points between 0 and 100)
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
    REFERENCES student(student_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE;

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
	(4, 'Юра', 1);

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
	(4, 'Кохась');

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
	(4, 4, 1);

-- INSERT INTO student_mark 
-- 	(student_id, course_id, lecturer_id) VALUES
-- 	(1, 1, 3); <------------- ERROR

UPDATE student_mark
   SET points = 100
 WHERE student_id = 1 
   AND course_id = 1 
   AND lecturer_id = 1;

-- Тут надо указать лектора, чтобы не любой лектор мог поставить 
-- оценку по курсу.

UPDATE student_mark
   SET points = 80
 WHERE student_id = 2 
   AND course_id = 1 
   AND lecturer_id = 1;

UPDATE student_mark
   SET points = 70
 WHERE student_id = 4 
   AND course_id = 1 
   AND lecturer_id = 1;

UPDATE student_mark
   SET points = 90
 WHERE student_id = 3 
   AND course_id = 1 
   AND lecturer_id = 1;

-- SELECT st.student_name, c.course_name, l.lecturer_name, sm.points 
--   FROM student_mark sm, student st, course c, lecturer l 
--  WHERE sm.student_id = st.student_id 
--    AND sm.course_id = c.course_id 
--    AND sm.lecturer_id = l.lecturer_id;

--  student_name | course_name | lecturer_name | points 
-- --------------+-------------+---------------+--------
--  Руслан       | c++         | Сорокин       |      0
--  Руслан       | Матан       | Додонов       |      0
--  Руслан       | Java        | Корнеев       |      0
--  Сережа       | c++         | Сорокин       |      0
--  Сережа       | Матан       | Додонов       |      0
--  Сережа       | Java        | Корнеев       |      0
--  Лера         | c++         | Сорокин       |      0
--  Лера         | Матан       | Додонов       |      0
--  Лера         | Java        | Корнеев       |      0
--  Юра          | c++         | Сорокин       |      0
--  Юра          | Матан       | Кохась        |      0
--  Юра          | Java        | Корнеев       |      0
--  Руслан       | Базы данных | Корнеев       |    100
--  Сережа       | Базы данных | Корнеев       |     80
--  Юра          | Базы данных | Корнеев       |     70
--  Лера         | Базы данных | Корнеев       |     90
-- (16 rows)

UPDATE student_mark
   SET points = 81
 WHERE student_id = 3 
   AND course_id = 2 
   AND lecturer_id = 2;

UPDATE student_mark
   SET points = 82
 WHERE student_id = 3 
   AND course_id = 3 
   AND lecturer_id = 3;

UPDATE student_mark
   SET points = 83
 WHERE student_id = 3 
   AND course_id = 4 
   AND lecturer_id = 1;

--  student_name | course_name | lecturer_name | points 
-- --------------+-------------+---------------+--------
--  Руслан       | c++         | Сорокин       |      0
--  Руслан       | Матан       | Додонов       |      0
--  Руслан       | Java        | Корнеев       |      0
--  Сережа       | c++         | Сорокин       |      0
--  Сережа       | Матан       | Додонов       |      0
--  Сережа       | Java        | Корнеев       |      0
--  Юра          | c++         | Сорокин       |      0
--  Юра          | Матан       | Кохась        |      0
--  Юра          | Java        | Корнеев       |      0
--  Руслан       | Базы данных | Корнеев       |    100
--  Сережа       | Базы данных | Корнеев       |     80
--  Юра          | Базы данных | Корнеев       |     70
--  Лера         | Базы данных | Корнеев       |     90
--  Лера         | c++         | Сорокин       |     81
--  Лера         | Матан       | Додонов       |     82
--  Лера         | Java        | Корнеев       |     83


--- 1 --- 
-- Для этого запроса потребовалось изменить ограничение.
ALTER TABLE student_mark DROP CONSTRAINT mark_student; 
--- 
   ALTER TABLE student_mark 
ADD CONSTRAINT mark_student 
   FOREIGN KEY (student_id) 
    REFERENCES student(student_id)
     ON DELETE CASCADE
     ON UPDATE CASCADE;
---

DELETE FROM student 
      WHERE NOT EXISTS (SELECT * 
                          FROM student_mark m 
                         WHERE m.student_id = student.student_id 
                           AND m.points < 60); 

--  student_name | course_name | lecturer_name | points 
-- --------------+-------------+---------------+--------
--  Руслан       | c++         | Сорокин       |      0
--  Руслан       | Матан       | Додонов       |      0
--  Руслан       | Java        | Корнеев       |      0
--  Сережа       | c++         | Сорокин       |      0
--  Сережа       | Матан       | Додонов       |      0
--  Сережа       | Java        | Корнеев       |      0
--  Юра          | c++         | Сорокин       |      0
--  Юра          | Матан       | Кохась        |      0
--  Юра          | Java        | Корнеев       |      0
--  Руслан       | Базы данных | Корнеев       |    100
--  Сережа       | Базы данных | Корнеев       |     80
--  Юра          | Базы данных | Корнеев       |     70
-- (12 rows)


--  student_name | course_name | lecturer_name | points 
-- --------------+-------------+---------------+--------
--  Руслан       | c++         | Сорокин       |      0
--  Руслан       | Матан       | Додонов       |      0
--  Руслан       | Java        | Корнеев       |      0
--  Сережа       | Матан       | Додонов       |      0
--  Сережа       | Java        | Корнеев       |      0
--  Юра          | Матан       | Кохась        |      0
--  Юра          | Java        | Корнеев       |      0
--  Руслан       | Базы данных | Корнеев       |    100
--  Сережа       | Базы данных | Корнеев       |     80
--  Юра          | Базы данных | Корнеев       |     70
--  Сережа       | c++         | Сорокин       |     83
--  Юра          | c++         | Сорокин       |     83
-- (12 rows)

--- 2 --- 
DELETE FROM student 
      WHERE (SELECT COUNT(*) 
               FROM student_mark m 
              WHERE m.student_id = student.student_id 
                AND m.points < 60) > 2; 

--  student_name | course_name | lecturer_name | points 
-- --------------+-------------+---------------+--------
--  Сережа       | Матан       | Додонов       |      0
--  Сережа       | Java        | Корнеев       |      0
--  Юра          | Матан       | Кохась        |      0
--  Юра          | Java        | Корнеев       |      0
--  Сережа       | Базы данных | Корнеев       |     80
--  Юра          | Базы данных | Корнеев       |     70
--  Сережа       | c++         | Сорокин       |     83
--  Юра          | c++         | Сорокин       |     83
-- (8 rows)

--  group_id | group_name 
-- ----------+------------
--         1 | M3437
--         2 | M3438
--         3 | M3439
-- (3 rows)

--- 3 ---
DELETE FROM student_group 
    WHERE NOT EXISTS (SELECT * 
                        FROM student 
                       WHERE student.group_id = student_group.group_id);


--  group_id | group_name 
-- ----------+------------
--         1 | M3437
--         2 | M3438
-- (2 rows)


--- 4 ---
CREATE VIEW losers as 
SELECT * FROM (SELECT s.student_id, s.student_name, (SELECT COUNT(*) 
                                        FROM student_mark m 
                                       WHERE m.student_id = s.student_id 
                                         AND m.points < 60) as debts
                 FROM student s) d 
WHERE debts > 0;

-- student_name | course_name | lecturer_name | points 
-- --------------+-------------+---------------+--------
--  Сережа       | Матан       | Додонов       |      0
--  Сережа       | Java        | Корнеев       |      0
--  Юра          | Матан       | Кохась        |      0
--  Юра          | Java        | Корнеев       |      0
--  Сережа       | Базы данных | Корнеев       |     80
--  Юра          | Базы данных | Корнеев       |     70
--  Сережа       | c++         | Сорокин       |     83
--  Юра          | c++         | Сорокин       |     83
--  Руслан       | Базы данных | Корнеев       |    100
-- (9 rows)

--  student_id | student_name | debts 
-- ------------+--------------+-------
--           2 | Сережа       |     2
--           4 | Юра          |     2
-- (2 rows)

--- 5 ---
-- В postgresql надо для выполнения такого запроса создать функцию.
CREATE TABLE losersT AS (SELECT * FROM losers);

CREATE FUNCTION renew_losersT() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $function$
    BEGIN
        IF TG_OP = 'INSERT' THEN
          INSERT INTO losersT (student_id, student_name, debts) VALUES
          (NEW.student_id, NEW.student_name, NEW.debts);
        ELSIF TG_OP = 'UPDATE' THEN
          UPDATE losersT SET debts = NEW.debts WHERE student_id = NEW.student_id;
        ELSIF TG_OP = 'DELETE' THEN
          DELETE FROM losersT WHERE student_id = NEW.student_id;
        END IF;
        RETURN NEW;  
    END;
$function$;

CREATE TRIGGER losers_trigger 
  INSTEAD OF INSERT OR UPDATE OR DELETE 
  ON losers
  FOR EACH ROW EXECUTE PROCEDURE renew_losersT();

--- 6 --- 
DROP TRIGGER losers_trigger ON losers;

--- 9 --- 
CREATE OR REPLACE FUNCTION ignore_lower_points() 
RETURNS TRIGGER 
LANGUAGE plpgsql
AS $function$
    BEGIN
        NEW.points := GREATEST(NEW.points, OLD.points);
        RETURN NEW;  
    END;
$function$;

CREATE TRIGGER trigger_ignore_lower_points
  BEFORE UPDATE
  ON student_mark
  FOR EACH ROW EXECUTE PROCEDURE ignore_lower_points();
