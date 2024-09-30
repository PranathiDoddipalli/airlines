
# Airlines Database Queries

This repository contains SQL queries for interacting with an `airlines` database. The database includes basic information about airlines, such as name, IATA and ICAO codes, country, and their active/inactive status. Below are explanations and examples of various SQL queries used to retrieve and manipulate data.

## Table of Contents

1. [Database and Table Setup](#database-and-table-setup)
2. [Basic Queries](#basic-queries)
3. [Aggregations and Grouping](#aggregations-and-grouping)
4. [Advanced Queries](#advanced-queries)
5. [Window Functions](#window-functions)
6. [Join Queries](#join-queries)
7. [Regex Queries](#regex-queries)

---

## 1. Database and Table Setup

### Create Database and Table
```sql
CREATE DATABASE IF NOT EXISTS Airlines_db;

CREATE TABLE airlines (
    Airline_ID INT PRIMARY KEY,
    Name VARCHAR(1000),
    Alias VARCHAR(1000),
    IATA CHAR(3),
    ICAO CHAR(4),
    Callsign VARCHAR(1000),
    Country VARCHAR(1000),
    Active CHAR(1)
);
Explanation:
Airline_ID: Unique identifier for each airline (Primary Key).
Name: Airline name.
Alias: Any alternative names or abbreviations for the airline.
IATA: International Air Transport Association (IATA) code (3 characters).
ICAO: International Civil Aviation Organization (ICAO) code (4 characters).
Callsign: Radio callsign used by the airline.
Country: Country of origin.
Active: Indicates whether the airline is active ('Y') or inactive ('N').
2. Basic Queries
Retrieve all records from the table:

SELECT * FROM airlines;
Retrieve specific columns (name, IATA, country):

SELECT name, iata, country FROM airlines;
Get all airlines based in a specific country (e.g., 'United States'):

SELECT * FROM airlines WHERE country = 'United States';
Get all currently active airlines:

SELECT * FROM airlines WHERE active = 'Y';
Search for an airline by its IATA code:

SELECT * FROM airlines WHERE iata = '1T';
List all airlines in alphabetical order:

SELECT * FROM airlines ORDER BY name;
Count the total number of airlines:

SELECT COUNT(*) FROM airlines;
Count how many airlines are marked as active:

SELECT COUNT(*) FROM airlines WHERE active = 'Y';
3. Aggregations and Grouping
Get the number of airlines per country:

SELECT country, COUNT(*) AS num_airlines
FROM airlines
GROUP BY country;
Retrieve airlines without an IATA code:

SELECT * FROM airlines WHERE iata IS NULL;
Retrieve airlines missing a callsign or alias:

SELECT * FROM airlines WHERE callsign IS NULL OR alias IS NULL;
Find the number of active airlines per country (countries with more than 5 active airlines):

SELECT country, COUNT(*) AS active_airlines
FROM airlines
WHERE active = 'Y'
GROUP BY country
HAVING COUNT(*) > 5;
4. Advanced Queries
Find airlines with numeric characters in their name:

SELECT * 
FROM airlines
WHERE name REGEXP '[0-9]';
Find active airlines operating in multiple countries:

SELECT name, COUNT(DISTINCT country) AS country_count
FROM airlines
WHERE active = 'Y'
GROUP BY name
HAVING COUNT(DISTINCT country) > 1;
Rank countries by total and active airlines:

SELECT country,
       COUNT(*) AS total_airlines,
       SUM(CASE WHEN active = 'Y' THEN 1 ELSE 0 END) AS active_airlines,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS country_rank
FROM airlines
GROUP BY country;
List airlines with similar IATA and ICAO codes:

SELECT * 
FROM airlines
WHERE iata IS NOT NULL AND icao IS NOT NULL
  AND LEFT(iata, 2) = LEFT(icao, 2);
5. Window Functions
Rank airlines based on the length of their name (longest to shortest):

SELECT name, LENGTH(name) AS name_length,
RANK() OVER (ORDER BY LENGTH(name) DESC) AS name_rank
FROM airlines;
Show airline rankings based on alphabetic order within each country:

SELECT name, country,
       ROW_NUMBER() OVER (PARTITION BY country ORDER BY name) AS alphabetical_rank
FROM airlines;
6. Join Queries
Join airlines with flight activity (assuming another table flights):

SELECT a.name, f.flight_number, f.departure_time, f.destination
FROM airlines a
JOIN flights f ON a.iata = f.airline_iata
WHERE a.active = 'Y';
7. Regex Queries
List airlines with special characters in their callsign:

SELECT * FROM airlines
WHERE callsign REGEXP '[^a-zA-Z0-9]';
8. Other Useful Queries
Retrieve airlines that are inactive or missing country information:

SELECT * FROM airlines WHERE active = 'N' OR country IS NULL;
List top 5 countries with the most airlines:

SELECT country, COUNT(*) AS num_airlines
FROM airlines
GROUP BY country
ORDER BY num_airlines DESC
LIMIT 5;
Get airlines with IATA but missing ICAO codes:

SELECT * FROM airlines
WHERE iata IS NOT NULL AND icao IS NULL;

9. Conclusion
This document outlines a variety of SQL queries that you can run on the airlines table, from basic retrievals to more advanced queries involving grouping, ranking, and regular expressions. These queries provide valuable insights into the airlines dataset, allowing for detailed analysis and reporting.







