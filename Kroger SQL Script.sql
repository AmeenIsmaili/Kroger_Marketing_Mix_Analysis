# Product
# Problem Statement: 
# The company wants to understand customer preferences and behavior regarding the products they purchase to 
# optimize its product offerings and enhance customer satisfaction.

# 1. How many Products does Kroger offer?
SELECT count(distinct(product))
FROM KROGER; 

# 2. what are the products? 
SELECT distinct(product) 
FROM KROGER 
group by product;

# 3. what are the names of unique categories offered by Kroger?
SELECT distinct(category)
FROM kroger; 

# 4. what is the most selling product line? 
select category, count(category) AS product_count
from kroger
group by category
ORDER BY product_count desc 
LIMIT 1; 

# 5. what is the least selling product line? 
select category, count(category) AS product_count
from kroger
group by category
ORDER BY product_count ASC 
LIMIT 1; 

#6.	What are the top-selling items in each product category?
WITH top_rank as (
SELECT category, count(product) as product_count, product,
DENSE_RANK () OVER (PARTITION BY category ORDER BY count(product) desc) as rank_num
FROM kroger
GROUP BY category, product
) 
SELECT category, product, product_count, rank_num
FROM top_rank
WHERE rank_num = 1; 

# 7. Which product is the most popular among male? 
SELECT gender, product, count(product) AS product_count
from kroger
where gender = "Male"
group by gender, product
order by product_count desc
LIMIT 1; 

# 8. Which product is the most popular among Female? 
SELECT gender, product, count(product) AS product_count
from kroger
where gender = "Female"
group by gender, product
order by product_count desc
LIMIT 1; 


# 9.	How does the price distribution vary across different product categories?
SELECT category, var_pop(price) AS price_var
FROM kroger
GROUP BY category;

# 10. 	what is the review_rating of each product and how it correlate with the price? 
SELECT round(avg(review_rating), 2) AS Avg_Rating, sum(price) AS Total_Price
FROM kroger
group by review_rating
ORDER BY Avg_Rating DESC;

# 11.	Are there any seasonal trends in product purchases? show top 5 products by rank.
WITH season_rank AS (
SELECT season, product, sum(price),
dense_rank () OVER (PARTITION BY season ORDER BY sum(price) DESC) rank_num
from kroger
group by season, Product
)
SELECT *
FROM season_rank
WHERE rank_num IN (1, 2, 3, 4, 5);

# 12.	How do the sizes of purchased items vary by gender?
SELECT gender, size, count(product)
from kroger
group by gender, size; 

# 13.	Which colors are most popular among different age groups?
WITH age_g AS (
SELECT color,
case 
WHEN age >= 18 AND age <= 28 THEN "Young"
when age >= 29 AND age <= 39 THEN "Mature"
WHEN age >= 40 AND age <= 50 THEN "Middle_Age_Senior"
When age >= 51 AND age <= 70 THEN "Senior"
ELSE "Not Applicable"
END AS Age_Groups
FROM kroger
), 
age_ranking AS (
SELECT Age_Groups, color, count(color) AS color_count,
DENSE_RANK () OVER (PARTITION BY Age_Groups ORDER BY count(color) DESC) rank_num
from age_g
group by color, Age_Groups
)
select Age_Groups, color,color_count, rank_num
FROM age_ranking
WHERE rank_num = 1; 

# 14.	Is there a correlation between price range and payment method?
WITH price_range AS (
SELECT price, Payment_Method,
CASE
WHEN price >= 20 and price <= 39 THEN "Low_Price"
WHEN price >= 40 and price <= 59 Then "Medium Price"
WHEN price >= 60 and price <= 79 then "High price"
WHEN price >= 80 and price <= 100 then "Super High"

ELSE "Not Applicable"
END AS price_groups
FROM kroger
)
SELECT price_groups, payment_method, count(payment_method) AS transaction_count_by_payment_method
FROM price_range
group by price_groups, payment_method
ORDER BY transaction_count_by_payment_method DESC;

# 15.	What percentage of promo codes used on each product category?
SELECT 
Category, 
count(Promo_Code) AS Number_of_promos_issued, 
round((count(Promo_Code)/(select count(Promo_Code)from kroger)*100),2)AS percentage_of_issuance
FROM kroger
where Promo_Code = "Yes"
group by Category; 

# 16.	What percentage of promo codes not used on each product category?
SELECT 
Category, 
count(Promo_Code) AS Number_of_promos_issued, 
round((count(Promo_Code)/(select count(Promo_Code)from kroger)*100),2)AS percentage_of_issuance
FROM kroger
where Promo_Code = "No"
group by Category;


# Price: Problem Statement:
# The company aims to optimize pricing strategies to maximize revenue while remaining competitive in the market.

# 1. What is the proportion of spending by man and women? 
SELECT Gender, sum(price) AS Spendings_in_Dollars, (sum(price)/(select sum(price) from kroger)*100) AS "%"
FROM kroger
GROUP BY gender;  

# 2.	How do customer spendings vary across different shipping types and what trend each shipping type shows?
SELECT Shipping_Type, count(Shipping_Type) AS number_of_transactions, SUM(price) AS customer_spendings
FROM kroger
GROUP BY Shipping_Type; 

# 3.	Is there a correlation between price range and payment method?
WITH price_range AS (
SELECT price, Payment_Method,
CASE
WHEN price >= 20 and price <= 39 THEN "Low_Price"
WHEN price >= 40 and price <= 59 Then "Medium Price"
WHEN price >= 60 and price <= 79 then "High price"
WHEN price >= 80 and price <= 100 then "Super High"

ELSE "Not Applicable"
END AS price_groups
FROM kroger
)
SELECT price_groups, payment_method, count(payment_method) AS transaction_count_by_payment_method
FROM price_range
group by price_groups, payment_method
ORDER BY transaction_count_by_payment_method DESC;

# 4. What is the total proportion of spending by man and women? 
SELECT Gender, sum(price) AS Spendings_in_Dollars, (sum(price)/(select sum(price) from kroger)*100) AS percentage_spending
FROM kroger
GROUP BY gender; 

# 5. What is the proportion of spending on each product category by man and women? 
SELECT gender, category, sum(price) AS Total_Spendings, sum(price)/(select sum(price) from kroger)*100 AS proportion_of_spendings 
from kroger
group by gender, category; 

# 6. What are the top 10 cities with highest sale? 
SELECT location, sum(price) AS SALE
from kroger
group by location
Order by SALE DESC
LIMIT 10;  

# 7. which cities have perfomred lower then the average sale?
SELECT location, sum(price) AS SALE
from kroger
group by location
having SALE < (WITH avg_sale AS (
SELECT location, sum(price) AS total_sale
FROM kroger
group by location
)
SELECT avg(total_sale) 
FROM avg_sale); 

# 8. Which product is the most popular among male? 
SELECT gender, product, count(product) AS product_count
from kroger
where gender = "Male"
group by gender, product
order by product_count desc
LIMIT 1; 

# 9. Which product is the most popular among Fmale? 
SELECT gender, product, count(product) AS product_count
from kroger
where gender = "Female"
group by gender, product
order by product_count desc
LIMIT 1; 

# 10. what is the price distribution among each city?
SELECT location,  max(price)-min(price)
from kroger
group by location; 

# 11. which city has the highest revenue in winter season? 
SELECT location, season, sum(price) AS Sales
from kroger
where season = "winter"
group by location, season
order by Sales desc
Limit 1; 

# 12. which city has the highest revenue in Summer season? 
SELECT location, season, sum(price) AS Sales
from kroger
where season = "summer"
group by location, season
order by Sales desc
Limit 1;

# 13.  Which payment method is mostly used by male and female under 30 years of age? 
WITH pmt_method_ AS (
SELECT gender, payment_method, count(payment_method) as pmt_method_count,
DENSE_RANK () OVER (PARTITION BY gender ORDER BY count(payment_method) desc) as rank_num
from kroger
where age <= 30
group by gender, payment_method)
SELECT * 
FROM pmt_method_
WHERE  rank_num = 1;  

# 14.  Which payment method is mostly used by male and female over 30 years of age? 
WITH pmt_method_ AS (
SELECT gender, payment_method, count(payment_method) as pmt_method_count,
DENSE_RANK () OVER (PARTITION BY gender ORDER BY count(payment_method) desc) as rank_num
from kroger
where age > 30
group by gender, payment_method)
SELECT * 
FROM pmt_method_
WHERE  rank_num = 1;

# 15. what is the average sale price of each product category by city? 
select location, product,
round(avg(price), 2) AS avg_sale_price,
DENSE_RANK () OVER (PARTITION BY location ORDER BY round(avg(price), 2) desc) rank_location
from kroger
group by product, location;

# 16. what is the average sale price of each product category by season?
select season, product, 
round(avg(price), 2) AS avg_sale_price,
DENSE_RANK () OVER (PARTITION BY season ORDER BY round(avg(price), 2) desc) rank_season
from kroger
group by product, season;

# 17. Is their any correlation between sale price range and discounts? 
WITH price_range AS (
SELECT Discount_Applied, 
CASE
WHEN price >= 20 and price <= 39 THEN "Low_Price"
WHEN price >= 40 and price <= 59 Then "Medium Price"
WHEN price >= 60 and price <= 79 then "High price"
WHEN price >= 80 and price <= 100 then "Super High"

ELSE "Not Applicable"
END AS price_groups
FROM kroger
)
SELECT Discount_Applied, count(Discount_Applied), price_groups
FROM price_range
WHERE Discount_Applied IN ( "Yes", "No")
GROUP BY Discount_Applied, price_groups; 

# 18. To understand the price trend in comparison with average price, calculate average sale price of of each category 
# with the price in each city?
WITH avg_price_city AS (
SELECT location, round(avg(price), 2) AS Average_price , category
FROM kroger
GROUP BY location, category
),
sale_price AS (
SELECT price, location
FROM kroger
)
SELECT a.location, b.price AS Selling_Price, a.Average_price, a.category
FROM avg_price_city a
JOIN sale_price b ON a.location = b.location; 
 
# Place: Problem Statement:
# The company wants to understand the geographical distribution of its customer base and optimize its distribution channels accordingly.

# 1.	What are the top locations in terms of customer concentration?
SELECT location AS City, count(customer_id) AS transaction_count, 
round(count(customer_id)/(select count(customer_id) from kroger)*100, 2) AS transaction_count_percentage
from kroger
GROUP BY location
ORDER BY transaction_count DESC
LIMIT 10; 

# 2. What are the top locations in terms of sales?
SELECT location AS City, count(customer_id) AS transaction_count,
round(count(customer_id)/(select count(customer_id) from kroger)*100, 2) AS transaction_count_percentage, sum(price) AS Sales
from kroger
GROUP BY location
ORDER BY sum(price) desc
LIMIT 10; 

# 3.	How does the distribution of sale of each category vary across different locations?
WITH sale_by_category_location AS (
SELECT location, category, sum(price) AS sale_price,
DENSE_RANK() OVER(PARTITION BY location ORDER By sum(price) desc) AS rank_num
FROM kroger
GROUP BY location, category
)
SELECT location, category, sale_price, rank_num
from sale_by_category_location;

# 4. Show the top category with highest sale in different cities?
WITH sale_by_category_location AS (
SELECT location, category, sum(price) AS sale_price,
DENSE_RANK() OVER(PARTITION BY location ORDER By sum(price) desc) AS rank_num
FROM kroger
GROUP BY location, category
)
SELECT location, category, sale_price
from sale_by_category_location
where rank_num = 1;

# 5. According to the above insights, top category in terms of sale is "clothing". 
# Identify, which categories are top ranked other then clothing if any? 
WITH sale_by_category_location AS (
SELECT location, category, sum(price) AS sale_price,
DENSE_RANK() OVER(PARTITION BY location ORDER By sum(price) desc) AS rank_num
FROM kroger
GROUP BY location, category
)
SELECT location, category, sale_price
from sale_by_category_location
where rank_num = 1 AND category <> "Clothing"; 

# 6. What is the distribution of spendings by gender in different cities according to each category?
WITH sale_by_category_location AS (
SELECT location, category, sum(price) AS sale_price, gender,
DENSE_RANK() OVER(PARTITION BY gender ORDER By sum(price) desc) AS rank_num
FROM kroger
GROUP BY location, category, gender
)
SELECT gender, rank_num, location, category, sale_price
from sale_by_category_location
order by sale_price desc;

# 7.	How seasonal trends impact on sales in different cities?
WITH sale_by_category_location AS (
SELECT Season, Location, sum(price) AS sale_price,
DENSE_RANK() OVER(PARTITION BY Location ORDER By sum(price) desc) AS rank_num
FROM kroger
GROUP BY Season, Location
)
SELECT Season, rank_num, Location, sale_price
from sale_by_category_location;

# 8. Identify the cities that has the highest sales in each season, to analyze impact of the season on sales?
WITH sale_by_category_location AS (
SELECT Season, Location, sum(price) AS sale_price,
DENSE_RANK() OVER(PARTITION BY Location ORDER By sum(price) desc) AS rank_num
FROM kroger
GROUP BY Season, Location
)
SELECT Location, Season, sale_price, rank_num
from sale_by_category_location
where rank_num = 1
order by sale_price desc;

# 9. what is the correlation between location and shipping type?
SELECT location, Shipping_Type, count(Shipping_Type) AS ship_count
FROM kroger
GROUP BY location, Shipping_Type
ORDER BY ship_count DESC;

# 10. By location, Which shipping type is most popular among customers with different age brackets?
WITH age_g AS (
SELECT shipping_type, location,
case 
WHEN age >= 18 AND age <= 28 THEN "Young"
when age >= 29 AND age <= 39 THEN "Mature"
WHEN age >= 40 AND age <= 50 THEN "Middle_Age_Senior"
When age >= 51 AND age <= 70 THEN "Senior"
ELSE "Not Applicable"
END AS Age_Groups
FROM kroger
),
location_rank AS (
SELECT location, Shipping_Type, Age_Groups,
DENSE_RANK() OVER(PARTITION BY location order by count(Shipping_Type) desc) as shipping_rank
FROM age_g
GROUP BY Age_Groups, Shipping_Type, location
)
SELECT *
FROM location_rank
WHERE shipping_rank = 1;

# 11. which city has the highest revenue in winter season? 
SELECT location, season, sum(price) AS Sales
from kroger
where season = "winter"
group by location, season
order by Sales desc
Limit 1; 

# 12. which city has the highest revenue in summer season? 
SELECT location, season, sum(price) AS Sales
from kroger
where season = "Summer"
group by location, season
order by Sales desc
Limit 1; 

# Promotion: 
# Problem Statement:
# Kroger is using loyalty program as promotional strategy comprisis on discount offerings, promo codes and free 
# shippings services. The company wants to analyze the effectiveness of its promotional strategies and optimize 
# marketing efforts to increase customer acquisition and retention.

# 1. what is the impact of discount offerings on the frequency of purchases that lead to increase or decrease in sale? 
WITH discount_table AS (
SELECT Frequency_of_Purchases, Discount_Applied, sum(Price) AS sale
from kroger
group by Frequency_of_Purchases, Discount_Applied
having Discount_Applied = "yes"
Order by sale desc
),
non_disc_table AS (
SELECT Frequency_of_Purchases, Discount_Applied, sum(Price) AS sale_1
from kroger
group by Frequency_of_Purchases, Discount_Applied
having Discount_Applied = "No"
Order by sale_1 desc
)
SELECT a.Frequency_of_Purchases, a.Discount_Applied, a.sale, b.Discount_Applied, b.sale_1
FROM discount_table a
JOIN non_disc_table b ON a.Frequency_of_Purchases = b.Frequency_of_Purchases; 

# 2. What percentage of customers opt free shipping facility?
SELECT Shipping_Type, count(customer_id),
count(customer_id)/(select count(customer_id) from kroger)*100 AS "%" 
from kroger
WHERE Shipping_Type = "Free shipping"
group by Shipping_Type;

# 3. what is the proportion of sales by each category, if customers get promocode?
select category, Promo_Code, sum(price), sum(price)/(select sum(price) from kroger)*100
from kroger
group by category, Promo_Code
having Promo_Code = "yes";

# 4. What are the top 5 highest selling products in discounts?
select product, count(product) AS prodouct_count, Discount_Applied 
from kroger
where Discount_Applied = "yes"
group by Discount_Applied, product
ORDER BY prodouct_count desc
LIMIT 5;

# 5. Explore the demographics of top 5% of the customers? 
with sales AS (
select SUM(price) total_sale, customer_id, color, size, age, location, product, gender, Payment_Method
from kroger
group by price, customer_id, color, size, age, location, product, gender, Payment_Method
order by price desc
),
cumulative_sale AS (
SELECT *,
	ROUND(CUME_DIST() OVER (ORDER BY total_sale DESC)*100, 2) AS top_five_percent
	FROM sales
	)
	SELECT customer_id, total_sale AS top_5percnt_sales, color, size, Age, location, product, gender, Payment_Method
	FROM cumulative_sale
	WHERE top_five_percent <= 5.0;







