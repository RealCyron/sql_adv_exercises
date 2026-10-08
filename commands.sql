SELECT productname, unitsinstock 
FROM products;

SELECT customerid, companyname, contactname
FROM customers
WHERE country = 'Germany';

SELECT 
    AVG(CAST(shippeddate - orderdate AS INTEGER)) AS AvgDaysToShip
FROM orders
WHERE shippeddate IS NOT NULL;

SELECT productid, productname
FROM products
WHERE discontinued = '0';

SELECT productname, unitprice
FROM products
WHERE unitprice = (SELECT MAX(unitprice) FROM products)
OR unitprice = (SELECT MIN(unitprice) FROM products);

SELECT productname, unitprice
FROM products
WHERE unitprice < 20;

SELECT productname, unitprice
FROM products
WHERE unitprice BETWEEN 15 AND 25;

SELECT productname, unitprice
FROM products
WHERE unitprice > (SELECT AVG(unitprice) FROM products);

SELECT productname, unitprice
FROM products
ORDER BY unitprice DESC
LIMIT 10;

SELECT productid, productname
FROM products
WHERE discontinued = '1';

SELECT 
    SUM(CASE WHEN discontinued = '0' THEN 1 ELSE 0 END) AS current_products,
    SUM(CASE WHEN discontinued = '1' THEN 1 ELSE 0 END) AS discontinued_products
FROM products;

SELECT productname, unitsinstock, unitsonorder
FROM products
WHERE unitsinstock < unitsonorder;

SELECT contactname, SUM(od.unitprice * od.quantity) as total_amount_order
FROM customers as c
JOIN orders as o on c.customerid = o.customerid
JOIN order_details as od on o.orderid = od.orderid
GROUP BY c.customerid
ORDER BY total_amount_order DESC
LIMIT 1;

SELECT o.orderid, o.orderdate,  e.employeeid, e.firstname, e.lastname, c.customerid, c.companyname
FROM employees as e
JOIN orders as o ON e.employeeid = o.employeeid
JOIN customers as c ON o.customerid = c.customerid
WHERE e.employeeid = 1;

SELECT employeeid, firstname, lastname, birthdate, hiredate, 
    EXTRACT(YEAR FROM hiredate) - EXTRACT(YEAR FROM birthdate) AS hiring_age
FROM employees;

SELECT city, COUNT(customerid) as num_customers
FROM customers
GROUP BY city;

SELECT c.customerid, c.companyname, COUNT(o.orderid) as num_orders
FROM customers as c
JOIN orders as o ON c.customerid = o.customerid
GROUP BY c.customerid, c.companyname;

SELECT c.categoryname, AVG(p.unitprice) as avg_price
FROM products as p
JOIN categories as c ON p.categoryid = c.categoryid
GROUP BY c.categoryname;

SELECT e.employeeid, e.firstname, e.lastname, t.territoryid, t.territorydescription
FROM employees as e
JOIN employee_territories as et ON e.employeeid = et.employeeid
JOIN territories as t ON et.territoryid = t.territoryid;

SELECT o.orderid, o.orderdate, c.companyname, p.productname
FROM orders as o
JOIN customers as c ON o.customerid = c.customerid
JOIN order_details as od ON o.orderid = od.orderid
JOIN products as p ON od.productid = p.productid
JOIN categories as cat ON p.categoryid = cat.categoryid
WHERE cat.categoryname = 'Beverages';

SELECT COUNT(orderid) as num_orders
FROM orders
WHERE EXTRACT(YEAR FROM orderdate) = 1997; 

SELECT p.productname, SUM(od.quantity) as total_quantity_ordered
FROM products as p
JOIN order_details as od ON p.productid = od.productid
GROUP BY p.productname
ORDER BY total_quantity_ordered DESC
LIMIT 5;

SELECT c.customerid, c.companyname, COUNT(DISTINCT p.categoryid) as num_categories_ordered
FROM customers as c
JOIN orders as o ON c.customerid = o.customerid
JOIN order_details as od ON o.orderid = od.orderid
JOIN products as p ON od.productid = p.productid
GROUP BY c.customerid, c.companyname
HAVING COUNT(DISTINCT p.categoryid) > 1;

SELECT c.categoryname, 
    SUM(od.quantity) as total_quantity_sold,
    SUM(od.unitprice * od.quantity) as total_sales,
    COUNT(DISTINCT o.orderid) as num_orders
FROM products as p
JOIN order_details as od ON p.productid = od.productid
JOIN categories as c ON p.categoryid = c.categoryid
JOIN orders as o ON od.orderid = o.orderid
GROUP BY c.categoryname;

SELECT e.employeeid, e.firstname, e.lastname, 
    SUM(od.unitprice * od.quantity) as total_sales,
    RANK() OVER (ORDER BY SUM(od.unitprice * od.quantity) DESC) as sales_rank
FROM employees as e
JOIN orders as o ON e.employeeid = o.employeeid
JOIN order_details as od ON o.orderid = od.orderid
GROUP BY e.employeeid, e.firstname, e.lastname;

SELECT o.orderid, o.orderdate, 
       SUM(od.quantity * p.unitprice) AS order_sales,
       SUM(SUM(od.quantity * p.unitprice)) OVER (ORDER BY o.orderdate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total_sales
FROM orders as o
JOIN order_details as od ON o.orderid = od.orderid
JOIN products as p ON od.productid = p.productid
GROUP BY o.orderid, o.orderdate
ORDER BY o.orderdate;

SELECT o.orderid, o.orderdate, 
       SUM(od.quantity * p.unitprice) AS order_sales,
       LAG(SUM(od.quantity * p.unitprice)) OVER (ORDER BY orderdate) AS previous_order_sales,
       SUM(od.quantity * p.unitprice) - LAG(SUM(od.quantity * p.unitprice)) OVER (ORDER BY orderdate) AS sales_diff
FROM orders as o
JOIN order_details as od ON o.orderid = od.orderid
JOIN products as p ON od.productid = p.productid
GROUP BY o.orderid, o.orderdate
ORDER BY o.orderdate;

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
