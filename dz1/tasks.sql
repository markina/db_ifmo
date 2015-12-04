create database CTD_copy;
create table Groups2 (
    group_id int,
    group_no char(5)
);
create table Students2 (
    student_id int,
    name varchar(30),
    group_id int
);
insert into Groups2
    (group_id, group_no) values
    (1, 'M3438'),
    (2, 'M3439');
insert into Students2
    (student_id, name, group_id) values
    (1, 'Ruslan Ahundov', 1),
    (2, 'Pavel Asadchy', 2),
    (3, 'Eugene Varlamov', 2);
select group_id, group_no from Groups2;
select student_id, name, group_id from Students2;
select name, group_no
    from Students2 natural join Groups2;
select Students2.name, Groups2.group_no
    from Students2 
         inner join Groups2 
         on Students2.group_id = Groups2.group_id;
alter table Groups2
    add constraint group_id_unique unique (group_id);
insert into Groups2 (group_id, group_no) values 
    (1, 'M3437');

alter table Students2 add foreign key (group_id)
    references Groups2 (group_id);
update Students2 set group_id = 5 where student_id = 1;

