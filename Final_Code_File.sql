DROP DATABASE IF EXISTS SmartShopTech_Inventory_Management;
CREATE DATABASE SmartShopTech_Inventory_Management;
USE SmartShopTech_Inventory_Management;

CREATE TABLE Supplier 
(
	supplier_id INT NOT NULL,
    supplier_name VARCHAR(100) NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    phone_number BIGINT UNIQUE NOT NULL,
    email VARCHAR(100) NOT NULL,
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code INT NOT NULL,
    country VARCHAR(50) NOT NULL,
    
    CONSTRAINT Supplier_PK PRIMARY KEY (supplier_id)
);

CREATE TABLE Purchasing_order
(
	PO_id INT NOT NULL,
    supplier_id INT NOT NULL,
    purchase_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipped_date DATE,
    received_date DATE,
    total DECIMAL(10,2),
    discount DECIMAL(10,2),
    tax DECIMAL(10,2),
    grand_total DECIMAL(10,2) GENERATED ALWAYS AS (total - discount + tax),
    
    CONSTRAINT Purchasing_order_PK PRIMARY KEY (PO_id),
    CONSTRAINT Purchasing_order_FK FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id) ON UPDATE CASCADE
);
    
CREATE TABLE Product
(
	product_id INT NOT NULL,
    category VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    purchase_price DECIMAL(10,2),
    sales_price DECIMAL(10,2),
    quantity_available INT,
    
    CONSTRAINT Product_PK PRIMARY KEY (product_id)
);

CREATE TABLE PO_details
(
	PO_id INT NOT NULL,
    product_id INT NOT NULL,
    purchase_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    
    CONSTRAINT PO_details_PK PRIMARY KEY (PO_id, product_id),
    CONSTRAINT PO_details_FK1 FOREIGN KEY (PO_id) REFERENCES Purchasing_order(PO_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT PO_details_FK2 FOREIGN KEY (product_id) REFERENCES Product(product_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Customer
(
	customer_id INT NOT NULL,
	customer_name VARCHAR(100), 
	phone_number BIGINT UNIQUE NOT NULL,       
	email VARCHAR(100) NOT NULL,
	street_address VARCHAR(255) NOT NULL,
	city VARCHAR(50) NOT NULL,
	state VARCHAR(50) NOT NULL,
	zip_code INT NOT NULL,
	country VARCHAR(50) NOT NULL,

	CONSTRAINT Customer_PK PRIMARY KEY (customer_id)
);

CREATE TABLE Orders
(
	order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    shipped_date DATE,
    delivered_date DATE,
    total DECIMAL(10,2),
    discount DECIMAL(10,2),
    tax DECIMAL(10,2),
    grand_total DECIMAL(10,2) GENERATED ALWAYS AS (total - discount + tax),
    
    CONSTRAINT Orders_PK PRIMARY KEY (order_id),
    CONSTRAINT Orders_FK FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON UPDATE CASCADE
);

CREATE TABLE Order_details
(
	order_id INT NOT NULL,
    product_id INT NOT NULL,
    sales_price DECIMAL(10,2),
    quantity INT NOT NULL,
    
    CONSTRAINT Order_details_PK PRIMARY KEY (order_id, product_id),
    CONSTRAINT Order_details_FK1 FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT Order_details_FK2 FOREIGN KEY (product_id) REFERENCES Product(product_id) ON UPDATE CASCADE ON DELETE CASCADE
);

DELIMITER $$
CREATE TRIGGER update_inventory_increase
AFTER INSERT ON PO_details
FOR EACH ROW
BEGIN
UPDATE Product
SET quantity_available = quantity_available + NEW.quantity
WHERE product_id = NEW.product_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER update_inventory_decrease
AFTER INSERT ON Order_details
FOR EACH ROW
BEGIN
UPDATE Product
SET quantity_available = quantity_available - NEW.quantity
WHERE product_id = NEW.product_id;
END $$
DELIMITER ;

INSERT INTO Supplier VALUES
(1, 'Dell', 'Oliver Montgomery', 15551234567, 'oliver.montgomery@dell.com', '123 Main Street', 'Dallas', 'Texas', 75052, 'United States'),
(2, 'Apple Inc.', 'Ellis Villegas', 14085512150, 'ellis.villegas@apple.com', '1 Apple Park Way', 'Cupertino', 'California', 95014, 'United States'),
(3, 'Samsung Electronics', 'Lee Joon-ho', 82234567890, 'lee.joonho@samsung.com', '456 Seoul Street', 'Seoul', 'Seoul', 04567, 'South Korea'),
(4, 'Beijing Tech', 'Zhang Xiaojie', 861098765432, 'zhang.xiaojie@beijingtech.com', '789 Nanjing Road', 'Beijing', 'Hebei', 100000, 'China'),
(5, 'Sony', 'Yuki Tanaka', 81345678901, 'yuki.tanaka@sony.com', '123 Shibuya Street', 'Tokyo', 'Tokyo', 1080075, 'Japan'),
(6, 'West Coast Distributors', 'Robert Davis', 16262719700, 'robert.davis@westcoastdistributors.com', '987 Washington Street', 'Los Angeles', 'California', 97531, 'United States'),
(7, 'ElectroniTech', 'Sarah Johnson', 18003901119, 'sarah.johnson@eastcoasttraders.com', '456 Elm Avenue', 'Jersey City', 'New Jeysey', 07305, 'United States'),
(8, 'Davies Appliance', 'Emily Kim', 16503665728, 'emily.kim@daviesappliance.com', '1580 El Camino Real', 'Redwood City', 'California', 94063, 'United States'),
(9, 'Global Tech', 'Li Wei', 861012345678, 'li.wei@globaltech.com', '321 Huaihai Road', 'Shanghai', 'Shanghai', 200000, 'China'),
(10, 'China Electro', 'Zhang Wei', 862198765432, 'zhang.wei@chinaelectro.com', '456 Tianhe Road', 'Guangzhou', 'Guangdong', 510000, 'China');

INSERT INTO Product VALUES 
(1, 'Smartphones', 'Apple', 'iPhone 12 Pro', 'A powerful phone with 5G capabilities and advanced camera features', NULL, 1300.00, 0),
(2, 'Smartphones', 'Samsung', 'Galaxy S21', 'A high-end phone with a large screen and excellent camera quality', NULL, 1000.00, 0),
(3, 'Headphones', 'Sony', 'WH-1000XM4 Wireless Headphones', 'Premium noise-canceling headphones with excellent sound quality', NULL, 400.00, 0),
(4, 'TV', 'LG', 'OLED55CXPUA 4K TV', 'A stunning OLED TV with amazing picture quality and smart features', NULL, 2000.00, 0),
(5, 'Laptops', 'Microsoft', 'Surface Laptop 4', 'A powerful laptop with a sleek design and long battery life', NULL, 1300.00, 0),
(6, 'Tablets', 'Samsung', 'Galaxy Tab S7', 'A high-end tablet with a large screen and powerful processor', NULL, 750.00, 0),
(7, 'Gaming', 'Sony', 'PlayStation 5', 'The latest gaming console from Sony with advanced graphics and fast load times', NULL, 600.00, 0),
(8, 'Laptops', 'Apple', 'Macbook Air M2', 'Redesigned around the next-generation M2 chip, MacBook Air is strikingly thin and brings exceptional speed and power efficiency within its durable all‑aluminum enclosure.', NULL, 1300.00, 0),
(9, 'Headphones', 'Bose', 'Bose QuietComfort 45', 'The Bose QuietComfort 45 is a premium noise-canceling headphone that offers exceptional sound quality and comfort.', NULL, 350.00, 0),
(10, 'Smartphones', 'OnePlus', '9 Pro 5G', 'A flagship phone with high-end specs and a fast-charging battery', NULL, 1100.00, 0),
(11, 'TV', 'TCL', 'R655 2022 QLED', 'The TCL R655 2022 QLED is a feature-packed smart TV with a brilliant QLED display, delivering vibrant colors and immersive viewing experiences.', NULL, 750.00, 0),
(12, 'Gaming', 'Microsoft', 'Xbox Series X', 'The latest gaming console from Microsoft with advanced graphics and fast load times', NULL, 600.00, 0),
(13, 'Tablets', 'Apple', 'iPad 10th Gen', 'The Apple iPad 10th Gen is a versatile tablet with a powerful processor and a stunning Retina display, perfect for productivity and entertainment.', NULL, 500.00, 0),
(14, 'Washing Machine', 'Samsung', 'Front Load Washer PMR189', '4.5 cu. ft. Front Load Washer with Vibration Reduction Technology+ in Brushed Black', NULL, 700.00, 0),
(15, 'Refrigerator', 'Insignia', 'Top-Freeze TF123', '11.5 Cu. Ft. Top-Freezer Refrigerator - Stainless steel', NULL, 350.00, 0),
(16, 'Refrigerator', 'LG', 'Max-Freeze MF9QX', '5.79 Cu. Ft. Top-Freezer Refrigerator with Semi Auto Defrost - Platinum Silver', NULL, 400.00, 0),
(17, 'Washing Machine', 'Whirlpool', 'TL786NO', '4.6 Cu. Ft. Top Load Washer with Built-In Water Faucet - White', NULL, 600.00, 0);

# Purchase order of 10 iphones
INSERT INTO Purchasing_order (PO_id, supplier_id, purchase_date, shipped_date, received_date, total, discount, tax) VALUES (1, 2, '2023-01-01', '2023-01-03', '2023-01-05', 12000.00, 1200.00, 1200.00);
INSERT INTO PO_details (PO_id, product_id, purchase_price, quantity) VALUES (1, 1, 1200.00, 10);
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 1) WHERE product_id = 1;

# Purchase order of 10 samsung phones
INSERT INTO Purchasing_order (PO_id, supplier_id, purchase_date, shipped_date, received_date, total, discount, tax) VALUES (2, 3, '2023-01-01', '2023-01-05', '2023-01-10', 8000.00, 0.00, 800.00);
INSERT INTO PO_details (PO_id, product_id, purchase_price, quantity) VALUES (2, 2, 800.00, 10);
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 2) WHERE product_id = 2;

# Purchase order of 10 bose headphones
INSERT INTO Purchasing_order (PO_id, supplier_id, purchase_date, shipped_date, received_date, total, discount, tax) VALUES (3, 6, '2023-01-01', '2023-01-03', '2023-01-04', 2500.00, 200.00, 250.00);
INSERT INTO PO_details (PO_id, product_id, purchase_price, quantity) VALUES (3, 9, 250.00, 10);
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 9) WHERE product_id = 9;

# Purchase order of 5 LG TVs
INSERT INTO Purchasing_order (PO_id, supplier_id, purchase_date, shipped_date, received_date, total, discount, tax) VALUES (4, 4, '2023-01-15', '2023-01-20', '2023-01-27', 7500.00, 750.00, 750.00);
INSERT INTO PO_details (PO_id, product_id, purchase_price, quantity) VALUES (4, 4, 1500.00, 5);
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 4) WHERE product_id = 4;

# Purchase order of 10 Playstation 5
INSERT INTO Purchasing_order (PO_id, supplier_id, purchase_date, shipped_date, received_date, total, discount, tax) VALUES (5, 5, '2023-02-01', '2023-02-10', '2023-02-15', 4000.00, 500.00, 400.00);
INSERT INTO PO_details (PO_id, product_id, purchase_price, quantity) VALUES (5, 7, 400.00, 10);
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 7) WHERE product_id = 7;

# Purchase order of 10 Samsung Tablets
INSERT INTO Purchasing_order (PO_id, supplier_id, purchase_date, shipped_date, received_date, total, discount, tax) VALUES (6, 3, '2023-02-10', '2023-02-15', '2023-02-20', 6000.00, 0.00, 600.00);
INSERT INTO PO_details (PO_id, product_id, purchase_price, quantity) VALUES (6, 6, 600.00, 10);
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 6) WHERE product_id = 6;

# Purchase order of 5 Microsoft Xbox + 10 Microsoft Laptops
INSERT INTO Purchasing_order (PO_id, supplier_id, purchase_date, shipped_date, received_date, total, discount, tax) VALUES (7, 10, '2023-02-11', '2023-02-21', '2023-02-28', 12500.00, 750.00, 1250.00);
INSERT INTO PO_details (PO_id, product_id, purchase_price, quantity) VALUES
(7, 12, 500.00, 5),
(7, 5, 1000.00, 10);
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 12) WHERE product_id = 12;
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 5) WHERE product_id = 5;

# Purchase order of 10 Macbook Air M2
INSERT INTO Purchasing_order (PO_id, supplier_id, purchase_date, shipped_date, received_date, total, discount, tax) VALUES (8, 8, '2023-03-02', '2023-03-04', '2023-03-06', 10000.00, 1000, 1000.00);
INSERT INTO PO_details (PO_id, product_id, purchase_price, quantity) VALUES (8, 8, 1000.00, 10);
UPDATE Product SET purchase_price = (SELECT purchase_price FROM PO_details WHERE product_id = 8) WHERE product_id = 8;

INSERT INTO Customer (customer_id, customer_name, phone_number, email, street_address, city, state, zip_code, country) VALUES
(1, 'John Doe', 2065551234, 'johndoe@example.com', '123 Main St', 'Seattle', 'Washington', 98101, 'United States'),
(2, 'Jane Smith', 5035555678, 'janesmith@example.com', '456 Elm St', 'Portland', 'Oregon', 97204, 'United States'),
(3, 'Michael Johnson', 4155558765, 'michaeljohnson@example.com', '789 Oak St', 'San Francisco', 'California', 94102, 'United States'),
(4, 'Emily Davis', 7025553456, 'emilydavis@example.com', '321 Pine St', 'Las Vegas', 'Nevada', 89101, 'United States'),
(5, 'David Wilson', 4805557890, 'davidwilson@example.com', '987 Cedar St', 'Phoenix', 'Arizona', 85001, 'United States'),
(6, 'Sarah Anderson', 2065552345, 'sarahanderson@example.com', '654 Birch St', 'Seattle', 'Washington', 98104, 'United States'),
(7, 'Christopher Lee', 5035559087, 'christopherlee@example.com', '321 Maple St', 'Portland', 'Oregon', 97205, 'United States'),
(8, 'Jessica Taylor', 4155554567, 'jessicataylor@example.com', '789 Walnut St', 'San Francisco', 'California', 94103, 'United States'),
(9, 'Daniel Clark', 7025556543, 'danielclark@example.com', '456 Pine St', 'Las Vegas', 'Nevada', 89102, 'United States'),
(10, 'Olivia Wright', 4805559876, 'oliviawright@example.com', '123 Oak St', 'Phoenix', 'Arizona', 85002, 'United States');


# Customer no. 1 order of 5 iphones
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (1, 1, '2023-01-06', '2023-01-06', '2023-01-07', 6500.00, 0.00, 650.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES (1, 1, 5);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 1) WHERE product_id = 1;

# Customer no. 2 order of 3 samsung phones
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (2, 2, '2023-01-11', '2023-01-11', '2023-01-12', 3000.00, 0.00, 300.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES (2, 2, 3);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 2) WHERE product_id = 2;

# Customer no. 3 order of 4 bose headphones and 1 samsung phone
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (3, 3, '2023-01-11', '2023-01-11', '2023-01-12', 2400.00, 0.00, 240.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES
(3, 9, 4),
(3, 2, 1);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 9) WHERE product_id = 9;
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 2) WHERE product_id = 2;

# Customer no. 2 again orders 1 iphone
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (4, 2, '2023-01-21', '2023-01-21', '2023-01-22', 1300.00, 0.00, 130.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES (4, 1, 1);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 1) WHERE product_id = 1;

# Customer no. 4 orders 2 LG TVs
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (5, 4, '2023-01-28', '2023-01-28', '2023-01-29', 4000.00, 0.00, 400.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES (5, 4, 2);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 4) WHERE product_id = 4;

# Customer no. 2 again orders 1 more iphone
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (6, 2, '2023-02-15', '2023-02-15', '2023-02-16', 1300.00, 0.00, 130.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES (6, 1, 1);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 1) WHERE product_id = 1;

# Customer no. 5 orders 2 playstation 5 and 2 LG Tvs
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (7, 5, '2023-02-17', '2023-02-17', '2023-01-18', 5200.00, 0.00, 520.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES
(7, 7, 2),
(7, 4, 2);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 7) WHERE product_id = 7;
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 4) WHERE product_id = 4;

# Customer no. 6 orders 7 samsung tablets
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (8, 6, '2023-02-21', '2023-02-21', '2023-01-22', 5250.00, 0.00, 525.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES (8, 6, 7);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 6) WHERE product_id = 6;

# Customer no. 6 again orders 5 playstation 5's and 3 microsoft Xboxs
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (9, 6, '2023-02-28', '2023-02-28', '2023-03-01', 4800.00, 0.00, 480.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES
(9, 7, 5),
(9, 12, 3);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 7) WHERE product_id = 7;
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 12) WHERE product_id = 12;

# Customer no. 7 orders 5 macbook air and 5 microsoft laptops
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (10, 7, '2023-03-06', '2023-03-06', '2023-03-07', 13000.00, 750.00, 1300.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES
(10, 8, 5),
(10, 5, 5);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 8) WHERE product_id = 8;
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 5) WHERE product_id = 5;

# Customer no. 2 again orders 3 samsung phones
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (11, 2, '2023-03-06', '2023-03-06', '2023-03-07', 3000.00, 150.00, 300.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES (11, 2, 3);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 2) WHERE product_id = 2;

# Customer no. 8 orders 4 bose headphones and 4 macbook air
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (12, 8, '2023-03-16', '2023-03-16', '2023-03-17', 6600.00, 600.00, 660.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES
(12, 9, 4),
(12, 8, 4);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 9) WHERE product_id = 9;
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 8) WHERE product_id = 8;

# Customer no. 9 orders 1 iphone and 1 microsoft laptop
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (13, 9, '2023-03-21', '2023-03-21', '2023-03-22', 2600.00, 0.00, 260.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES
(13, 1, 1),
(13, 5, 1);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 1) WHERE product_id = 1;
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 5) WHERE product_id = 5;

# Customer no. 10 orders 2 samsung phones
INSERT INTO Orders (order_id, customer_id, order_date, shipped_date, delivered_date, total, discount, tax) VALUES (14, 10, '2023-03-25', '2023-03-25', '2023-03-26', 2000.00, 0.00, 200.00);
INSERT INTO Order_details (order_id, product_id, quantity) VALUES (14, 2, 2);
UPDATE Order_details SET sales_price = (SELECT sales_price FROM Product WHERE product_id = 2) WHERE product_id = 2;

Select * from Product;
select * from order_details;
select * from orders;
select * from customer;
select * from supplier;
select * from po_details;
select * from purchasing_order;

## Data Analysis ##

#1. What was the total revenue each month arraged in descending order ?
#2. How much business did the company get from each customer ?
#3  What was the revenue earned for each product ?
#4 Which products sold in which month and number of units
#5 How many 
#6 products that need to be ordered
#7 Contry wwise distribution of supplier
#8 count of products by category
#9 highest discounted products
#10 highest taxed products



#1. Total Revenue per month
SELECT DATE_FORMAT(order_date, '%M') AS month, SUM(quantity * sales_price) AS revenue
FROM order_details o inner join orders a  on a.order_id=o.order_id 
GROUP BY month
ORDER BY revenue DESC;

#2. Spending for each customer
SELECT c.customer_name as Name , o.grand_total as Total_order_cost 
from orders o inner join customer c on c.customer_id=o.customer_id 
order by Total_order_cost desc;
 
#3 Revenue earned for each product
SELECT product_name as Name, SUM(quantity * o.sales_price) AS revenue
FROM order_details o inner join product a  on a.product_id=o.product_id 
GROUP BY Name
ORDER BY revenue DESC;

#4 which products sold in which month and number of units
select DATE_FORMAT(b.order_date, '%M') AS month,c.Name ,c.revenue,c.quantity as Quanity  from (SELECT product_name as Name,quantity as quantity, SUM(quantity * o.sales_price) AS revenue,o.order_id as order_id
FROM order_details o inner join product a  on a.product_id=o.product_id
GROUP BY order_id,Name,quantity ) c inner join orders b on b.order_id=c.order_id
GROUP BY month,Name,c.revenue,c.quantity
ORDER BY c.revenue DESC;

#5 How many distinct customers ordered per month
select count(DISTINCT customer_id) as customer_count ,DATE_FORMAT(order_date, '%M') AS month 
from orders group by month order by customer_count desc ;


#6 What are the products that our business has not ordered ever from any supplier
select product_name as Name from product where purchase_price is NULL;

##7 Contry wwise distribution of supplier
select Max(a.grand_total)as Total , c.country from purchasing_order a inner join supplier c on a.supplier_id=c.supplier_id
group by c.country order by Total desc; 

##8 count of products by category
select count(product_id) as Product_units , category from Product group by category order by Product_units desc;

##9 highest discounted products
select p.product_name as Name , max(c.discount) as Discount  from (select o.order_id as order_id , o.discount as discount ,a.product_id as product_id from orders o inner join order_details
a on o.order_id=o.order_id where discount>0 order by discount desc )c inner  join  product p on c.product_id=p.product_id group by Name;

##10  products with highest tax
select p.product_name as Name , max(c.tax) as Tax  from (select o.order_id as order_id , o.tax as tax ,a.product_id as product_id from orders o inner join order_details
a on o.order_id=o.order_id where tax>0 order by tax desc )c inner  join  product p on c.product_id=p.product_id group by Name;

