
--total sales

SELECT
	EXTRACT(year from order_date) AS year,
	EXTRACT(month from order_date) AS month,
	ROUND(SUM(sales), 2) AS total_sales
FROM
	superstore.orders
GROUP BY
	1,2
ORDER BY
	1,2;
	
--total profit
	
SELECT
	EXTRACT(year from order_date) AS year,
	EXTRACT(month from order_date) AS month,
	ROUND(SUM(profit), 2) AS total_profit
FROM
	superstore.orders
GROUP BY
	1,2
ORDER BY
	1,2;
	
--profit ratio

SELECT
	EXTRACT(year from order_date) AS year,
	EXTRACT(month from order_date) AS month,
	ROUND(SUM(profit) / SUM(sales), 2) AS profit_ratio
FROM
	superstore.orders
GROUP BY
	1,2
ORDER BY
	1,2;

--average discount

SELECT
	EXTRACT(year from order_date) AS year,
	EXTRACT(month from order_date) AS month,
	ROUND(AVG(discount), 2) AS average_discount
FROM
	superstore.orders
GROUP BY
	1,2
ORDER BY
	1,2;
	
--sum of sales per customer

SELECT
	customer_id,
	customer_name,
	ROUND(SUM(sales), 2) AS sum_of_sales
FROM
	superstore.orders
GROUP BY
	1,2
ORDER BY
	3 desc;
	
--profit per customer
	
SELECT
	customer_id,
	customer_name,
	ROUND(SUM(profit), 2) AS profit
FROM
	superstore.orders
GROUP BY
	1,2
ORDER BY
	3 desc;
	
--sales per customer
	
SELECT
	customer_id,
	customer_name,
	COUNT(sales) AS sales_count
FROM
	superstore.orders
GROUP BY
	1,2
ORDER BY
	3 desc;
	
--profit per order
	
SELECT
	order_id,
	ROUND(SUM(profit), 2) AS profit
FROM
	superstore.orders
GROUP BY
	1
ORDER BY
	2 desc

--Monthly Sales by Segment
	
SELECT
	EXTRACT(year from order_date) AS year,
	EXTRACT(month from order_date) AS month,
	segment,
	ROUND(SUM(sales), 2) AS sum_of_sales
FROM
	superstore.orders
GROUP BY
	1,2,3
ORDER BY
	1,2;

--Sales by Product Category over time 

SELECT
	EXTRACT(year from order_date) AS year,
	EXTRACT(month from order_date) AS month,
	category,
	ROUND(SUM(sales), 2) AS sum_of_sales
FROM
	superstore.orders
GROUP BY
	1,2,3
ORDER BY
	1,2;

--Monthly Sales per region

SELECT
	EXTRACT(year from order_date) AS year,
	EXTRACT(month from order_date) AS month,
	region,
	ROUND(SUM(sales), 2) AS sum_of_sales
FROM
	superstore.orders
GROUP BY
	1,2,3
ORDER BY
	1,2;

--Sales per region

SELECT
	region,
	ROUND(SUM(sales), 2) AS sum_of_sales
FROM
	superstore.orders
GROUP BY
	1
ORDER BY
	2 DESC;





--