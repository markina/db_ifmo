-- 1
SELECT student_id, student_name, group_id FROM student WHERE 
EXISTS (SELECT * FROM student_mark, course WHERE 
    student.student_id = student_mark.student_id 
    AND course.course_id = student_mark.course_id
    AND course.course_name ='Базы данных' 
    AND student_mark.mark = 'A' 
); 

-- 2.1
SELECT student_id, student_name, group_id FROM student WHERE 
NOT EXISTS (SELECT * FROM student_mark, course WHERE   -- не надо испольовать NOT EXISTS, f надо было: .. in
    course.course_name = 'Базы данных'
    AND student_mark.course_id = course.course_id
    AND student_mark.student_id = student.student_id
    AND student_mark.mark IS NOT NULL 
);
-- в datalog 


-- 2.2
SELECT student_id, student_name, group_id FROM student WHERE 
EXISTS (SELECT * FROM student_mark, course WHERE 
    course.course_name ='Базы данных' 
    AND course.course_id = student_mark.course_id
    AND student.student_id = student_mark.student_id 
    AND student_mark.mark IS NULL 
); 

-- 3 
SELECT student_id, student_name, group_id FROM student WHERE 
EXISTS (SELECT * FROM student_mark, lecturer WHERE 
    lecturer.lecturer_name = 'Корнеев'
    AND lecturer.lecturer_id = student_mark.lecturer_id
    AND student.student_id = student_mark.student_id 
    AND student_mark.mark IS NOT NULL 
); 

-- 4 
SELECT student_id FROM student WHERE 
NOT EXISTS (SELECT * FROM student_mark, lecturer WHERE 
    lecturer.lecturer_name = 'Корнеев'
    AND lecturer.lecturer_id = student_mark.lecturer_id
    AND student.student_id = student_mark.student_id 
    AND student_mark.mark IS NOT NULL 
);

-- 5
SELECT student_id, student_name, group_id FROM student WHERE 
NOT EXISTS (SELECT * FROM student_mark m1 WHERE 
	m1.lecturer_id = 1
	AND NOT EXISTS(SELECT * FROM student_mark m2 WHERE 
	    m1.course_id = m2.course_id
	    AND m1.lecturer_id = m2.lecturer_id
	    AND student.student_id = m2.student_id 
	    AND m2.mark IS NOT NULL
	    AND m2.mark <> 'F'
    )
);

-- 6
SELECT student_name, course_name FROM student, course WHERE 
EXISTS (SELECT * FROM student_mark WHERE 
	course.course_id = student_mark.course_id
	AND student.student_id = student_mark.student_id 
	AND student_mark.mark IS NULL 
);

-- 7
SELECT student_id, student_name, group_id FROM student WHERE 
EXISTS (SELECT * FROM student_mark, lecturer WHERE 
	student_mark.lecturer_id = lecturer.lecturer_id
	AND lecturer.lecturer_name = 'Корнеев'
	AND student.student_id = student_mark.student_id 
);


-- 8
SELECT s1.student_name, s2.student_name FROM student s1, student s2 WHERE
s1.student_id <> s2.student_id 
AND NOT EXISTS (SELECT * FROM student_mark m1 WHERE
    s1.student_id = m1.student_id
    AND m1.mark IS NOT NULL
    AND m1.mark <> 'F' 
    AND NOT EXISTS(SELECT * FROM student_mark m2 WHERE
    	s2.student_id = m2.student_id
        AND m1.course_id = m2.course_id
        AND m2.mark IS NOT NULL
        AND m2.mark <> 'F' 
    )
);


