CREATE DATABASE walmartsales;

USE walmartsales;

SELECT * FROM walmartsales;

DESCRIBE walmartsales;

UPDATE walmartsales
SET Date = str_to_date(Date, '%Y-%m-%d');

ALTER TABLE walmartsales
MODIFY COLUMN Date DATE;

ALTER TABLE walmartsales
MODIFY COLUMN Time TIME;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------- Feature Engineering -----------------------------------------------------------------------------------------

--  --------------------------------------  Time of the Day  -------------------------------------------------------

SELECT 
	CASE 
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	END AS Time_of_day
FROM walmartsales;

ALTER TABLE walmartsales 
ADD COLUMN Time_of_day VARCHAR(25);

UPDATE walmartsales
SET Time_of_day = (
	CASE 
		WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN Time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	END
)
;

-- ----------------------------  Day_name  --------------------------------------------------

SELECT Date, dayname(Date) as Day_name
FROM walmartsales;

ALTER TABLE walmartsales
ADD COLUMN Day_name VARCHAR(25);

UPDATE walmartsales
SET Day_name = dayname(Date);

-- ----------------------------  Month_name  ---------------------------------------------------

SELECT Date, monthname(Date)
FROM walmartsales;

ALTER TABLE walmartsales
ADD COLUMN Month_name VARCHAR(25);

UPDATE walmartsales
SET Month_name = monthname(Date);

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------ Generic Questions ---------------------------------------------------------------------------------------

-- 1. How many unique cities does the data have?

SELECT COUNT(DISTINCT City) AS Unique_cities
FROM walmartsales;

-- 2. In which city is each branch?

SELECT DISTINCT city, branch
FROM walmartsales;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------- Product Related Questions -------------------------------------------------------------------------------------------

-- 1. How many unique product lines does the data have?

SELECT count(DISTINCT Product_line) AS Total_Product_lines
FROM walmartsales; 

-- 2. What is the most common payment method?

SELECT Payment_method, count(*) AS Cnt
FROM walmartsales
GROUP BY Payment_method;

-- 3. What is the most selling product line?

SELECT Product_line, count(*) AS Cnt
FROM walmartsales
GROUP BY Product_line
ORDER BY Cnt DESC;

-- 4. What is the total revenue by month?

SELECT Month_name, round(SUM(Total), 2) AS Total_revenue
FROM walmartsales
GROUP BY Month_name;

-- 5. What month had the largest COGS?

SELECT Month_name, round(SUM(cogs), 2) AS Maximum_cogs
FROM walmartsales
GROUP BY Month_name
ORDER BY Maximum_cogs DESC
LIMIT 1;

-- 6. What product line had the largest revenue?

SELECT Product_line, SUM(Total) AS Total_revenue
FROM walmartsales
GROUP BY Product_line
ORDER BY Total_revenue DESC;

-- 7. What is the city with the largest revenue?

SELECT City, SUM(Total) AS Total_revenue
FROM walmartsales
GROUP BY City
ORDER BY Total_revenue DESC;

-- 8. What product line had the largest VAT?

SELECT * FROM walmartsales;
SELECT Product_line, AVG(Vat) AS Avg_vat
FROM walmartsales
GROUP BY Product_line
ORDER BY Avg_vat DESC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT * FROM walmartsales;
WITH cte AS(
SELECT *, AVG(Total) AS Avg_Sales
FROM walmartsales
GROUP BY Product_line)
SELECT 
	CASE 
		WHEN Total > Avg_sales THEN 'Good'
        ELSE 'Bad'
        END
FROM cte;

-- 10. Which branch sold more products than average product sold?

SELECT Branch, SUM(Quantity) AS Qty
FROM walmartsales
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Quantity) FROM Walmartsales);

-- 11. What is the most common product line by gender?

SELECT Gender, Product_line, COUNT(Gender) AS Total_cnt
FROM walmartsales
GROUP BY Gender, Product_line
ORDER BY Total_cnt DESC;

-- 12. What is the average rating of each product line?

SELECT Product_line, ROUND(AVG(Rating), 2) AS Avg_rating
FROM walmartsales
GROUP BY Product_line
ORDER BY Avg_rating DESC;


-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- --------------------------------------------------------------  Sales  ------------------------------------------------------------------------------------------------------

-- 1. Number of sales made in each time of the day per weekday

SELECT Time_of_day, COUNT(*) AS Total_Qty
FROM walmartsales
WHERE Day_name = 'Monday'
GROUP BY Time_of_day
ORDER BY Total_Qty DESC;

-- 2. Which of the customer types brings the most revenue?

SELECT Customer_type, SUM(Total) AS Total_revenue
FROM walmartsales
GROUP BY Customer_type
ORDER BY Total_revenue DESC;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT * FROM walmartsales;
SELECT City, ROUND(AVG(Vat), 2) Vat
FROM walmartsales
GROUP BY City
ORDER BY Vat DESC;

-- 4. Which customer type pays the most in VAT?

SELECT Customer_type, ROUND(AVG(Vat), 2) AS Vat
FROM walmartsales
GROUP BY Customer_type
ORDER BY Vat DESC;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------  Custmoers  ---------------------------------------------------------------------------------------------

-- 1. How many unique customer types does the data have?

SELECT COUNT(DISTINCT Customer_type) AS Unique_customer_type
FROM walmartsales;

-- 2. How many unique payment methods does the data have?

SELECT COUNT(DISTINCT Payment_method) AS Unique_Payment_method
FROM walmartsales;

-- 3. What is the most common customer type?

SELECT Customer_type, round(COUNT(*), 2) AS cnt
FROM walmartsales
GROUP BY Customer_type
ORDER BY cnt DESC;

-- 4. Which customer type buys the most?

SELECT Customer_type, COUNT(*) AS cnt
FROM walmartsales
GROUP BY Customer_type
ORDER BY cnt DESC;

-- 5. What is the gender of most of the customers?

SELECT Gender, COUNT(*) AS cnt
FROM walmartsales
GROUP BY Gender
ORDER BY cnt DESC;

-- 6. What is the gender distribution per branch?

SELECT Branch, Gender, COUNT(*) AS cnt
FROM walmartsales
GROUP BY Gender, Branch
ORDER BY Branch;

-- 7. Which time of the day do customers give most ratings?

SELECT Time_of_day, AVG(Rating) AS AVG_Rating
FROM walmartsales
GROUP BY Time_of_day
ORDER BY AVG_Rating DESC;

-- 8. Which time of the day do customers give most ratings per branch?

SELECT Branch, Time_of_day, AVG(Rating) AS AVG_Rating
FROM walmartsales
GROUP BY Time_of_day, Branch
ORDER BY AVG_Rating DESC;

-- 9. Which day of the week has the best avg ratings?

SELECT Day_name, round(AVG(Rating), 2) AS AVG_Rating
FROM walmartsales
GROUP BY Day_name
ORDER BY AVG_Rating DESC;

-- 10. Which day of the week has the best average ratings per branch?

SELECT Branch, Day_name, round(AVG(Rating), 2) AS Rating
FROM walmartsales
GROUP BY Day_name, Branch
ORDER BY Rating DESC;
