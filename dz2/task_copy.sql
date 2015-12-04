create table Teachers (
	Id int not null primary key,
	FirstName varchar(50) not null,
	SecondName varchar(50) not null,
	Birthday date 
);
create table Subjects (
	Id int not null primary key,
	Name varchar(50) not null,
	Semester int not null
);
create table Groups (
	Id int not null primary key,
	Name varchar(10) not null
);
create table Students (
	Id int not null primary key,
	FirstName varchar(50) not null,
	SecondName varchar(50) not null,
	Birthday date, 
	GroupId int not null 
);
create table Marks (
	Name char not null,
	MarkDate date,
	StudentId int not null,
	SubjectId int not null,
	TeacherId int not null,
	primary key(StudentId, SubjectId)
);

alter table Students
    add constraint students_group_fk foreign key (GroupId) references Groups(Id);
alter table Marks
    add constraint marks_student_fk foreign key (StudentId) references Students(Id);
alter table Marks
    add constraint marks_teachers_fk foreign key (TeacherId) references Teachers(Id);
alter table Marks
    add constraint marks_subject_fk foreign key (SubjectId) references Subjects(Id);
alter table Groups
    add constraint group_name_unique unique (Name);
alter table Subjects
    add constraint subject_name_semester_unique unique (Name, Semester);


insert into Groups
	(Id, Name) values
	(1, 'M3438'),
	(2, 'M3439'),
	(3, 'M3437');

-- select Id, Name from Groups;

insert into Students
	(Id, FirstName, SecondName, GroupId) values
	(1, 'Руслан', 'Ахундов', 1),
	(2, 'Саша', 'Матвеев', 2),
	(3, 'Саша', 'Лукин', 3);
	
insert into Students
	(Id, FirstName, SecondName, Birthday, GroupId) values
	(4, 'Сергей', 'Игушкин', '21.06.1994', 2),
	(5, 'Сергей', 'Скрипников', '01.10.1994', 2);

-- select Id, FirstName, SecondName, Birthday, GroupId from Students;

insert into Subjects
	(Id, Name, Semester) values
	(1, 'Java', 1),
	(2, 'Java', 2),
	(3, 'DM', 1),
	(4, 'DM', 2),
	(5, 'DM', 3),
	(6, 'ЭВМ', 1),
	(7, 'ML', 1);

-- select Id, Name, Semester from Subjects;

insert into Teachers
	(Id, FirstName, SecondName) values
	(1, 'Георгий', 'Корнеев'),
	(2, 'Андрей', 'Станкевич'),
	(3, 'Николай', 'Додонов');

insert into Teachers
	(Id, FirstName, SecondName, Birthday) values
	(4, 'Павел', 'Скаков', '30.12.1987'),
	(5, 'Антон', 'Ковалев', '08.09.1984');

-- select Id, FirstName, SecondName, Birthday from Teachers;

insert into Marks 
	(Name, StudentId, SubjectId, TeacherId) values
	('A', 4, 1, 1),
	('B', 4, 2, 1),
	('B', 4, 3, 2),
	('B', 4, 4, 2),
	('D', 4, 5, 2),
	('A', 4, 6, 4),

	('D', 3, 1, 1),
	('C', 3, 2, 1),
	('F', 3, 3, 2),
	('F', 3, 4, 2),
	('C', 3, 5, 2),
	('D', 3, 6, 4),

	('D', 1, 1, 1),
	('C', 1, 2, 1),
	('B', 1, 3, 2),

	('C', 2, 4, 2),
	('C', 2, 5, 2),
	('D', 2, 6, 4),

	('C', 5, 4, 2),
	('F', 5, 5, 2),
	('D', 5, 6, 4);

-- select Name, StudentId, SubjectId, TeacherId from Marks;

-- insert into Teachers
-- 	(Id, FirstName, SecondName) values
-- 	(1, 'Ошибка', 'Не уникальный ключ');

-- insert into Teachers
-- 	(Id, FirstName) values
-- 	(10, 'Ошибка: не задана фамилия');

-- insert into Subjects
-- 	(Id, Name) values
-- 	(12, 'Ошибка: не задан семестр');

-- insert into Groups
-- 	(Id, Name) values
-- 	(4, 'M3438');   --- error не уникальное имя

-- insert into Students
-- 	(Id, FirstName, SecondName) values
-- 	(4, 'Ошибка', 'Не уникальный ключ', '21.06.1994', 2);

-- insert into Students
-- 	(Id, FirstName, SecondName) values
-- 	(4, 'Ошибка', 'Не задана группа');

-- insert into Marks 
-- 	(Name, StudentId, SubjectId, TeacherId) values
-- 	('A', 4, 1, 1); --- error нельзя сделать несколько оценок для одного студента и одного предмета

-- select m.Name, st.SecondName, su.name, t.secondname from marks m, students st, subjects su, teachers t where m.StudentId = st.id and m.teacherid = t.id and m.subjectid = su.id


-- drop table Marks;
-- drop table Students;
-- drop table Subjects;
-- drop table Groups;
-- drop table Teachers;