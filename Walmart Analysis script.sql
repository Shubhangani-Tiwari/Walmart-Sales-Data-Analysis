SELECT * FROM salesdatawalmart.walmart_sales_data;

-------------------------------------------------------------
/*------------------Feature Engineering----------------------
----time_of_day --------*/

Alter table walmart_sales_data add column time_of_day varchar(20);
Update walmart_sales_data 
Set time_of_day=(
CASE 
      WHEN "Time" BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
      WHEN "Time" BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
      ELSE 'Evening'
   END
);

/*---------Add_new_column: day_name---------*/ 

Alter table walmart_sales_data Add Column day_name varchar(10);
Update walmart_sales_data
Set day_name = DAYNAME(STR_TO_DATE(Date, '%d-%m-%Y'));

/*----Month_Name---*/

ALTER TABLE walmart_sales_data ADD COLUMN mnth_name varchar(30);
UPDATE walmart_sales_data
SET mnth_name = MONTHNAME(STR_TO_DATE(Date, '%d-%m-%Y'));

-----------------------------------------
-----------------------------------------
---------------Generic-------------------
---How Many unique cities does the data have?-----

Select Distinct(City) from walmart_sales_data;

---In which city is each branch?----

select distinct City, branch from walmart_sales_data;

--------------------------------------------------

select * from walmart_sales_data;

/*--------------------------------------------PRODUCT ANALYSIS----------------------------------------*/

/*----1.How many unique product lines does the data have?*/

Select Product line from  walmart_sales_data;

/*2. Most common payment method?*/

Select Payment, count(Payment) as cnt
from walmart_sales_data
group by Payment
order by cnt desc;

/* 3. What is the most selling product line? */

Select Product_line, count(Product_line) as cnt from walmart_sales_data
group by Product_line
order by cnt Desc;

/* 4. What is the total revenue by month?*/

select mnth_name as month, sum(total) as total_revenue
from walmart_sales_data
group by mnth_name
order by total_revenue desc;

/*5. What month had the largest COGS (Cost of goods sold)?*/

select mnth_name as month, round(sum(cogs),2) as cogs
from walmart_sales_data
group by mnth_name
order by cogs desc;

/*6. What Product line had the largest revenue?*/

select Product_line, round(sum(total),2) as total_revenue
from walmart_sales_data
group by Product_line
order by total_revenue;


/*7. What is the city with largest revenue?*/

select Branch, City, round(sum(total),2) as total_revenue
from walmart_sales_data
group by City, branch
order by total_revenue desc;

/* 8. What Product line had the lartests VAT?*/

Select Product_line, round(Avg(Tax_pct),2) as avg_tax
from walmart_sales_data
group by Product_line
order by avg_tax desc;


/* 9 Which Branch sold more products than average product sold?*/

select branch, sum(quantity) as qty
from walmart_sales_data
group by branch
having sum(quantity)> (select avg(quantity) from walmart_sales_data);

/* 10. Most common product line by gender?*/

select gender, product_line, count(gender) as total_cnt
from walmart_sales_data
group by gender, Product_line
order by total_cnt desc;

/* 11.  What is average rating for each product line?*/
select round(avg(rating),2) as avg_rating, Product_line
from walmart_sales_data
group by Product_line
order by avg_rating desc;

------------------------------------------------------------------------------
/*---------------------------SALES ANALYSIS---------------------------------*/

/* 1. Number of sales made in each time of the daya per weekday?*/

select  time_of_day, count(quantity) as total_sales
from walmart_sales_data
where day_name= 'Sunday'
group by  time_of_day
order by total_sales;


/*2 Which of the customer types brings the most revenue? */
select Customer_type, sum(total) as total_revenue
from walmart_sales_data 
group by Customer_type
order by total_revenue desc;

/*3. Which city has the largest tax percent/ VAT (Value Added Tax)? */

Select city, avg(Tax_pct) as VAt
from walmart_sales_data 
group by city
order by VAT desc;

/* 4. Which customer type pays the most in VAT?*/

Select Customer_type, avg(Tax_pct) as VAT
from walmart_sales_data 
group by Customer_type
order by VAT desc;

/*----------------------------------------------------------------
----------------------CUSTOMER ANALYSIS-------------------------*/

/* 1. How many unique customer types does the data have? */

select distinct(Customer_type) from walmart_sales_data;

/*2. How many unique payment methods does the data have?*/

select distinct(Payment) from walmart_sales_data;

/* 3. What is the most common customer type?*/

select customer_type, count(customer_count) as cnt
from walmart_sales_data
group by customer_type
order by cnt;

/* 4. Which customer type buys the most? */
select customer_type, count(*) as cstm_cnt
from  walmart_sales_data
group by customer_type
order by cstm_cnt;

/* 5. Most commont gender?*/

select gender, count(*) as gndr_cnt
from  walmart_sales_data
group by gender
order by gndr_cnt desc;


/* 6. What is the gender distribution per branch? */
select gender, count(*) as gender_count 
from  walmart_sales_data
where branch ='B'
group by gender
order by gender_count desc;

/*7. Which time of the day do customers give most ratings? */

select  time_of_day, avg(rating) as avg_rating
from walmart_sales_data 
group by time_of_day
order by avg_rating desc;

/* 8. Which time of the day do customers give most ratings per branch?*/
select  time_of_day, avg(rating) as avg_rating
from walmart_sales_data 
where branch ='B'
group by time_of_day
order by avg_rating desc;

/* 9. Which day of the week has the best avg ratings? */

Select day_name, avg(rating) as avg_rating
from walmart_sales_data  
group by day_name
order by avg_rating desc;

/* Which day of the week has the best average ratings per branch? */ 
Select day_name, avg(rating) as avg_rating
from walmart_sales_data  
where branch = 'C'
group by day_name
order by avg_rating desc;

