SELECT *
FROM wines
LIMIT 5;

/*markdown
We want to highlight 10 wines to increase our sales, which ones should we choose and why?
*/

CREATE VIEW wines_region AS 
SELECT * 
FROM wines
INNER JOIN regions
ON wines.region_id = regions.id;

SELECT *
FROM wines_region
LIMIT 3;

SELECT DISTINCT id, name, ratings_average, ratings_count
FROM wines
ORDER BY ratings_count DESC
LIMIT 10;

SELECT DISTINCT id, name, ratings_average, ratings_count, country_code
FROM wines_region
ORDER BY ratings_count DESC
LIMIT 10;

/*markdown
We have a marketing budget for this year, which country should we prioritise and why?
*/

ALTER TABLE countries
ADD COLUMN toplistsname TEXT;

UPDATE countries
SET toplistsname = (SELECT name FROM toplists WHERE toplists.country_code = countries.code);

SELECT *
FROM countries;

SELECT *
FROM countries
ORDER BY users_count DESC;

SELECT *
FROM wines_region
LIMIT 5;

CREATE VIEW countries_wines_region AS 
SELECT * 
FROM countries
INNER JOIN wines_region
ON countries.code = wines_region.country_code;

SELECT *
FROM countries_wines_region
LIMIT 5;

SELECT DISTINCT "name:1", code, ratings_average, ratings_count, users_count, toplistsname, wineries_count
FROM countries_wines_region
GROUP BY code
ORDER BY users_count DESC;

/*markdown
We would like to give a price to the best winery, which one should we choose and why?
*/

SELECT *
FROM wines
LIMIT 5;

SELECT *
FROM wineries
LIMIT 5;

UPDATE wines
SET winery_name = (SELECT name FROM wineries WHERE wineries.id = wines.winery_id)

SELECT winery_name, ROUND(AVG(ratings_average), 2), ROUND(SUM(ratings_count), 2)
FROM countries_wines_region

GROUP BY winery_name
ORDER BY ROUND(SUM(ratings_count), 2) DESC;

/*markdown
(ROUND(SUM(ratings_count))/(SUM(users_count)*100)) AS test
*/

SELECT winery_name, ROUND(AVG(ratings_average), 2), 
ROUND(SUM(ratings_count), 2), ROUND(SUM(users_count), 2), 
(ROUND(SUM(ratings_count))/(SUM(users_count)*100)) AS test
FROM countries_wines_region
GROUP BY winery_name
ORDER BY test;


SELECT winery_name, ROUND(AVG(ratings_average), 2), ROUND(SUM(ratings_count), 2)
FROM wines
GROUP BY winery_name

ORDER BY ROUND(AVG(ratings_average), 2) DESC;


/*markdown
We has detected that a big cluster of customers like a specific combination of tastes. We have identified few primary keywords that matches this and we would like you to find all the wines that have those keywords. To ensure accuracy of our selection, ensure that more than 10 users confirmed those keywords. Also, identify the flavor_groups related to those keywords.
Coffee
Toast
Green apple
cream
citrus
*/

/*markdown
We would like to do a selection of wines that are easy to find all over the world. Find the top 3 most common grape all over the world and for each grape, give us the the 5 best rated wines.
*/

/*markdown
We would to give create a country leaderboard, give us a visual that shows the average wine rating for each country. Do the same for the vintages.
*/

/*markdown
Give us any other useful insights you found in our data. Be creative!
*/