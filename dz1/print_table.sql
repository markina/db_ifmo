select group_id, group_no from Groups;
select student_id, name, group_id from Students;
select name, group_no
    from Students natural join Groups;
select Students.name, Groups.group_no
    from Students 
         inner join Groups 
         on Students.group_id = Groups.group_id;
