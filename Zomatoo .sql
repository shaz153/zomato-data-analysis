Create database Bahubali;
use bahubali;
drop database bahubali;


-- Q1. Build a country Map Table

select C.RestaurantName, Z.Country -- count(*) as No_of_Restaurants
from CountryCode Z
Inner Join	Zomato C 
on C. CountryCode = Z.CountryCode;
-- group by C.RestaurantName, Z.Country;
 
 show tables;


-- Q2. Build a Calendar Table using the Column Datekey

SELECT
    Datekey_opening,

    YEAR(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) AS year,
    MONTH(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) AS monthno,
    MONTHNAME(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) AS monthfullname,
    QUARTER(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) AS quarter,
    
 DATE_FORMAT(
        STR_TO_DATE(Datekey_opening, '%d-%m-%Y'),
        '%Y-%m') AS yearmonth,

    WEEKDAY(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) AS weekdayno,
    DAYNAME(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) AS weekdayname,

    /* 🔹 Financial Month (India) */
    CASE
        WHEN MONTH(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) >= 4
            THEN MONTH(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) - 3
        ELSE MONTH(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) + 9
    END AS financialmonth,

    /* 🔹 Financial Quarter (India) */
    CASE
        WHEN MONTH(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(STR_TO_DATE(Datekey_opening, '%d-%m-%Y')) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS financialquarter
    
FROM zomato
WHERE Datekey_opening IS NOT NULL;


 -- Q3.Find the Numbers of Resturants based on City and Country.

SELECT 
    z.city,
    c.country,
    COUNT(*) AS total_restaurants
FROM zomato z
INNER JOIN countrycode c
    ON z.countrycode = c.countrycode
GROUP BY z.city, c.country;


-- Q4.Numbers of Resturants opening based on Year , Quarter , Month
 
SELECT
    YEAR(STR_TO_DATE(Datekey_opening,'%Y-%m-%d')) AS year,
    QUARTER(STR_TO_DATE(Datekey_opening,'%Y-%m-%d')) AS quarter,
    MONTH(STR_TO_DATE(Datekey_opening,'%Y-%m-%d')) AS month,
    COUNT(*) AS total_restaurants
FROM zomato
WHERE Datekey_opening IS NOT NULL
GROUP BY year, quarter, month
ORDER BY year, quarter, month;


-- Q5. Count of Resturants based on Average Ratings

SELECT
    CASE
        WHEN rating < 2 THEN 'Okay 0 - 2'
        WHEN rating >= 2 AND rating < 3 THEN 'Good  2 - 2.9'
        WHEN rating >= 3 AND rating < 4 THEN 'Great  3 - 3.9'
        WHEN rating >= 4 THEN 'Excellent 4 - 5'
        ELSE 'No Rating'
    END AS rating_category,
    COUNT(*) AS total_restaurants
FROM zomato
GROUP BY rating
ORDER BY rating;


 -- Q6. Create buckets based on Average Price of reasonable size and find out how many resturants falls in each buckets

SELECT
    CASE
        WHEN Average_Cost_for_two < 500 THEN 'Below 500'
        WHEN Average_Cost_for_two BETWEEN 500 AND 999 THEN '500 - 999'
        WHEN Average_Cost_for_two BETWEEN 1000 AND 1999 THEN '1000 - 1999'
        WHEN Average_Cost_for_two BETWEEN 2000 AND 2999 THEN '2000 - 2999'
        WHEN Average_Cost_for_two >= 3000 THEN '3000 and above'
        ELSE 'Price Not Available'
    END AS price_bucket,
    COUNT(*) AS total_restaurants
FROM zomato
GROUP BY Average_Cost_for_two
ORDER BY total_restaurants DESC;


 -- Q7. Percentage of Resturants based on "Has_Table_booking"

SELECT 
    has_Table_booking,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato), 2) AS percentage
FROM zomato
GROUP BY has_Table_booking;


 -- Q8.Percentage of Resturants based on "Has_Online_delivery"

 SELECT 
    has_online_delivery,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato), 2) AS percentage
FROM zomato
GROUP BY has_online_delivery;


-- Q9. Develop Charts based on Cusines, City, Ratings

SELECT
    restaurantname,
    cuisines,
    city,
    rating
FROM zomato
ORDER BY
    cuisines,
    city,
    rating DESC;