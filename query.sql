use sqlassignment;

-- 1. Liệt kê danh sách sinh viên sắp xếp theo thứ tự:
--      a. id tăng dần
select * from student order by id asc;
--      b. giới tính
select * from student order by gender;
--      c. ngày sinh TĂNG DẦN và học bổng GIẢM DẦN
select * from student order by birthday asc, scholarship desc;

-- 2. Môn học có tên bắt đầu bằng chữ 'T'
select * from subject where name like 'T%';

-- 3. Sinh viên có chữ cái cuối cùng trong tên là 'i'
select * from student where name like '%i';

-- 4. Những khoa có ký tự thứ hai của tên khoa có chứa chữ 'n'
select * from faculty where name like '_n%';

-- 5. Sinh viên trong tên có từ 'Thị'
select * from student where name like '%Thị%';

-- 6. Sinh viên có ký tự đầu tiên của tên nằm trong khoảng từ 'a' đến 'm', sắp xếp theo họ tên sinh viên
select * from student where name like '[a-m]%' order by name;

-- 7. Sinh viên có học bổng lớn hơn 100000, sắp xếp theo mã khoa giảm dần
select * from student where (scholarship > 100000) order by faculty_id desc;

-- 8. Sinh viên có học bổng từ 150000 trở lên và sinh ở Hà Nội
select * from student where (scholarship >= 150000) and (hometown = 'Hà Nội');

-- 9. Những sinh viên có ngày sinh từ ngày 01/01/1991 đến ngày 05/06/1992
select * from student where birthday between '01/01/1991' and '05/06/1992';

-- 10. Những sinh viên có học bổng từ 80000 đến 150000
select * from student where scholarship between 80000 and 150000;

-- 11. Những môn học có số tiết lớn hơn 30 và nhỏ hơn 45
select * from subject where (lesson_quantity > 30) and (lesson_quantity < 45);

-------------------------------------------------------------------

/********* B. CALCULATION QUERY *********/

-- 1. Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh viên, Giới tính, Mã 
		-- khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị là “Học bổng cao” nếu giá trị 
		-- của học bổng lớn hơn 500,000 và ngược lại hiển thị là “Mức trung bình”.
select id, gender, faculty_id, scholarship, if(scholarship > 500000, 'Học bổng cao', 'Mức trung bình') as scholarship_level from student;
        
-- 2. Tính tổng số sinh viên của toàn trường
select count(*) as tong_sinh_vien from student;

-- 3. Tính tổng số sinh viên nam và tổng số sinh viên nữ.
select count(*) as tong_sinh_vien_nam, (select count(*) from student where gender = 'Nữ') as tong_sinh_vien_nu from student where gender = 'Nam';

-- 4. Tính tổng số sinh viên từng khoa
select faculty.name, count(*) as tong_sinh_vien_khoa from faculty, student where faculty.id = student.faculty_id group by faculty.name;

-- 5. Tính tổng số sinh viên của từng môn học
select subject.name, count(*) as tong_sinh_vien_mon from subject, student, exam_management 
where subject.id = exam_management.subject_id and student.id = exam_management.student_id
group by subject.name;

-- 6. Tính số lượng môn học mà sinh viên đã học
select student.id, student.name, count(*) as tong_so_luong_mon_hoc from subject, student, exam_management 
where subject.id = exam_management.subject_id and student.id = exam_management.student_id
group by student.id;

-- 7. Tổng số học bổng của mỗi khoa	
select faculty.name, count(*) as tong_so_hoc_bong from faculty, student 
where faculty.id = student.faculty_id and (student.scholarship > 0)
group by faculty.name;

-- 8. Cho biết học bổng cao nhất của mỗi khoa
select faculty.name , max(student.scholarship) as hoc_bong_cao_nhat from faculty, student
where faculty.id = student.faculty_id
group by faculty.name;

-- 9. Cho biết tổng số sinh viên nam và tổng số sinh viên nữ của mỗi khoa
select faculty.id, faculty.name, 
count(case when gender = 'Nam' then 1 end) as tong_sinh_vien_nam, count(case when gender = 'Nữ' then 1 end) as tong_sinh_vien_nu 
from faculty, student
where faculty.id = student.faculty_id
group by faculty.id;

-- 10. Cho biết số lượng sinh viên theo từng độ tuổi
select count(*) as so_luong_vinh_vien, (year(current_date()) - year(student.birthday)) as tuoi from student 
group by tuoi
order by tuoi;

-- 11. Cho biết những nơi nào có ít nhất 2 sinh viên đang theo học tại trường
select student.hometown, count(*) as so_luong_sinh_vien from student
group by student.hometown
having count(*) >= 2;

-- 12. Cho biết những sinh viên thi lại ít nhất 2 lần
select student.id, student.name, count(exam_management.number_of_exam_taking) as so_lan_thi from exam_management, student
where exam_management.student_id = student.id and exam_management.number_of_exam_taking > 1
group by student.id, student.name
having count(exam_management.number_of_exam_taking) > 1;

-- 13. Cho biết những sinh viên nam có điểm trung bình lần 1 trên 7.0 
select student.id, student.name, avg(exam_management.mark) as diem_trung_binh from exam_management, student
where exam_management.student_id = student.id and student.gender = 'Nam' and exam_management.number_of_exam_taking = 1
group by student.id, student.name
having avg(exam_management.mark) > 7.0;

-- 14. Cho biết danh sách các sinh viên rớt ít nhất 2 môn ở lần thi 1 (rớt môn là điểm thi của môn không quá 4 điểm)
select student.id, student.name, count(*) as so_mon_rot from exam_management, student
where exam_management.student_id = student.id and exam_management.number_of_exam_taking = 1 and exam_management.mark <= 4
group by student.id, student.name
having count(*) >= 2;

-- 15. Cho biết danh sách những khoa có nhiều hơn 2 sinh viên nam
select faculty.name, count(student.gender) as so_luong_nam_sinh_vien from faculty, student
where faculty.id = student.faculty_id and student.gender = 'Nam'
group by faculty.name;

-- 16. Cho biết những khoa có 2 sinh viên đạt học bổng từ 200000 đến 300000
select faculty.id, faculty.name as ten_khoa, count(student.id) as so_hoc_bong from faculty, student
where faculty.id = student.faculty_id and student.scholarship between 200000 and 300000
group by faculty.id
having count(student.id) >= 2;

-- 17. Cho biết sinh viên nào có học bổng cao nhất
select * from student where scholarship = (select max(scholarship) from student);

-------------------------------------------------------------------

/********* C. DATE/TIME QUERY *********/

-- 1. Sinh viên có nơi sinh ở Hà Nội và sinh vào tháng 02
select * from student where hometown = 'Hà Nội' and month(birthday) = 2;

-- 2. Sinh viên có tuổi lớn hơn 20
select id, name, (year(current_date()) - year(birthday)) as tuoi from student 
where (year(current_date()) - year(student.birthday)) > 20;

-- 3. Sinh viên sinh vào mùa xuân năm 1990
select * from student where year(birthday) = 1990 and (month(birthday) between 1 and 3);


-------------------------------------------------------------------


/********* D. JOIN QUERY *********/

-- 1. Danh sách các sinh viên của khoa ANH VĂN và khoa VẬT LÝ
select student.name, faculty.name as tenKhoa from student join faculty on faculty.id = student.faculty_id
where faculty.name = 'Anh - Văn' or faculty.name = 'Vật lý';

-- 2. Những sinh viên nam của khoa ANH VĂN và khoa TIN HỌC
select student.name, faculty.name as tenKhoa from student join faculty on faculty.id = student.faculty_id
where student.gender = 'Nam' and (faculty.name = 'Anh - Văn' or faculty.name = 'Vật lý');

-- 3. Cho biết sinh viên nào có điểm thi lần 1 môn cơ sở dữ liệu cao nhất
select student.name, subject.name as ten_mon, exam_management.mark as diem
from student
inner join exam_management on exam_management.student_id = student.id
inner join subject on subject.id = exam_management.subject_id
where subject.name = 'Cơ sở dữ liệu' and exam_management.number_of_exam_taking = 1
and mark = (select max(mark) from exam_management join subject on subject.id = exam_management.subject_id  
where exam_management.number_of_exam_taking = 1 and subject.name = 'Cơ sở dữ liệu'); 

-- 4. Cho biết sinh viên khoa anh văn có tuổi lớn nhất.
select student.name, faculty.name as tenKhoa, (year(current_date()) - year(student.birthday)) as tuoi
from student
join faculty on faculty.id = student.faculty_id
where faculty.name = 'Anh - Văn'
and (year(current_date()) - year(student.birthday)) = (select max(year(current_date())-year(student.birthday)) 
from student join faculty on student.faculty_id = faculty.id 
where faculty.name = 'Anh - Văn');

-- 5. Cho biết khoa nào có đông sinh viên nhất
select faculty.name as tenKhoa, count(student.id) as tong_sinh_vien 
from faculty
join student on faculty.id = student.faculty_id
group by faculty.name
having count(student.id) =  (select max(tongSV) from 
(
	select count(student.id) as tongSV from faculty join student on faculty.id = student.faculty_id group by faculty.id
) as maxTongSV);

-- 6. Cho biết khoa nào có đông nữ nhất
select faculty.name as tenKhoa, count(student.id) as tong_sinh_vien_nu 
from faculty
join student on faculty.id = student.faculty_id
where student.gender = 'Nữ'
group by faculty.name
having count(student.id) =  (select max(tongSV) from 
(
	select count(student.id) as tongSV from faculty join student on faculty.id = student.faculty_id where student.gender = 'Nữ'
    group by faculty.id
) as maxTongSV);

-- 7. Cho biết những sinh viên đạt điểm cao nhất trong từng môn
select subject.name as ten_mon, student.name as ten_sinh_vien, exam_management.mark as diem_cao_nhat
from (
	select subject_id, MAX(mark) as max_mark from exam_management group by subject_id
) as max_marks
join exam_management on exam_management.subject_id = max_marks.subject_id AND exam_management.mark = max_marks.max_mark
join student on student.id = exam_management.student_id
join subject on subject.id = exam_management.subject_id;
    
-- 8. Cho biết những khoa không có sinh viên học
select faculty.name as ten_khoa from faculty left join student on student.faculty_id = faculty.id
group by faculty.name
having count(student.id) = 0;

-- 9. Cho biết sinh viên chưa thi môn cơ sở dữ liệu
select s.name from student s 
left join exam_management em on s.id = em.student_id and em.subject_id = (select id from subject where name = 'Cơ sở dữ liệu')
where em.student_id is null;

-- 10. Cho biết sinh viên nào không thi lần 1 mà có dự thi lần 2
select s.id, s.name, em2.subject_id as ma_mon_hoc from student s
left join exam_management em1 on s.id = em1.student_id and em1.number_of_exam_taking = 1
left join exam_management em2 on s.id = em2.student_id and em2.number_of_exam_taking = 2
WHERE em1.id is null and em2.id is not null;