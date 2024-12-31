/*
	DATABASE SETUP
*/

DROP DATABASE IF EXISTS Bakery_db;
CREATE DATABASE Bakery_db;

USE Bakery_db;

SELECT * FROM Bakery_Sales;

/*
	DATA CLEANING
*/

-- Removing Unnecessary Columns
SELECT column1
FROM Bakery_Sales;

ALTER TABLE Bakery_Sales
DROP COLUMN column1;

-- Renaming Column
EXEC sp_rename 'dbo.Bakery_Sales.Quantity', 'quantity', 'COLUMN';

EXEC sp_rename 'dbo.Bakery_Sales.item_name', 'product_name', 'COLUMN';

-- Removing Null values
SELECT 
	date,
	time,
	ticket_number,
	product_name,
	quantity,
	unit_price
FROM Bakery_Sales
WHERE date IS NULL 
	OR time IS NULL
	OR ticket_number IS NULL
	OR product_name IS NULL
	OR quantity IS NULL
	OR unit_price IS NULL;

-- Removing Duplicate Records
WITH dup AS(
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY date, time, ticket_number, item_name, quantity, unit_price ORDER BY (SELECT NULL)) AS rank
FROM Bakery_Sales
)
SELECT *
FROM dup
WHERE rank > 1;

WITH dup AS(
SELECT
	*,
	ROW_NUMBER() OVER(PARTITION BY date, time, ticket_number, item_name, quantity, unit_price ORDER BY (SELECT NULL)) AS rank
FROM Bakery_Sales
)
DELETE FROM dup WHERE rank > 1;

-- Removing records unrelated to a bakery's typical offerings.
SELECT product_name, COUNT(*)
FROM Bakery_Sales
WHERE product_name LIKE '%PLAT%'	
	OR product_name LIKE '%ARTICLE 295%'
	OR product_name LIKE '%.%'
GROUP BY product_name;

DELETE 
FROM Bakery_Sales
WHERE product_name LIKE '%PLAT%'	
	OR product_name LIKE '%ARTICLE 295%'
	OR product_name LIKE '%.%';

-- Removing records with negative values.
SELECT quantity 
FROM Bakery_Sales
WHERE quantity < 0;

DELETE
FROM Bakery_Sales
WHERE quantity < 0;

-- Removing the unnecessary characters
SELECT
	DISTINCT unit_price,  
	REPLACE(unit_price, '€', '') as price,
	LEN(unit_price) AS length
from Bakery_Sales;

UPDATE Bakery_Sales
SET unit_price = REPLACE(unit_price, '€', '')

SELECT DISTINCT unit_price
FROM Bakery_Sales
WHERE unit_price LIKE '%,%'

UPDATE Bakery_Sales
SET unit_price = REPLACE(unit_price,',','.')

-- Handling Text Cases
SELECT LOWER(product_name)
FROM Bakery_Sales

UPDATE Bakery_Sales
SET product_name = LOWER(product_name)

-- Changing columns's Datatype
SELECT
	COLUMN_NAME,
	DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Bakery_Sales';

-- Date
SELECT 
	date, 
	CAST(date AS DATE) AS date2
FROM Bakery_Sales;

ALTER TABLE Bakery_Sales
ALTER COLUMN date DATE;

-- time
SELECT 
	time,
	FORMAT(time, 'HH:mm') As time2
FROM Bakery_Sales;

ALTER TABLE Bakery_Sales
ALTER COLUMN time TIME(0); -- The TIME data type stores time, and (0) indicates zero fractional seconds, effectively removing the milliseconds part of the time.

-- unit price
ALTER TABLE Bakery_Sales
ALTER COLUMN unit_price DECIMAL(10,2); 
 
-- Creating Revenue Column
ALTER TABLE Bakery_Sales
ADD revenue DECIMAL(10,2);

SELECT 
	(unit_price * quantity) AS revenue
FROM Bakery_Sales;

-- Inserting records 
UPDATE Bakery_Sales
SET revenue = unit_price * quantity;

SELECT *
FROM Bakery_Sales

--Creating Day of Week Column
ALTER TABLE Bakery_Sales
ADD day_of_week VARCHAR(10);

SELECT date, FORMAT(date,'dddd') AS day_of_week
FROM Bakery_Sales;

UPDATE Bakery_Sales
SET day_of_week = FORMAT(date,'dddd'); 

--Creating Time of Day Column
ALTER TABLE Bakery_Sales
ADD time_of_day VARCHAR(10);

SELECT time,
	CASE 
		WHEN DATEPART(HOUR, time) BETWEEN 0 AND 5 THEN 'Night'
        WHEN DATEPART(HOUR, time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, time) BETWEEN 18 AND 23 THEN 'Evening'
	END AS time_of_day
FROM Bakery_Sales

UPDATE Bakery_Sales
SET time_of_day = CASE 
		WHEN DATEPART(HOUR, time) BETWEEN 0 AND 5 THEN 'Night'
        WHEN DATEPART(HOUR, time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, time) BETWEEN 18 AND 23 THEN 'Evening'
	END;

-- Creating new column named product_category
ALTER TABLE Bakery_Sales
ADD product_category VARCHAR(10);

-- Insert Value 
SELECT 
product_name,
    CASE 
        WHEN product_name IN ('boule 200g', 'ficelle', 'special bread', 'pain suisse pepito', 'pain s/sel', 'pain de mie', 'campagne', 'pain choco amandes', 'pain banette', 'traditional baguette', 'seigle', 'pain', 'armoricain', 'special bread kg', 'pain noir', 'pain graines', 'pain aux raisins', 'pain graines', 'demi pain', 'boule 400g', 'demi baguette', 'quim bread', 'vik bread', 'baguette graine', 'baguette', 'nantais', 'baguette apero', 'moisson', 'complet') THEN 'Bread'
        WHEN product_name IN ('gd kouign amann', 'flan abricot', 'royal', 'st honore', 'religieuse', 'pt nantais', 'nid de poule', 'palet breton', 'milles feuilles', 'tarte fruits 4p', 'reduction sucrees 24', 'tarte fraise 4per', 'eclair fraise pistache', 'gal pomme 6p', 'buche 6pers', 'entremets', 'chou chantilly', 'macaron', 'gal poire choco 6p', 'galette 8 pers', 'framboisier', 'gal frangipane 6p', 'tarte fine', 'fraisier', 'gal frangipane 4p', 'gd far breton', 'crumblecaramel ou pistache', 'gal pomme 4p', 'royal 4p', 'caramel noix', 'tropezienne framboise', 'financier x5', 'savarin', 'tropezienne', 'grand far breton' ,'buche 4pers','gd nantais','financier','reduction sucrees 12','tarte fraise 6p','crumblecaramel ou pistae','plaque tarte 25p','coupe','eclair') THEN 'Dessert'
        WHEN product_name IN ('boisson 33cl', 'the', 'cafe ou eau', 'divers boissons') THEN 'Beverages'
        WHEN product_name IN ('pain au chocolat', 'sand jb emmental', 'formula pate', 'sand jb', 'galette 8 pers', 'meringue', 'bottereau', 'sucette', 'flan', 'delicetropical', 'tartelette fraise', 'noix japonaise', '12 macaron', 'briochette', 'croissant amandes', 'sable f p', 'grande sucette', 'tartelette cocktail', 'triangles', 'gache', 'fondant chocolat', 'tartelette choc', 'brioche', 'boule polka', 'banette', 'sachet de viennoiserie', 'paille', 'paris brest', 'tarte fruits 6p', 'douceur d hiver', 'cereal baguette', 'tartelette', 'baguet apéro', 'sachet de crouton', 'tulipe', 'banettine', 'gal pomme 6p', 'royal 6p', 'cake', 'chocolat', 'kouign amann', 'trois chocolat', 'chausson aux pommes', 'brioche de noel', 'sachet viennoiserie', 'brownies', 'buche 8pers', 'grand far breton' ,'formule pate', 'sandwich complet','cookie','divers viennoiserie','divers boulangerie','pates','guerandais','divers sandwichs','sable f  p','gal poire choco 4p','palmier','croissant','traiteur','crumble','formule sandwich','viennoise','divers confiserie','divers patisserie') THEN 'Pastry'
        ELSE 'Unknown'
    END AS category
FROM bakery_sales

UPDATE Bakery_Sales
SET product_category = 
	CASE 
        WHEN product_name IN ('boule 200g', 'ficelle', 'special bread', 'pain suisse pepito', 'pain s/sel', 'pain de mie', 'campagne', 'pain choco amandes', 'pain banette', 'traditional baguette', 'seigle', 'pain', 'armoricain', 'special bread kg', 'pain noir', 'pain graines', 'pain aux raisins', 'pain graines', 'demi pain', 'boule 400g', 'demi baguette', 'quim bread', 'vik bread', 'baguette graine', 'baguette', 'nantais', 'baguette apero', 'moisson', 'complet') THEN 'Bread'
        WHEN product_name IN ('gd kouign amann', 'flan abricot', 'royal', 'st honore', 'religieuse', 'pt nantais', 'nid de poule', 'palet breton', 'milles feuilles', 'tarte fruits 4p', 'reduction sucrees 24', 'tarte fraise 4per', 'eclair fraise pistache', 'gal pomme 6p', 'buche 6pers', 'entremets', 'chou chantilly', 'macaron', 'gal poire choco 6p', 'galette 8 pers', 'framboisier', 'gal frangipane 6p', 'tarte fine', 'fraisier', 'gal frangipane 4p', 'gd far breton', 'crumblecaramel ou pistache', 'gal pomme 4p', 'royal 4p', 'caramel noix', 'tropezienne framboise', 'financier x5', 'savarin', 'tropezienne', 'grand far breton' ,'buche 4pers','gd nantais','financier','reduction sucrees 12','tarte fraise 6p','crumblecaramel ou pistae','plaque tarte 25p','coupe','eclair') THEN 'Dessert'
        WHEN product_name IN ('boisson 33cl', 'the', 'cafe ou eau', 'divers boissons') THEN 'Beverages'
        WHEN product_name IN ('pain au chocolat', 'sand jb emmental', 'formula pate', 'sand jb', 'galette 8 pers', 'meringue', 'bottereau', 'sucette', 'flan', 'delicetropical', 'tartelette fraise', 'noix japonaise', '12 macaron', 'briochette', 'croissant amandes', 'sable f p', 'grande sucette', 'tartelette cocktail', 'triangles', 'gache', 'fondant chocolat', 'tartelette choc', 'brioche', 'boule polka', 'banette', 'sachet de viennoiserie', 'paille', 'paris brest', 'tarte fruits 6p', 'douceur d hiver', 'cereal baguette', 'tartelette', 'baguet apéro', 'sachet de crouton', 'tulipe', 'banettine', 'gal pomme 6p', 'royal 6p', 'cake', 'chocolat', 'kouign amann', 'trois chocolat', 'chausson aux pommes', 'brioche de noel', 'sachet viennoiserie', 'brownies', 'buche 8pers', 'grand far breton' ,'formule pate', 'sandwich complet','cookie','divers viennoiserie','divers boulangerie','pates','guerandais','divers sandwichs','sable f  p','gal poire choco 4p','palmier','croissant','traiteur','crumble','formule sandwich','viennoise','divers confiserie','divers patisserie') THEN 'Pastries'
        ELSE 'Unknown'
    END;

SELECT * FROM Bakery_Sales

/*
	EXPLORATORY DATA ANALYSIS
*/
-- A. Sales Performance

-- 1.Top 10 Performing Products Based on Revenue
WITH top_ten_product_revenue AS(
	SELECT 
		product_name,
		SUM(revenue) AS total_revenue,
		DENSE_RANK() OVER(ORDER BY SUM(revenue) DESC) AS rank
	FROM Bakery_Sales
	GROUP BY product_name
)
SELECT 
	product_name,
	total_revenue
FROM top_ten_product_revenue
WHERE rank <= 10;

-- 2.Top 10 Performing Products Based on Quantity
WITH top_ten_product_quantity AS(
	SELECT 
		product_name,
		SUM(quantity) AS total_quantity,
		DENSE_RANK() OVER(ORDER BY SUM(quantity) DESC) AS rank
	FROM Bakery_Sales
	GROUP BY product_name
)
SELECT 
	product_name,
	total_quantity
FROM top_ten_product_quantity
WHERE rank <= 10;

-- 3.Top 10 Least Sold Products Based on Revenue
WITH top_ten_product_revenue AS(
	SELECT 
		product_name,
		SUM(revenue) AS total_revenue,
		DENSE_RANK() OVER(ORDER BY SUM(revenue)) AS rank
	FROM Bakery_Sales
	GROUP BY product_name
)
SELECT 
	product_name,
	total_revenue
FROM top_ten_product_revenue
WHERE rank <= 10;

-- 4.Sales Per Category
SELECT
	product_category,
	SUM(revenue) AS total_revenue
FROM Bakery_Sales
GROUP BY product_category
ORDER BY total_revenue DESC;

-- 5.Sales Per Year
SELECT
	YEAR(date) AS year,
	SUM(revenue) AS total_revenue
FROM Bakery_Sales
GROUP BY YEAR(date)
ORDER BY total_revenue DESC;

SELECT -- Data is available from January to December of the year 2021.
	YEAR(date) AS year,
	MONTH(date) AS month
FROM Bakery_Sales
WHERE YEAR(date) = 2021 
GROUP BY YEAR(date), MONTH(date)
ORDER BY month 

SELECT -- Data is available from January to September of the year 2022.
	YEAR(date) AS year,
	MONTH(date) AS month
FROM Bakery_Sales
WHERE YEAR(date) = 2022 
GROUP BY YEAR(date), MONTH(date)
ORDER BY month 

-- Compute the total revenue from January to September of the year 2021.
SELECT
	YEAR(date) AS year,
	SUM(revenue) AS total_revenue
FROM Bakery_Sales
WHERE YEAR(date) = 2021 AND MONTH(date) <= 9
GROUP BY YEAR(date)
ORDER BY total_revenue DESC;

-- Compute the total revenue from January to September of the year 2022.
SELECT
	YEAR(date) AS year,
	SUM(revenue) AS total_revenue
FROM Bakery_Sales
WHERE YEAR(date) = 2022 
GROUP BY YEAR(date)
ORDER BY total_revenue DESC;


-- 6.Peak Category Performance by Time of Day
WITH category_peak AS(
	SELECT
		product_category,
		time_of_day,
		SUM(quantity) AS total_quantity,
		SUM(revenue) AS total_revenue,
		ROW_NUMBER() OVER(PARTITION BY time_of_day ORDER BY SUM(revenue)DESC) as rank
	FROM Bakery_Sales
	GROUP BY time_of_day, product_category
)
SELECT
	product_category,
	time_of_day,
	total_quantity,
	total_revenue
FROM category_peak 
ORDER BY time_of_day, rank ;

-- 7.Seasonal Performance
WITH SeasonalSales as(
SELECT
	product_category,
	CASE 
		WHEN MONTH(date) IN (12, 1, 2) THEN 'Winter'
		WHEN MONTH(date) IN (3, 4, 5) THEN 'Spring'
		WHEN MONTH(date) IN (6, 7, 8) THEN 'Summer'
		WHEN MONTH(date) IN (9, 10, 11) THEN 'Autumn'
	END AS seasons,
	SUM(quantity) AS total_quantity,
	SUM(revenue) AS total_revenue
FROM Bakery_Sales
GROUP BY
	product_category,
	CASE 
		WHEN MONTH(date) IN (12, 1, 2) THEN 'Winter'
		WHEN MONTH(date) IN (3, 4, 5) THEN 'Spring'
		WHEN MONTH(date) IN (6, 7, 8) THEN 'Summer'
		WHEN MONTH(date) IN (9, 10, 11) THEN 'Autumn'
	END
),
RankSales AS(
SELECT 
	product_category,
	seasons,
	total_quantity,
	total_revenue,
	ROW_NUMBER() OVER(PARTITION BY seasons ORDER BY total_revenue DESC) AS rank
FROM SeasonalSales
)

SELECT
	product_category,
	seasons,
	total_quantity,
	total_revenue
FROM RankSales
ORDER BY seasons,rank

-- B. Time-Based Trends

-- 1.Customer Traffic Trends by Day of the Week
SELECT
	COUNT(ticket_number) AS count_no_customer,
	day_of_week
FROM Bakery_Sales
GROUP BY day_of_week
ORDER BY count_no_customer DESC;

-- 2.Sale trends by time of the day:
SELECT 
	COUNT(ticket_number) AS count_no_customer,
	time_of_day
FROM Bakery_Sales
GROUP BY time_of_day
ORDER BY count_no_customer DESC;

-- 3.Sales Trends by Time (Peak Hours):
SELECT 
	COUNT(ticket_number) AS count_no_customer,
	DATEPART(HOUR, time) AS peak_hours,
	time_of_day
FROM Bakery_Sales
GROUP BY DATEPART(HOUR, time), time_of_day
ORDER BY count_no_customer DESC;

-- C. Cross-Selling Opportunities
SELECT 
	b1.product_name,
	b2.product_name,
	COUNT(*)  AS CoOccurrenceCount -- para bilangin ang bilang kung ilan beses magkasamang nabili yung b1 and b2
FROM Bakery_Sales AS b1
JOIN Bakery_Sales AS b2 -- ginamit natin ito para seperate table para i-pair yung product_name 
	ON b1.ticket_number = b2.ticket_number -- ginamit ito para mapair pareho ang ticket_number
		AND b1.product_name < b2.product_name -- ito naman ay para maiwasan ang duplicate pairs
GROUP BY b1.product_name, b2.product_name
ORDER BY CoOccurrenceCount DESC

-- D. Customer Behavior 
SELECT 
    AVG(quantity) AS AverageItemsPerOrder
FROM (
    SELECT  -- sum of the quantity purchased by each customer
        ticket_number, 
        SUM(quantity) AS quantity
    FROM Bakery_Sales
    GROUP BY ticket_number
) AS OrderSummary; 