CREATE SCHEMA order_schema;

CREATE TABLE order_schema.product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    stock_quantity INT
);

INSERT INTO order_schema.product (product_id, product_name, price, stock_quantity)
VALUES
    (1, 'Laptop', 999.99, 50),
    (2, 'Smartphone', 499.99, 100),
    (3, 'Headphones', 149.99, 200),
    (4, 'Monitor', 199.99, 75);

CREATE TABLE order_schema.customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone_number VARCHAR(15)
);

INSERT INTO order_schema.customer (customer_id, first_name, last_name, email, phone_number)
VALUES
    (1, 'John', 'Doe', 'john.doe@example.com', '555-1234'),
    (2, 'Jane', 'Smith', 'jane.smith@example.com', '555-5678'),
    (3, 'Emily', 'Jones', 'emily.jones@example.com', '555-8765');

CREATE TABLE order_schema.status (
    status_id INT PRIMARY KEY,
    status_name VARCHAR(50)
);

INSERT INTO order_schema.status (status_id, status_name)
VALUES
    (1, 'Shipped'),
    (2, 'Pending'),
    (3, 'Cancelled');

CREATE TABLE order_schema.orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    status_id INT,
    FOREIGN KEY (customer_id) REFERENCES order_schema.customer(customer_id),
    FOREIGN KEY (status_id) REFERENCES order_schema.status(status_id)
);

INSERT INTO order_schema.orders (order_id, customer_id, order_date, total_amount, status_id)
VALUES
    (1, 1, '2025-02-15', 1499.98, 1),
    (2, 2, '2025-02-16', 199.99, 2),
    (3, 3, '2025-02-17', 499.99, 1),
    (4, 1, '2025-02-18', 149.99, 3);

CREATE TABLE order_schema.order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES order_schema.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES order_schema.product(product_id)
);

INSERT INTO order_schema.order_items (order_item_id, order_id, product_id, quantity, price)
VALUES
    (1, 1, 1, 1, 999.99), 
    (2, 1, 2, 1, 499.99), 
    (3, 2, 3, 2, 149.99), 
    (4, 3, 2, 1, 499.99), 
    (5, 4, 3, 1, 149.99);

CREATE TABLE order_schema.order_history (
    history_id INT PRIMARY KEY,
    order_id INT,
    status_change_date DATE,
    status_description VARCHAR(100),
    FOREIGN KEY (order_id) REFERENCES order_schema.orders(order_id)
);

INSERT INTO order_schema.order_history (history_id, order_id, status_change_date, status_description)
VALUES
    (1, 1, '2025-02-15', 'Order Placed'),
    (2, 1, '2025-02-16', 'Payment Processed'),
    (3, 2, '2025-02-16', 'Order Placed'),
    (4, 3, '2025-02-17', 'Order Placed'),
    (5, 3, '2025-02-18', 'Payment Processed'),
    (6, 4, '2025-02-18', 'Order Placed');

-- Question 1 Retrieve All Orders with Their Customer Details and Current Status 
SELECT ord.order_id,ord.customer_id,ord.order_date,ord.total_amount,ord.status_id,s.status_name,c.first_name,c.last_name,c.email,c.phone_number FROM order_schema.orders ord 
JOIN order_schema.customer c ON ord.customer_id=c.customer_id 
JOIN order_schema.status s ON s.status_id=ord.status_id;

-- Question 2 Get the Total Value of Orders for a Given Customer in a Specific Time Period
SELECT c.customer_id,c.first_name, c.last_name, SUM(o.total_amount) AS total_order_value
FROM order_schema.orders o
JOIN order_schema.customer c ON o.customer_id = c.customer_id
WHERE o.customer_id = 1 AND o.order_date BETWEEN '2025-02-15' AND '2025-02-18'
GROUP BY c.customer_id;

-- Question 3 Find the Most Expensive Order by Customer  
SELECT o.order_id,c.first_name,c.last_name,o.total_amount FROM order_schema.orders o 
JOIN order_schema.customer c ON o.customer_id=c.customer_id
WHERE total_amount=(SELECT MAX(o2.total_amount) FROM order_schema.orders o2 WHERE o.customer_id=o2.customer_id )
ORDER BY c.customer_id;

-- Question 4 Find the Total Revenue for Each Product Based on Orders
SELECT p.product_id,p.product_name,SUM(oi.quantity * oi.price) AS total_revenue
FROM order_schema.order_items oi
JOIN order_schema.product p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_revenue DESC;

-- Question 5 Write a query to retrieve the order ID, customer ID, and the total 
-- amount of each order. If the total amount is null, display '0.00' instead. 
SELECT o.order_id,o.customer_id,
CASE 
	WHEN o.total_amount IS NULL THEN 0.00
	ELSE o.total_amount
END AS total_amount
FROM order_schema.orders o;

-- Question 6 Retrieve the Order History of a Specific Customer Along with Product Details.  
SELECT oh.history_id,oh.order_id,oh.status_change_date,oh.status_description,p.product_id,p.product_name,oi.quantity,oi.price
FROM order_schema.order_history oh
JOIN order_schema.orders o ON oh.order_id = o.order_id
JOIN order_schema.order_items oi ON o.order_id = oi.order_id
JOIN order_schema.product p ON oi.product_id = p.product_id
WHERE o.customer_id = 1  
ORDER BY oh.status_change_date;

-- Question 7 Get the Average Order Value Per Customer in the Last 30 Days.
SELECT o.customer_id, AVG(o.total_amount) AS avg_order_value
FROM order_schema.orders o
WHERE o.order_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY o.customer_id;

-- Question 8 Get the Top 5 Products with the Highest Number of Orders. 
SELECT p.product_id,p.product_name,COUNT(oi.order_id) AS order_count
FROM order_schema.order_items oi
JOIN order_schema.product p ON oi.product_id = p.product_id
GROUP BY p.product_id ORDER BY order_count DESC LIMIT 5;

-- Question 9
SELECT c.customer_id, c.first_name, c.last_name, c.email, c.phone_number
FROM order_schema.customer c LEFT JOIN order_schema.orders o ON c.customer_id = o.customer_id 
AND o.order_date >= CURRENT_DATE - INTERVAL '60 days'
WHERE o.order_id IS NULL;

-- Question 10
SELECT o.order_id,o.order_date,c.customer_id,c.first_name,c.last_name,p.product_id,p.product_name,
SUM(oi.quantity) AS total_quantity
FROM order_schema.order_items oi
JOIN order_schema.orders o ON oi.order_id = o.order_id
JOIN order_schema.customer c ON o.customer_id = c.customer_id
JOIN order_schema.product p ON oi.product_id = p.product_id
GROUP BY o.order_id, o.order_date, c.customer_id, c.first_name, c.last_name, p.product_id, p.product_name
HAVING SUM(oi.quantity) > 1
ORDER BY o.order_date;

-- Question 11 Retrieve the Number of Orders and Total Revenue for Each Status
SELECT s.status_id,s.status_name,COUNT(o.order_id) AS total_orders,
COALESCE(SUM(o.total_amount), 0.00) AS total_revenue
FROM order_schema.status s
LEFT JOIN order_schema.orders o ON s.status_id = o.status_id
GROUP BY s.status_id, s.status_name
ORDER BY s.status_id;

-- Question 12 Find Customers Who Have Ordered More Than a Specific Product (e.g., "Laptop") 
SELECT c.customer_id,c.first_name,c.last_name,p.product_name,SUM(oi.quantity) AS total_quantity
FROM order_schema.customer c
JOIN order_schema.orders o ON c.customer_id = o.customer_id
JOIN order_schema.order_items oi ON o.order_id = oi.order_id
JOIN order_schema.product p ON oi.product_id = p.product_id
WHERE p.product_name = 'Laptop'
GROUP BY c.customer_id, c.first_name, c.last_name, p.product_name
HAVING SUM(oi.quantity) > 1;

-- Question 13 Find the Products That Have Never Been Ordered  
SELECT p.product_id,p.product_name,p.price,p.stock_quantity
FROM order_schema.product p
LEFT JOIN order_schema.order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- Question 14  Get the Total Quantity of Products Ordered in the Last 7 Days 
SELECT SUM(oi.quantity) AS total_quantity_ordered
FROM order_schema.order_items oi
JOIN order_schema.orders o ON oi.order_id = o.order_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '7 days';

-- Question 15 Create a view named product_details that includes all columns from the product table.
CREATE VIEW order_schema.product_details AS SELECT * FROM order_schema.product;

-- Question 16 Create a view named order_summary that includes the order_id, 
-- customer_id, order_date, total_amount, and status_name (from the status table) for each order.
CREATE VIEW order_schema.order_summary AS
SELECT o.order_id,o.customer_id,o.order_date,o.total_amount,s.status_name
FROM order_schema.orders o
JOIN order_schema.status s ON o.status_id = s.status_id;







