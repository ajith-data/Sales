-- create table
drop table if exists retail_sales;
create table retail_sales
	(
		transactions_id	INT,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(20),
		age	VARCHAR(10),
		category VARCHAR(20),
		quantiy	INT,
		price_per_unit FLOAT,	
		cogs FLOAT,
		total_sale FLOAT
	);
select * from retail_sales;

select * from retail_sales
where age is null;

update retail_sales
set age = (select min(Age) from retail_sales where age is not null)
where age is null;


select quantity,
	price_per_unit,
	cogs,
	total_sale
from retail_sales
where 
	quantity is null 
or 
	price_per_unit is null 
or 
	cogs is null 
or 
	total_sale is null ;

DELETE FROM retail_sales
where quantity is null or price_per_unit is null or cogs is null or total_sale is null;
select * from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales
where 
	category = 'Clothing' 
	AND 
	TO_CHAR (sale_date ,'yyyy-mm') ='2022-11'
	AND
	 quantiy >=4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category,sum(total_sale) as total_sales
from retail_sales
group by 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
alter table retail_sales 
alter column age type integer
USING age::INTEGER;

select round(avg(age),0) as average_age 
from retail_sales
where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale >1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select gender,sum(transactions_id) as total_transactions
from retail_sales
group by 1;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select year,month,avg_sales
from (
select extract (year from sale_date) as year,
	   extract (month from sale_date) as month,
	   avg(total_sale) as avg_sales
	   from retail_sales
group by 1,2	   
order by 3 desc ) as t1 
limit 5;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

select customer_id,sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category, count(distinct customer_id) as unique_customer
from retail_sales
group by 1;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT
    CASE
        WHEN sale_time <= '12:00:00' THEN 'Morning'
        WHEN sale_time > '12:00:00' AND sale_time <= '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY
    CASE
        WHEN sale_time <= '12:00:00' THEN 'Morning'
        WHEN sale_time > '12:00:00' AND sale_time <= '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
ORDER BY shift;
