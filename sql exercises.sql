CREATE TABLE teachers(
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    city VARCHAR(50),
    course_name VARCHAR(100),
    salary REAL
);

INSERT INTO teachers (first_name, last_name, age, city, course_name, salary) VALUES
('Adam', 'Smith', 35, 'New York', 'Web Development', 5000),
('John', 'Doe', 33, 'Los Angeles', 'Data Science', 4000),
('Emily', 'Johnson', 34, 'Boston', 'Database Administration', 3000),
('Michael', 'Brown', 30, 'Houston', 'Database Administration', 3000),
('Sarah', 'Wilson', 30, 'San Francisco', 'Database Management', 3500),
('David', 'Martinez', 36, 'Miami', 'Java Development', 4000.5),
('Laura', 'Garcia', 38, 'Washington D.C.', 'Mobile App Development', 5550),
('Daniel', 'Rodriguez', 44, 'Boston', 'Python Programming', 3999.5),
('Jessica', 'Davis', 32, 'New York', 'Data Science', 2999.5),
('Ashley', 'Hernandez', 32, 'Boston', 'UI/UX Design', 2999.5),
('Jason', 'Perez', 40, 'New York', 'Cybersecurity', 5550),
('Amanda', 'Carter', 32, 'Phoenix', 'Machine Learning', 2550.22),
('Kevin', 'Parker', 34, 'Philadelphia', 'Database Administration', 3000.5),
('Rachel', 'Lopez', 32, 'New York', 'Cybersecurity', 3000.5);


CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100) UNIQUE,
    credit INT,
    course_fee NUMERIC(6, 2),
    start_date DATE,
    finish_date DATE
);

INSERT INTO courses (course_name, credit, course_fee, start_date, finish_date) VALUES
('Web Development', 10, 100.05, '1990-01-10', '1990-02-10'),
('Data Science', 8, 120.25, '1990-02-11', '1990-02-28'),
('Database Administration', 6, 200.15, '1990-03-03', '1990-03-12'),
('Programming Fundamentals', 26, 159.99, '1990-11-03', '1991-01-12'),
('Database Management', 6, 175.55, '1990-01-03', '1990-03-12'),
('Java Development', 12, 299.65, '1990-06-03', '1990-07-12'),
('Mobile App Development', 5, 125.99, '1990-03-03', '1990-03-22'),
('Python Programming', 5, 125.99, '1990-04-03', '1990-04-22'),
('Frontend Development', 10, 199.99, '1990-03-03', '1990-05-31');


SELECT * FROM teachers;
SELECT * FROM courses;

--1-- 35 yasindan kucuk öğretmenlerin verdikleri derslerin isimlerini ve kredi sayılarını listeleyiniz.
--1.yol
SELECT c.course_name , c.credit
from courses c
JOIN teachers t ON t.course_name = c.course_name
WHERE t.age < 35
GROUP BY c.course_name,c.credit;
--2.yol
SELECT course_name, credit 
FROM courses
WHERE course_name IN(SELECT course_name FROM teachers WHERE age<35);

--2 Her bir şehirde verilen derslerin isimlerini ve kredsini listeleyiniz.
SELECT t.city, c.course_name , c.credit
from courses c
JOIN teachers t ON t.course_name = c.course_name
GROUP BY t.city, c.course_name, c.credit;

SELECT city, course_name, (SELECT credit FROM courses c WHERE c.course_name=t.course_name) FROM teachers t;

--3 new yorkta yasayan öğretmenlerin verdiği derslerin isimlerini ve baslangic tarihini listeleyiniz
SELECT t.first_name, c.course_name , c.start_date
from courses c
INNER JOIN teachers t ON t.course_name = c.course_name
WHERE t.city= 'New York'
GROUP BY t.first_name, c.course_name, c.start_date;

SELECT course_name, start_date 
FROM courses
WHERE course_name IN(SELECT course_name FROM teachers WHERE city='New York');

--4 new yorkda yasayan öğretmenlerin isimlerini, verdiği derslerin isimlerini ve bitis tarihini gösteriniz.

SELECT first_name, course_name, (SELECT finish_date from courses c WHERE c.course_name=t.course_name) 
FROM teachers t
WHERE t.city='New York'

SELECT t.first_name, c.course_name , c.finish_date
from courses c
INNER JOIN teachers t ON t.course_name = c.course_name
WHERE t.city= 'New York'
GROUP BY t.first_name, c.course_name, c.finish_date;

-- 5-1990-06-03 tarihinden önce baslayan dersleri veren öğretmenlerin maaslarının ortalamasını bulunuz.

SELECT ROUND(AVG(salary)) FROM teachers 
WHERE course_name IN(SELECT course_name FROM courses WHERE start_date<'1990-06-03');

--6-- 1990 subat ve mayıs ayları arasında baslayan dersleri veren öğretmenlerin toplam maası

SELECT SUM(salary) FROM teachers
WHERE course_name IN (SELECT course_name from courses WHERE start_date BETWEEN '1990-02-01' AND '1990-05-31');


-- 7-- kurs ücreti 125 den fazla olan derslerin isimlerini, kredilerini  ve bu dersleri veren öğretmenlerin
-- max ve min maaslarını bulunuz.

SELECT course_name, credit,
(SELECT MAX(salary) FROM teachers t WHERE t.course_name=c.course_name) AS max_salary ,
(SELECT MIN(salary) FROM teachers t WHERE t.course_name=c.course_name) AS min_salary 
FROM courses c
WHERE course_fee>125;


--8-- yasi 37 den büyük olan öğretmenlerin yasını, java development dersi veren öğretmenlerin minimum yası ile güncelleyniz.
UPDATE teachers
SET age = (SELECT MIN(age) FROM teachers WHERE course_name= 'Java Development')
WHERE age>37;

select * from teachers;


select course_name, start_date from courses c
where EXISTS(select * from teachers t where t.course_name=c.course_name and age>35);


--10-hiçbir öğretmen tarafından verilmeyen dersleri isim, baslangic ve bitis tarihini listeleyeniz.

select course_name, start_date, finish_date from courses c
where NOT EXISTS (select * from teachers t where t.course_name = c.course_name);

--11 maasi ortalama maastan yüksek olan öğretmenin sehrini denver yapınız.
UPDATE teachers
SET city = 'Denver'
WHERE salary > (SELECT AVG(salary) from teachers);
--12- yasi en kücük olan öğretmenin maasini 2 katına cıkarınız.
UPDATE teachers
SET salary = salary*2
WHERE age = (SELECT MIN(age) FROM teachers);