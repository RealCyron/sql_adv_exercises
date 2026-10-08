-- Get the names and the quantities in stock for each product.
SELECT productname, unitsinstock 
FROM products;

-- Get a list of customers who are located in 'Germany'.
SELECT customerid, companyname, contactname
FROM customers
WHERE country = 'Germany';

-- Calculate the average days to ship
SELECT 
    AVG(CAST(shippeddate - orderdate AS INTEGER)) AS AvgDaysToShip
FROM orders
WHERE shippeddate IS NOT NULL;

-- Get a list of current products (Product ID and name).
SELECT productid, productname
FROM products
WHERE discontinued = '0';

-- Get a list of the most and least expensive products (name and unit price).
SELECT productname, unitprice
FROM products
WHERE unitprice = (SELECT MAX(unitprice) FROM products)
    OR unitprice = (SELECT MIN(unitprice) FROM products);

-- Alternative solution with CTE for the WHERE clause
WITH min_max_prices AS (
    SELECT MIN(unitprice) AS min_price, MAX(unitprice) AS max_price
    FROM products
)
SELECT productname, unitprice
FROM products
CROSS JOIN min_max_prices
WHERE unitprice = min_price OR unitprice = max_price;

-- Get products that cost less than $20.
SELECT productname, unitprice
FROM products
WHERE unitprice < 20;

-- Get products that cost between $15 and $25
SELECT productname, unitprice
FROM products
WHERE unitprice BETWEEN 15 AND 25;

-- Find the products with prices above the average price.
SELECT productname, unitprice
FROM products
WHERE unitprice > (SELECT AVG(unitprice) FROM products);

-- Alternative solution with CTE for the WHERE clause
WITH avg_price AS (
    SELECT AVG(unitprice) AS avg_price
    FROM products
)
SELECT productname, unitprice
FROM products
-- CROSS JOIN to get the average price for comparison
CROSS JOIN avg_price
WHERE unitprice > avg_price;

-- Find the ten most expensive products
SELECT productname, unitprice
FROM products
ORDER BY unitprice DESC
LIMIT 10;

-- Get a list of discontinued products (Product ID and name).
SELECT productid, productname
FROM products
WHERE discontinued = '1';

-- Count current and discontinued products with CASE statement.
SELECT 
    SUM(CASE WHEN discontinued = '0' THEN 1 ELSE 0 END) AS current_products,
    SUM(CASE WHEN discontinued = '1' THEN 1 ELSE 0 END) AS discontinued_products
FROM products;

-- Find products with less units in stock than the quantity on order.
SELECT productname, unitsinstock, unitsonorder
FROM products
WHERE unitsinstock < unitsonorder;

-- Find the customer who had the highest order amount.
SELECT contactname, SUM(od.unitprice * od.quantity) as total_amount_order
FROM customers as c
JOIN orders as o on c.customerid = o.customerid
JOIN order_details as od on o.orderid = od.orderid
GROUP BY c.customerid
ORDER BY total_amount_order DESC
LIMIT 1;

-- Get orders for a given employee and the according customer.
SELECT o.orderid, o.orderdate,  e.employeeid, e.firstname, e.lastname, c.customerid, c.companyname
FROM employees as e
JOIN orders as o ON e.employeeid = o.employeeid
JOIN customers as c ON o.customerid = c.customerid
WHERE e.employeeid = 1;


-- Find the hiring age of each employee
SELECT employeeid, firstname, lastname, birthdate, hiredate, 
    EXTRACT(YEAR FROM hiredate) - EXTRACT(YEAR FROM birthdate) AS hiring_age
FROM employees;

-- Get number of customers in each city
SELECT city, COUNT(customerid) as num_customers
FROM customers
GROUP BY city;

-- Find the total number of orders placed by each customer.
SELECT c.customerid, c.companyname, COUNT(o.orderid) as num_orders
FROM customers as c
JOIN orders as o ON c.customerid = o.customerid
GROUP BY c.customerid, c.companyname;

-- Get the average price of products for each category.
SELECT c.categoryname, AVG(p.unitprice) as avg_price
FROM products as p
JOIN categories as c ON p.categoryid = c.categoryid
GROUP BY c.categoryname;

-- Get a list of employees and their assigned territories.
SELECT e.employeeid, e.firstname, e.lastname, t.territoryid, t.territorydescription
FROM employees as e
JOIN employee_territories as et ON e.employeeid = et.employeeid
JOIN territories as t ON et.territoryid = t.territoryid;

-- Get the orders that contain products in the 'Beverages' category.
SELECT o.orderid, o.orderdate, c.companyname, p.productname
FROM orders as o
JOIN customers as c ON o.customerid = c.customerid
JOIN order_details as od ON o.orderid = od.orderid
JOIN products as p ON od.productid = p.productid
JOIN categories as cat ON p.categoryid = cat.categoryid
WHERE cat.categoryname = 'Beverages';

-- Get the total number of orders placed in the year 1997.
SELECT COUNT(orderid) as num_orders
FROM orders
WHERE EXTRACT(YEAR FROM orderdate) = 1997; 

-- Find products ordered the most.
SELECT p.productname, SUM(od.quantity) as total_quantity_ordered
FROM products as p
JOIN order_details as od ON p.productid = od.productid
GROUP BY p.productname
ORDER BY total_quantity_ordered DESC
LIMIT 5;

-- Find customers who ordered products in more than one category.
SELECT c.customerid, c.companyname, COUNT(DISTINCT p.categoryid) as num_categories_ordered
FROM customers as c
JOIN orders as o ON c.customerid = o.customerid
JOIN order_details as od ON o.orderid = od.orderid
JOIN products as p ON od.productid = p.productid
GROUP BY c.customerid, c.companyname
HAVING COUNT(DISTINCT p.categoryid) > 1;

-- Generate a summary report for each product category showing the total quantity sold, total sales, and number of orders.
SELECT c.categoryname, 
    SUM(od.quantity) as total_quantity_sold,
    SUM(od.unitprice * od.quantity) as total_sales,
    COUNT(DISTINCT o.orderid) as num_orders
FROM products as p
JOIN order_details as od ON p.productid = od.productid
JOIN categories as c ON p.categoryid = c.categoryid
JOIN orders as o ON od.orderid = o.orderid
GROUP BY c.categoryname;

-- Rank employees based on their total sales.
SELECT e.employeeid, e.firstname, e.lastname, 
    SUM(od.unitprice * od.quantity) as total_sales,
    RANK() OVER (ORDER BY SUM(od.unitprice * od.quantity) DESC) as sales_rank
FROM employees as e
JOIN orders as o ON e.employeeid = o.employeeid
JOIN order_details as od ON o.orderid = od.orderid
GROUP BY e.employeeid, e.firstname, e.lastname;

-- Calculate running total sales per order.
SELECT o.orderid, o.orderdate, 
       SUM(od.quantity * p.unitprice) AS order_sales,
       SUM(SUM(od.quantity * p.unitprice)) OVER (ORDER BY o.orderdate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_sales
FROM orders as o
JOIN order_details as od ON o.orderid = od.orderid
JOIN products as p ON od.productid = p.productid
GROUP BY o.orderid, o.orderdate
ORDER BY o.orderdate;

-- Find the difference in sales between each order and the previous order
SELECT o.orderid, o.orderdate, 
       SUM(od.quantity * p.unitprice) AS order_sales,
       LAG(SUM(od.quantity * p.unitprice)) OVER (ORDER BY orderdate) AS previous_order_sales,
       SUM(od.quantity * p.unitprice) - LAG(SUM(od.quantity * p.unitprice)) OVER (ORDER BY orderdate) AS sales_diff
FROM orders as o
JOIN order_details as od ON o.orderid = od.orderid
JOIN products as p ON od.productid = p.productid
GROUP BY o.orderid, o.orderdate
ORDER BY o.orderdate;

-- Find the total sales per product and then get the top 5 selling products 
WITH product_sales AS (
    SELECT p.productid, p.productname, SUM(od.quantity * p.unitprice) AS total_sales
    FROM products as p
    JOIN order_details as od ON p.productid = od.productid
    GROUP BY p.productid, p.productname
)
SELECT productid, productname, total_sales
FROM product_sales
ORDER BY total_sales DESC
LIMIT 5;
