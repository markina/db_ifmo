-- (Скрипт создания базы в конце)
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
      WHERE NOT EXISTS (SELECT *          -- не надо использовать exist
                          FROM student_mark m 
                         WHERE m.student_id = student.student_id 
                           AND m.points < 60); 

--- 2 --- 
DELETE FROM student 
      WHERE (SELECT COUNT(*) 
               FROM student_mark m 
              WHERE m.student_id = student.student_id 
                AND m.points < 60) > 2; 

--- 3 ---
DELETE FROM student_group 
    WHERE NOT EXISTS (SELECT * 
                        FROM student 
                       WHERE student.group_id = student_group.group_id);

--- 4 ---
CREATE VIEW losers as 
SELECT * FROM (SELECT s.student_id, s.student_name, (SELECT COUNT(*) 
                                        FROM student_mark m 
                                       WHERE m.student_id = s.student_id 
                                         AND m.points < 60) as debts
                 FROM student s) d 
WHERE debts > 0;


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

CREATE TRIGGER losers_trigger     --- тут надо было использовать materiolase view 
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










Создание базы : 


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
























