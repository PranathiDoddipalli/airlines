
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

-- Retrieve all records from the airlines table. ------------

SELECT * FROM airlines;

-- Retrieve only the name, iata, and country columns. --------

SELECT name, iata, country FROM airlines;

-- Get all airlines based in the "United States". -----------

SELECT * FROM airlines WHERE country = 'United States';

-- Get all airlines that are currently active. --------------

SELECT * FROM airlines WHERE active = 'Y';

-- Search for an airline using its IATA code, e.g., '1T'.

SELECT * FROM airlines WHERE iata = '1T';

-- List all airlines in alphabetical order by their name.

SELECT * FROM airlines ORDER BY name;

-- Count the total number of airlines.

SELECT COUNT(*) FROM airlines;

-- Count how many airlines are marked as active.

SELECT COUNT(*) FROM airlines WHERE active = 'Y';

-- Get the number of airlines per country.

SELECT country, COUNT(*) AS num_airlines
FROM airlines
GROUP BY country;

-- Retrieve all airlines that do not have an IATA code assigned.

SELECT * FROM airlines WHERE iata IS NULL;

-- Retrieve all airlines that are missing either a callsign or an alias (both having NULL or '\N').

SELECT * FROM airlines 
WHERE callsign IS NULL OR alias IS NULL;

-- Find the number of active airlines per country and only return countries with more than 5 active airlines.

SELECT country, COUNT(*) AS active_airlines
FROM airlines
WHERE active = 'Y'
GROUP BY country
HAVING COUNT(*) > 5;

-- List the top 5 countries that have the most airlines (active or not).

SELECT country, COUNT(*) AS num_airlines
FROM airlines
GROUP BY country
ORDER BY num_airlines DESC
LIMIT 5;

-- Get all airlines that have an IATA code but are missing an ICAO code.

SELECT * FROM airlines
WHERE iata IS NOT NULL AND icao IS NULL;

-- Retrieve all airlines where the name is shorter than 10 characters.

SELECT * FROM airlines
WHERE LENGTH(name) < 10;

-- Search for airlines whose callsign contains the word "AIR".

SELECT * FROM airlines
WHERE callsign LIKE '%AIR%';

-- Retrieve airlines that are either inactive (active = 'N') or missing country information.

SELECT * FROM airlines
WHERE active = 'N' OR country IS NULL;

-- Find airlines where the alias and name are similar. This assumes a simple string comparison where both fields are not null.

SELECT * FROM airlines
WHERE alias IS NOT NULL AND name IS NOT NULL AND alias = name;

-- Suppose you have another table called flights that contains airline activity. You can join the airlines and flights tables to get airlines with flight activity.

SELECT a.name, f.flight_number, f.departure_time, f.destination
FROM airlines a
JOIN flights f ON a.iata = f.airline_iata
WHERE a.active = 'Y';

-- List airlines that have special characters (non-alphanumeric) in their callsign.

SELECT * FROM airlines
WHERE callsign REGEXP '[^a-zA-Z0-9]';

-- Rank airlines based on the length of their name, from longest to shortest.

SELECT name, LENGTH(name) AS name_length,
RANK() OVER (ORDER BY LENGTH(name) DESC) AS name_rank
FROM airlines;

-- Calculate the number of airlines in each country and show the rank of each airline within its country based on the alphabetic order of the airline names.

SELECT name, country,
       RANK() OVER (PARTITION BY country ORDER BY name) AS country_rank
FROM airlines;

-- Group airlines by IATA and count how many airlines share the same code (for possible duplicates or errors).

SELECT iata, COUNT(*) AS airline_count
FROM airlines
WHERE iata IS NOT NULL
GROUP BY iata
HAVING COUNT(*) > 1;

-- Find airlines that share the same callsign but are from different countries.

SELECT callsign, country, COUNT(*)
FROM airlines
WHERE callsign IS NOT NULL
GROUP BY callsign, country
HAVING COUNT(*) > 1;

-- Find airlines where the iata and icao codes share the same first character.

SELECT * FROM airlines
WHERE LEFT(iata, 1) = LEFT(icao, 1);

--  Find Airlines with Longest and Shortest Names

WITH name_lengths AS (
    SELECT name, LENGTH(name) AS name_length
    FROM airlines
)
SELECT name, name_length
FROM name_lengths
WHERE name_length = (SELECT MAX(name_length) FROM name_lengths)
   OR name_length = (SELECT MIN(name_length) FROM name_lengths);
   
   
-- List Airlines that Appear Only Once (Unique Airlines)

SELECT name, COUNT(*) AS occurrences
FROM airlines
GROUP BY name
HAVING COUNT(*) = 1;

-- Select Airlines with Numeric Characters in Their Name:

SELECT * 
FROM airlines
WHERE name REGEXP '[0-9]';

-- Find Active Airlines in Multiple Countries:

SELECT name, COUNT(DISTINCT country) AS country_count
FROM airlines
WHERE active = 'Y'
GROUP BY name
HAVING COUNT(DISTINCT country) > 1;

-- Rank Countries by Total and Active Airlines:

SELECT country,
       COUNT(*) AS total_airlines,
       SUM(CASE WHEN active = 'Y' THEN 1 ELSE 0 END) AS active_airlines,
       RANK() OVER (ORDER BY COUNT(*) DESC) AS country_rank
FROM airlines
GROUP BY country;

-- Find Airlines with Similar IATA and ICAO Codes:

SELECT * 
FROM airlines
WHERE iata IS NOT NULL AND icao IS NOT NULL
  AND LEFT(iata, 2) = LEFT(icao, 2);
  
-- Compare Active vs Inactive Airlines per Country:

SELECT country,
       SUM(CASE WHEN active = 'Y' THEN 1 ELSE 0 END) AS active_airlines,
       SUM(CASE WHEN active = 'N' THEN 1 ELSE 0 END) AS inactive_airlines
FROM airlines
GROUP BY country
ORDER BY active_airlines DESC;

-- Window Function to Show Airline Rankings Based on Alphabetical Order:

SELECT name, country,
       ROW_NUMBER() OVER (PARTITION BY country ORDER BY name) AS alphabetical_rank
FROM airlines;

-- Get Airlines That Have Similar Names but Different Countries:

SELECT name, country
FROM airlines
WHERE name IN (
    SELECT name
    FROM airlines
    GROUP BY name
    HAVING COUNT(DISTINCT country) > 1
)
ORDER BY name;

-- Generate a List of Airlines with Unique ICAO Codes:

SELECT icao, COUNT(*) AS airline_count
FROM airlines
GROUP BY icao
HAVING COUNT(*) = 1;