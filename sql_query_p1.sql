-- SQL Retail sales analysis - P1
CREATE DATABASE sql_project_p2;
--Create table

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(transactions_id INT PRIMARY KEY,
							sale_date	DATE,
							sale_time TIME,
							customer_id	INT,
							gender	VARCHAR(15),
							age	INT,
							category VARCHAR(25),
							quantiy	float,
							price_per_unit float,
							cogs float,
							total_sale float
							);



-- to check correct data is imported or not from csv file.
select count(*) from retail_sales;
-- to understand the data more we have to do exploration.
select * from retail_sales;

-- DATA CLEANING 

-- TO find Null values
select * from retail_sales 
where transactions_id IS NULL;

select * from retail_sales 
where sale_date IS NULL;


select * from retail_sales 
where sale_time IS NULL;

-- As we can't check each col whether it is null or not there is simple method to check
select * from retail_sales 
where 
	 transactions_id IS NULL
	 or 
	 sale_date IS NULL
	 or 
	 sale_time IS NULL
	 or
	 customer_id IS NULL
	 or
	 gender IS NULL
	 or
	 age IS NULL
	 or
	 category IS NULL
	 or
	 quantiy IS NULL
	 or
	 price_per_unit IS NULL
	 or
	 cogs IS NULL
	 or
	 total_sale IS NULL;

-- so we got 13 rows as null values -- delete it
DELETE from retail_sales
where 
	 transactions_id IS NULL
	 or 
	 sale_date IS NULL
	 or 
	 sale_time IS NULL
	 or
	 customer_id IS NULL
	 or
	 gender IS NULL
	 or
	 age IS NULL
	 or
	 category IS NULL
	 or
	 quantiy IS NULL
	 or
	 price_per_unit IS NULL
	 or
	 cogs IS NULL
	 or
	 total_sale IS NULL;
	 
-- DATA Exploration 
-- HOW many sales we have?
select count(*) as total_sale from retail_sales
	 
-- how many unique customers we have?
select count(distinct customer_id) from retail_sales

-- unique category
select count(distinct category) from retail_sales

select distinct category from retail_sales


-- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS
-- My findings and analysis
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
-- the quantity sold is more than 4 in the month of Nov-2022

select *
from retail_sales
where category= 'Clothing' 
AND 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND 
quantiy >=4


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, 
SUM(total_sale) as net_sale,
count(*) as total_orders
from retail_sales
group by 1; -- or group by category (u can write it)

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select * from retail_sales;

select ROUND(AVG(age), 2) as avg_age
from retail_sales where category='Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, 
		gender, 
		count(*) as total_trans
from retail_sales
group by category, gender
order by category


-- Interview Question
-- if you dont want to show rank dont use *( all col )
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Select year, month, avg_sale
from 
(	
	select 
	extract( YEAR from sale_date) as year,
	extract( MONTH from sale_date) as month,
	AVG(total_sale)  as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT (YEAR from sale_date) ORDER BY AVG(total_sale) DESC) as rank
from retail_sales
group by 1,2
) as t1 
where rank = 1

-- order by 1, 3 DESC


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,
	sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 DESC
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category, 
count( distinct customer_id) as cnt_unique_cs
from retail_sales
group by 1


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- we'll use customer segmentation and learn how to use CASE

WITH hourly_sale
AS (
select *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'	
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
from retail_sales
)

select 
	shift,
count(*) as total_orders
from hourly_sale
group by shift

--select extract(hour from current_time)

--End of Project