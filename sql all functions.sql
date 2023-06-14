/*   Section 11: Functions   
=======================================*/

/*******************************
1. Aggregate Functions
2. Comparison Functions
3. Date Functions
4. String Functions
5. Window Functions
6. Math Functions
*******************************/
use retail;

-- ============= 1. Aggregate Functions ================
-- AVG() - Return the average of non-NULL values.

SELECT * FROM products;
SELECT AVG(buyPrice) as average_buy_price
FROM products;

SELECT productLine, AVG(buyPrice) as average_buy_price
FROM products
GROUP BY productLine;

 -- COUNT()- returns the number of the value in a set.
SELECT COUNT(*) AS total
FROM products;

SELECT productLine,COUNT(*) AS total
FROM products
GROUP BY productLine;

-- SUM() - returns the sum of values in a set.
SELECT SUM(amount) as TotalPayment 
FROM payments;

SELECT YEAR(paymentDate) as PaymentYear, SUM(amount) as TotalPayment 
FROM payments
GROUP BY PaymentYear;

-- MAX() - returns the maximum value in a set.
SELECT  MAX(buyPrice) as highest_price
FROM  products;

SELECT productLine, MAX(buyPrice) as highest_price
FROM products
GROUP BY productLine
ORDER BY highest_price DESC;


-- MIN() - returns the minimum value in a set.
SELECT  MIN(buyPrice) as min_price
FROM  products;

SELECT productLine, MIN(buyPrice) as min_price
FROM products
GROUP BY productLine
ORDER BY min_price DESC;

use innomatics;
select course ,group_concat( name) 
from batch204
group by course;




-- GROUP_CONCAT() - concatenates a set of strings and returns the concatenated string.
SELECT * FROM customers;
SELECT country, GROUP_CONCAT(DISTINCT customername ORDER BY customerName) as customer_list
FROM customers
GROUP BY country;

-- ============= 2. Comparison Functions ================
-- COALESCE() - allows you to substitute NULL values.
SELECT * FROM customers;
SELECT   customerName, city, COALESCE(state, 'N/A') as State, country
FROM  customers;

-- GREATEST and LEAST - functions to find the greatest and smallest values of two or more columns respectively.

SELECT MAX(buyPrice), MIN(buyPrice) FROM products;

SELECT ProductName, buyPrice, MSRP FROM products;

SELECT productName,buyPrice, MSRP, GREATEST(buyPrice, MSRP), LEAST(buyPrice, MSRP) FROM products;

-- ISNULL() -- takes one argument and tests whether that argument is NULL or not. 
-- The ISNULL function returns 1 if the argument is NULL, otherwise, it returns 0.

SELECT   customerName, city, state,ISNULL(state) as `IsStateNULL`,  country
FROM  customers;

-- ============= 3. Date Functions ================
-- CURDATE() - returns the current date as a value in the 'YYYY-MM-DD' format 

SELECT CURDATE();
SELECT CURRENT_DATE(),CURRENT_DATE, CURDATE();

-- NOW() - returns the current date and time in the configured time zone as a string or a number 
		-- in the 'YYYY-MM-DD HH:MM:DD' format.
        
SELECT NOW();
-- To get in numeric form
SELECT NOW() + 0;

-- SYSDATE()
SELECT SYSDATE();

-- NOW() vs SYSDATE()
SELECT NOW(), SLEEP(5), NOW(); --  constant date and time at which the statement started executing
SELECT SYSDATE(), SLEEP(5), SYSDATE(); -- changes. exact time at which the statement executes

-- DAY() - to get the day of the month of a specified date.
-- MONTH() - returns an integer that represents the month of a specified date value.
-- YEAR() - to get the year out of a date value.

SELECT 
	*,
    CURRENT_DATE(), 	
    DAY(paymentDate),
    MONTH(paymentDate),
    YEAR(paymentDate) 
FROM payments;

-- DATEDIFF - calculates the number of days between two  DATE,  DATETIME, or  TIMESTAMP values.
SELECT * FROM payments;

SELECT 
	*,CURRENT_DATE(), 
	DATEDIFF(CURRENT_DATE,paymentDate) as Days,
    DATEDIFF(CURRENT_DATE,paymentDate)/365 as Years
FROM payments;

-- DATE_ADD - to add a time value to a DATE or DATETIME value.
-- DATE_ADD(start_date, INTERVAL expr unit);

SELECT 
	*,
    CURRENT_DATE(), 	
    DAY(paymentDate),
    MONTH(paymentDate),
    YEAR(paymentDate),
    DATEDIFF(CURRENT_DATE,paymentDate) as Days,
    DATEDIFF(CURRENT_DATE,paymentDate)/365 as Years,
    DATE_ADD(paymentdate, INTERVAL 1 DAY)
FROM payments;



SELECT *, DATE_ADD(paymentdate, INTERVAL 1 DAY) FROM payments;
SELECT *, DATE_ADD(paymentdate, INTERVAL 1 HOUR) FROM payments; -- 2004-10-19 00:00:00 --> 2004-10-19 01:00:00 
SELECT *, DATE_ADD(paymentdate, INTERVAL 1 MINUTE) FROM payments; -- 2004-10-19 00:00:00 --> 2004-10-19 00:01:00 
SELECT *, DATE_ADD(paymentdate, INTERVAL 1 SECOND) FROM payments; -- 2004-10-19 00:00:00 --> 2004-10-19 00:00:01

SELECT *, DATE_ADD(paymentdate, INTERVAL '-1 5' DAY_HOUR) FROM payments; -- 2004-10-19 --> 2004-10-18 --> 2004-10-17 19:00:00
SELECT *, DATE_ADD(paymentdate, INTERVAL '-1 5' HOUR_MINUTE) FROM payments;
SELECT *, DATE_ADD(paymentdate, INTERVAL '-1 5' SECOND_MICROSECOND) FROM payments;

SELECT *, DATE_ADD(paymentdate, INTERVAL 1 WEEK) FROM payments;
SELECT *, DATE_ADD(paymentdate, INTERVAL -1 MONTH) FROM payments;

-- DATE_SUB() - subtracts a time value (or an interval) from a DATE or DATETIME value.

SELECT *, DATE_SUB(paymentdate, INTERVAL 1 DAY) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL 1 HOUR) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL 1 MINUTE) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL 1 SECOND) FROM payments;

SELECT *, DATE_SUB(paymentdate, INTERVAL '-1 5' DAY_HOUR) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL '-1 5' HOUR_MINUTE) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL '-1 5' SECOND_MICROSECOND) FROM payments;

SELECT *, DATE_SUB(paymentdate, INTERVAL 1 WEEK) FROM payments;
SELECT *, DATE_SUB(paymentdate, INTERVAL -1 MONTH) FROM payments;


-- DATE_FORMAT - to format the date.
SELECT *, DATE_FORMAT(paymentdate, '%a') FROM payments;
SELECT *, DATE_FORMAT(paymentdate, '%e/%c/%Y') FROM payments;

-- DAYNAME - to get the name of a weekday for a given date.

SELECT *, DAYNAME(paymentdate) FROM payments;

SELECT 
    DAYNAME(orderdate) as weekday, 
    COUNT(*) as  total_orders
FROM  orders
WHERE YEAR(orderdate) = 2004
GROUP BY weekday
ORDER BY total_orders DESC;

-- DAYOFWEEK - returns the weekday index for a date i.e., 1 for Sunday, 2 for Monday, … 7 for Saturday.
SELECT *, 
		DAYNAME(paymentdate),
        DAYOFWEEK(paymentdate) 
FROM payments;

-- EXTRACT() - extracts part of a date.

SELECT *, EXTRACT(WEEK from paymentdate) FROM payments;
SELECT *, EXTRACT(MONTH from paymentdate) FROM payments;
SELECT *, EXTRACT(DAY from paymentdate) FROM payments;
SELECT *, EXTRACT(QUARTER from paymentdate) FROM payments;
SELECT *, EXTRACT(YEAR_MONTH from paymentdate) FROM payments;

SELECT EXTRACT(YEAR FROM CURDATE());

-- LAST_DAY() - takes a DATE or DATETIME value and returns the last day of the month for the input date.
SELECT *, LAST_DAY(paymentdate) FROM payments;

-- STR_TO_DATE() - converts the str string into a date value based on the fmt format string.

SELECT STR_TO_DATE('22,2,2022','%d,%m,%Y');

SELECT STR_TO_DATE('1,1,2022 is the New Year date','%d,%m,%Y');

SELECT STR_TO_DATE('20130101 1130','%Y%m%d %h%i') ; --  refer to DATE_FORMAT function for the list of format specifiers.

-- TIMEDIFF & TIMESTAMPDIFF - returns the difference between two TIME or DATETIME values. 

SELECT TIMEDIFF('12:00:00','10:00:00') as diff;
SELECT TIMEDIFF((NOW() - INTERVAL 1 HOUR), NOW());

SELECT TIMESTAMPDIFF(MONTH, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(WEEK, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(DAY, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(HOUR, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(MINUTE, '2012-03-01', NOW());
SELECT TIMESTAMPDIFF(SECOND, '2012-03-01', NOW());

-- WEEK - to get the week number for a date.
-- WEEKDAY -- 0 for Monday, 1 for Tuesday, … 6 for Sunday.
-- A year has 365 days for a normal year and 366 days for leap year. 
-- A year is then divided into weeks with each week has exact 7 days. 
-- So for a year we often has 365 / 7 = 52 weeks that range from 1 to 52.

SELECT *, WEEK(paymentdate), WEEKDAY(paymentdate) FROM payments;

-- ============= 4. String Functions ================

-- CONCAT & CONCAT_WS
SELECT CONCAT(contactFirstName,' ',contactLastName) Fullname
FROM customers;

SELECT CONCAT_WS('/',contactFirstName,contactLastName, City, Country) Fullname
FROM customers;

-- String Length
SELECT productName, LENGTH(productName) FROM products;

-- LEFT & RIGHT
SELECT productName, LEFT(productName, 4), RIGHT(productName, 4)  FROM products;

-- INSTR - to return the position of the first occurrence of a string.
SELECT productName, INSTR(productName,'son') FROM products;

-- LOWER & UPPER
SELECT productName, LOWER(productName), UPPER(productName)  FROM products;

-- LTRIM, RTRIM, TRIM
SELECT  
	contactFirstName,
    INSTR(contactFirstName,' '),
    LENGTH(contactFirstName),
    LENGTH(RTRIM(contactFirstName)), -- Trim RIGHT side spaces
    LENGTH(LTRIM(contactFirstName)), -- Trim LEFT side spaces
    LENGTH(TRIM(contactFirstName)) -- Trim spaces on BOTH sides
    FROM Customers WHERE contactFirstName IN ('Carine ','Mary ','Jean');

-- REPLACE
-- REPLACE(str,old_string,new_string);

SELECT productName, REPLACE(productName, 'son', ' S-O-N ') FROM products;

-- SUBSTRING 
SELECT productName, SUBSTRING(productName,5) FROM products;
SELECT productName, SUBSTRING(productName,10) FROM products;
SELECT productName, SUBSTRING(productName,10,15) FROM products;

SELECT productName, SUBSTRING(productName,-7) FROM products;

SELECT SUBSTRING('Harley Davidson', 5,9); -- starting from the 5th position fetch next 9 characters


-- ============= 5. Window Functions ================

DROP TABLE IF EXISTS sales;

CREATE TABLE sales(
    sales_employee VARCHAR(50) NOT NULL,
    fiscal_year INT NOT NULL,
    sale DECIMAL(14,2) NOT NULL,
    PRIMARY KEY(sales_employee,fiscal_year)
);

INSERT INTO sales(sales_employee,fiscal_year,sale)
VALUES('Bob',2016,100),
      ('Bob',2017,150),
      ('Bob',2018,200),
      ('Alice',2016,150),
      ('Alice',2017,100),
      ('Alice',2018,200),
       ('John',2016,200),
      ('John',2017,150),
      ('John',2018,250);

SELECT * FROM sales;

-- ROW_NUMBER
SELECT
    sales_employee,
    fiscal_year,
    sale,
    ROW_NUMBER() OVER() as sales_rowNum
FROM Sales;

SELECT
    sales_employee,
    fiscal_year,
    sale,
    ROW_NUMBER() OVER() as sales_rowNum,
    ROW_NUMBER() OVER(ORDER BY fiscal_year) as sales_rowNum_orderby,
    ROW_NUMBER() OVER(PARTITION BY fiscal_year ORDER BY sale DESC) as sales_rowNum_part_orderby
FROM Sales;


-- RANK & DENSE_RANK
SELECT
    sales_employee,
    fiscal_year,
    sale,
    ROW_NUMBER() OVER(PARTITION BY fiscal_year ORDER BY sale DESC) as sales_rowNum_part_orderby,
    RANK() OVER (PARTITION BY fiscal_year ORDER BY sale DESC) as sales_rank,
    DENSE_RANK() OVER (PARTITION BY fiscal_year ORDER BY sale DESC) as sales_dense_rank    
FROM  sales;

-- NTILE -  divides rows in a sorted partition into a specific number of groups.
SELECT
    sales_employee,
    fiscal_year,
    sale,
	NTILE(3) OVER (ORDER BY sale DESC) as sales_Ntile
FROM  sales;

-- LEAD & LAG
SELECT
    sales_employee,
    fiscal_year,
    sale,
    LEAD(sales_employee, 1) OVER (ORDER BY sale DESC) as lead_sales,
	LEAD(sales_employee, 2) OVER (ORDER BY sale DESC) as lead_sales
FROM  sales;

SELECT
    sales_employee,
    fiscal_year,
    sale,
    LAG(sales_employee, 1) OVER (ORDER BY sale DESC) as lead_sales,
	LAG(sales_employee, 2) OVER (ORDER BY sale DESC) as lead_sales
FROM  sales;

-- ============= 6. Math Functions ================

SELECT 
	*,
	amount*-1,
    ABS(amount*-1),
    CEIL(amount),
    FLOOR(amount),
    ROUND(amount,1),
    MOD(amount,3) -- Returns the remainder of a number divided by another
FROM payments;
