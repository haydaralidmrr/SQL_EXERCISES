CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100),
    age INT
);

INSERT INTO customers (name, city, age) VALUES
('Alexandre Dupont', 'Paris', 54),
('Raphael Müller', 'Berlin', 18),
('Sebastian Andersson', 'Stockholm', 14),
('Luisa Rossi', 'Rome', 26),
('Hannah Schmidt', 'Vienna', 35),
('Mateo Fernandez', 'Madrid', 42),
('Elena Kovač', 'Prague', 33),
('Mikhail Ivanov', 'Moscow', 41),
('Sophie Leroy', 'Paris', 28),
('Alessandro Russo', 'Rome', 30),
('Emilia Kowalska', 'Warsaw', 27),
('Lucas Fischer', 'Berlin', 29),
('Nazım Hikmet', 'Istanbul', 32);

select * from customers;


CREATE TABLE orders (
    id SERIAL,
    customer_id INT,
    product_name VARCHAR(100),
    amount INT
);

INSERT INTO orders (customer_id, product_name, amount) VALUES
(1, 'piston', 230),
(2, 'spark plug', 80),
(9, 'brake pads', 440),
(3, 'air filter', 75),
(5, 'car battery', 250),
(8, 'windshield wipers', 300),
(6, 'headlights', 175),
(7, 'tire', 145),
(11, 'alternator', 500),
(13, 'radiator', 145);

select * from orders;

--1-- Hangi sehirlerde otomobil parcaları siparis verilmiştir
SELECT DISTINCT city FROM customers
WHERE id IN(SELECT customer_id FROM orders WHERE customers.id=orders.customer_id);

--2-- Pariste yasayan müsterilerle berlinde yasayan müsterilerin toplam sayısı nedir
SELECT COUNT(*) AS toplam_musteri FROM (
	SELECT * FROM customers WHERE city = 'Paris'
	UNION
	SELECT * FROM customers WHERE city = 'Berlin'
) AS customer;

--3--Istanbulda yasayan musteriler ile romada yasayan musterilerin isimleri nelerdir
SELECT name FROM (
 	SELECT * FROM customers WHERE city = 'Istanbul'
	UNION
	SELECT * FROM customers WHERE city = 'Rome'
) AS names;

--2nd way
SELECT name from customers where city='Istanbul'
UNION ALL
SELECT name from customers where city='Rome';

--4-- otomobil parcası siparis eden müsteriler ile 30 yasından büyük musterilerin toplam sayısı nedir
SELECT COUNT(*) AS toplam_musteri FROM (
	SELECT DISTINCT customer_id FROM orders
	UNION
	SELECT id FROM customers WHERE age > 30
) AS customer;

--5-- Berlinde yasayan müsterilerin adları ile madridde yasayan müsterilerin adlarından farklı olanları listeleyiniz
SELECT name FROM customers WHERE city = 'Berlin'
EXCEPT
SELECT name FROM customers WHERE city = 'Madrid';


--6-- otomobil parcası siparisi veren müsterinin adları ile moskovada yasayan müsterilerin adlarını listeleyiniz.
SELECT name FROM customers WHERE id IN (SELECT customer_id FROM orders)
UNION ALL
SELECT name FROM customers WHERE city = 'Moscow';

--7 -- prague da yasayan müsterilerin adları ile pariste yasayan müsterilerin adlarının kesişimini getirin
SELECT name FROM customers WHERE city = 'Prague'
INTERSECT
SELECT name FROM customers WHERE city = 'Paris';
