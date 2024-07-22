create database sqlAssignment;

use sqlAssignment;

-- faculty (Khoa trong trường)
create table faculty (
	id decimal primary key,
	name nvarchar(30) not null
);

-- subject (Môn học)
create table subject(
	id decimal primary key,
	name nvarchar(100) not null,
	lesson_quantity decimal(2,0) not null -- tổng số tiết học
);

-- student (Sinh viên)
create table student (
	id decimal primary key,
	name nvarchar(30) not null,
	gender nvarchar(10) not null, -- giới tính
	birthday date not null,
	hometown nvarchar(100) not null, -- quê quán
	scholarship decimal, -- học bổng
	faculty_id decimal not null -- mã khoa
);

-- exam management (Bảng điểm)
create table exam_management(
	id decimal primary key,
	student_id decimal not null,
	subject_id decimal not null,
	number_of_exam_taking decimal not null, -- số lần thi (thi trên 1 lần được gọi là thi lại) 
	mark decimal(4,2) not null -- điểm
);

alter table student 
add constraint fk_Student_Faculty
foreign key (faculty_id) references faculty(id);

alter table exam_management
add constraint fk_Exam_Student
foreign key (student_id) references student(id);

alter table exam_management
add constraint fk_Exam_Subject
foreign key (subject_id) references subject(id);

-- subject
insert into subject (id, name, lesson_quantity) values (1, N'Cơ sở dữ liệu', 45);
insert into subject values (2, N'Trí tuệ nhân tạo', 45);
insert into subject values (3, N'Truyền tin', 45);
insert into subject values (4, N'Đồ họa', 60);
insert into subject values (5, N'Văn phạm', 45);

-- faculty
insert into faculty values (1, N'Anh - Văn');
insert into faculty values (2, N'Tin học');
insert into faculty values (3, N'Triết học');
insert into faculty values (4, N'Vật lý');

-- student
insert into student values (1, N'Nguyễn Thị Hải', N'Nữ', '1990/02/23', N'Hà Nội', 130000, 2);
insert into student values (2, N'Trần Văn Chính', N'Nam', '1992/12/24', N'Bình Định', 150000, 4);
insert into student values (3, N'Lê Thu Yến', N'Nữ', '1990/02/21',  N'TP HCM', 150000, 2);
insert into student values (4, N'Lê Hải Yến', N'Nữ', '1990/02/21',  N'TP HCM', 170000, 2);
insert into student values (5, N'Trần Anh Tuấn', N'Nam', '1990/12/20',  N'Hà Nội', 180000, 1);
insert into student values (6, N'Trần Thanh Mai', N'Nữ', '1991/08/12',  N'Hải Phòng', null, 3);
insert into student values (7, N'Trần Thị Thu Thủy', N'Nữ', '1991/01/02', N'Hải Phòng', 10000, 1);

-- exam_management
insert into exam_management values (1, 1, 1, 1, 3);
insert into exam_management values (2, 1, 2, 2, 6);
insert into exam_management values (3, 1, 3, 1, 5);
insert into exam_management values (4, 2, 1, 1, 4.5);
insert into exam_management values (5, 2, 3, 1, 10);
insert into exam_management values (6, 2, 5, 1, 9);
insert into exam_management values (7, 3, 1, 2, 5);
insert into exam_management values (8, 3, 3, 1, 2.5);
insert into exam_management values (9, 4, 5, 2, 10);
insert into exam_management values (10, 5, 1, 1, 7);
insert into exam_management values (11, 5, 3, 1, 2.5);
insert into exam_management values (12, 6, 2, 1, 6);
insert into exam_management values (13, 6, 4, 1, 10);
insert into exam_management values (14, 6, 5, 2, 7);
insert into exam_management values (15, 6, 1, 2, 7);
insert into exam_management values (16, 5, 2, 1, 2);