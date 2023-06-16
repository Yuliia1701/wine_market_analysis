/*markdown
We want to highlight 10 wines to increase our sales, which ones should we choose and why?
*/

SELECT wines.name AS wine_name, regions.name AS region_name, regions.country_code, ratings_average, ratings_count
FROM regions
INNER JOIN wines
ON regions.id = wines.region_id
ORDER BY ratings_count DESC
LIMIT 10;


SELECT wines.name AS wine_name, regions.name AS region_name, regions.country_code, ratings_average, ratings_count, user_structure_count
FROM regions
INNER JOIN wines
ON regions.id = wines.region_id
ORDER BY ratings_average DESC
LIMIT 10;

SELECT *
FROM wines
LIMIT 3;

CREATE VIEW wines_region AS 
SELECT * 
FROM wines
INNER JOIN regions
ON wines.region_id = regions.id;

SELECT *
FROM wines_region
LIMIT 3;

SELECT DISTINCT id, name, ratings_average, ratings_count, country_code,
FROM wines_region
ORDER BY ratings_count DESC
LIMIT 10;

/*markdown
We have a marketing budget for this year, which country should we prioritise and why?
*/

SELECT countries.code AS country_code, countries.name AS country_name,
countries.regions_count, countries.users_count,
countries.wines_count, countries.wineries_count,
toplists.name AS toplistsname, wines.name AS wine_name,
wines.wineries_count
FROM countries
INNER JOIN toplists
ON toplists.country_code = countries.code
INNER JOIN wines
ON wines.region_id = region.id
INNER JOIN countries
ON region.country_code = countries.code
LIMIT 3;

ALTER TABLE countries
ADD COLUMN toplistsname TEXT;

UPDATE countries
SET toplistsname = (SELECT name
FROM toplists
WHERE toplists.country_code = countries.code);

SELECT *
FROM countries
LIMIT 2;

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

SELECT winery_name, ROUND(AVG(ratings_average), 1), SUM(ratings_count), name, SUM(users_count)
FROM countries_wines_region
GROUP BY winery_name
HAVING ROUND(AVG(ratings_average), 1) > 4.6

ORDER BY SUM(ratings_count) DESC;


SELECT winery_name, ROUND(AVG(ratings_average), 1), 
SUM(ratings_count), SUM(users_count), name
FROM countries_wines_region
GROUP BY winery_name
HAVING ROUND(AVG(ratings_average), 1) > 4.6
ORDER BY SUM(ratings_count) DESC;

/*markdown
(ROUND(SUM(ratings_count))/(SUM(users_count)*100)) AS test
*/

SELECT winery_name, ROUND(AVG(ratings_average), 2), 
SUM(ratings_count), SUM(users_count), 
(SUM(ratings_count))*100 / (SUM(users_count)) AS test, name
FROM countries_wines_region
GROUP BY winery_name
HAVING ROUND(AVG(ratings_average), 2) > 4.6
ORDER BY SUM(ratings_count) DESC;


SELECT winery_name, ROUND(AVG(ratings_average), 1) AS ratings_average, SUM(ratings_count) AS ratings_count
FROM wines
GROUP BY winery_name
ORDER BY ratings_count DESC
LIMIT 10;

/*markdown
We has detected that a big cluster of customers like a specific combination of tastes. We have identified few primary keywords that matches this and we would like you to find all the wines that have those keywords. To ensure accuracy of our selection, ensure that more than 10 users confirmed those keywords. Also, identify the flavor_groups related to those keywords.
Coffee
Toast
Green apple
cream
citrus
*/

CREATE VIEW wines_keywords_wine AS 
SELECT * 
FROM wines
INNER JOIN keywords_wine
ON wines.id = keywords_wine.wine_id;

SELECT * 
FROM wines_keywords_wine
LIMIT 3;

SELECT group_name AS flavor_name, "name:1" AS tastes
FROM wines_keywords_wine_keywords1
LIMIT 3;


SELECT id, name AS wine_name, keyword_id, count
FROM wines_keywords_wine
WHERE count > 10
ORDER BY count DESC
LIMIT 3;

CREATE VIEW wines_keywords_wine_keywords1 AS 
SELECT * 
FROM wines_keywords_wine
INNER JOIN keywords
ON wines_keywords_wine.keyword_id = keywords.id;

SELECT COUNT(id)
FROM wines_keywords_wine_keywords1;

SELECT COUNT(keyword_type)
FROM keywords_wine
WHERE keyword_type ='primary';

SELECT DISTINCT keyword_id, "name:1" AS tastes, name AS wine_name, count, keyword_type
FROM wines_keywords_wine_keywords1
WHERE "name:1" IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
AND keyword_type = 'primary'
AND count > 10
ORDER BY name
LIMIT 5;

SELECT DISTINCT keyword_id, "name:1" AS tastes, name AS wine_name, count, keyword_type, group_name AS flavor_groups
FROM wines_keywords_wine_keywords1
WHERE tastes IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
AND keyword_type = 'primary'
AND count > 10
ORDER BY wine_name;

SELECT DISTINCT keyword_id, name AS wine_name, count, keyword_type, group_name AS flavor_groups
FROM wines_keywords_wine_keywords1
WHERE keyword_type = 'primary'
AND count > 2500
ORDER BY wine_name;

SELECT DISTINCT keyword_id, "name:1" AS tastes, name AS wine_name, count, keyword_type, group_name AS flavor_groups
FROM wines_keywords_wine_keywords1
WHERE tastes IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
AND keyword_type = 'primary'
AND count > 10
GROUP BY flavor_groups
ORDER BY wine_name;

SELECT DISTINCT group_name AS flavor_groups
FROM wines_keywords_wine_keywords1;

SELECT DISTINCT group_name AS flavor_groups, "name:1" AS tastes
FROM wines_keywords_wine_keywords1
WHERE tastes IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')

ORDER BY flavor_groups;

CREATE VIEW wines_keywords_wine_keywords1_regions1 AS 
SELECT * 
FROM wines_keywords_wine_keywords1
INNER JOIN regions
ON wines_keywords_wine_keywords1.region_id = regions.id;

SELECT *
FROM wines_keywords_wine_keywords1_regions1
LIMIT 3;

SELECT DISTINCT wine_id, name AS wine_name, COUNT("name:1") AS tastes_count, ratings_average, country_code
FROM wines_keywords_wine_keywords1_regions1
WHERE count > 10
AND keyword_type IN ('primary')
AND "name:1" IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
GROUP BY wine_id
HAVING COUNT(DISTINCT "name:1") = 5
ORDER BY ratings_average DESC;

SELECT DISTINCT wine_id, name AS wine_name, COUNT(group_name) AS flavor_groups, COUNT("name:1") AS tastes_count, COUNT(count)
FROM wines_keywords_wine_keywords1
WHERE count > 10
AND keyword_type IN ('primary')
AND wine_id IN (7122486)
AND "name:1" IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
ORDER BY tastes_count;

SELECT DISTINCT wine_id, name AS wine_name, group_name AS flavor_groups, "name:1" AS tastes, count
FROM wines_keywords_wine_keywords1
WHERE count > 10
AND keyword_type IN ('primary')
AND wine_id IN (7122486)
AND tastes IN ('coffee', 'toast', 'green apple', 'cream', 'citrus');

SELECT DISTINCT name AS wine_name, group_name AS flavor_groups, count, COUNT("name:1") AS tastes_count
FROM wines_keywords_wine_keywords1
WHERE count > 10
AND keyword_type IN ('primary')
AND wine_name IN ('Tignanello')
GROUP BY flavor_groups;

SELECT DISTINCT name AS wine_name, COUNT(group_name) AS flavor_groups, COUNT(count), COUNT("name:1") AS tastes_count
FROM wines_keywords_wine_keywords1
WHERE count > 10
AND keyword_type IN ('primary')
AND "name:1" IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
GROUP BY wine_name;

SELECT *
FROM wines_keywords_wine_keywords1
LIMIT 3;

SELECT name AS wine_name, ratings_average, ratings_count, group_name AS flavor_group, keyword_type, count, "name:1" AS tastes
FROM wines_keywords_wine_keywords1

LIMIT 3;

SELECT name AS wine_name, group_name AS flavor_group, keyword_type, "name:1" AS tastes
FROM wines_keywords_wine_keywords1
WHERE wine_name IN ('Brunello di Montalcino Riserva')
AND keyword_type IN ('primary')
GROUP BY tastes
ORDER BY flavor_group
LIMIT 30;

SELECT DISTINCT group_name AS flavor_groups, "name:1" AS tastes
FROM wines_keywords_wine_keywords1
WHERE tastes IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
AND count > 10
ORDER BY flavor_groups;

/*markdown
We would like to do a selection of wines that are easy to find all over the world. Find the top 3 most common grape all over the world and for each grape, give us the the 5 best rated wines.
*/

SELECT country_code, grape_id, wines_count
FROM most_used_grapes_per_country
WHERE country_code LIKE 'it'
GROUP BY country_code, grape_id;



SELECT country_code, grape_id, wines_count
FROM most_used_grapes_per_country
ORDER BY wines_count DESC;

SELECT country_code, grape_id, wines_count
FROM most_used_grapes_per_country
GROUP BY grape_id, country_code
ORDER BY wines_count DESC
LIMIT 5;

CREATE VIEW most_used_grapes_per_country_grapes AS 
SELECT * 
FROM most_used_grapes_per_country
INNER JOIN grapes
ON most_used_grapes_per_country.grape_id = grapes.id;

SELECT * 
FROM most_used_grapes_per_country_grapes
LIMIT 3;

SELECT grape_id, name AS grape_name, COUNT(country_code), wines_count
FROM most_used_grapes_per_country_grapes
GROUP BY grape_id
ORDER BY wines_count DESC
LIMIT 10;

SELECT grape_id, name AS grape_name, wines_count, country_code
FROM most_used_grapes_per_country_grapes
WHERE grape_name IN ('Chardonnay')
ORDER BY wines_count DESC;

/*markdown
We would to give create a country leaderboard, give us a visual that shows the average wine rating for each country. Do the same for the vintages.
*/

SELECT *
FROM countries_wines_region
LIMIT 3;

SELECT code, name AS country, ROUND(AVG(ratings_average), 2) AS average_wine_rating
FROM countries_wines_region
GROUP BY code
ORDER BY average_wine_rating DESC;

/*markdown
Vintages
*/

SELECT *
FROM vintages
ORDER BY id
LIMIT 3;

SELECT *
FROM countries_wines_region
LIMIT 3;

SELECT id
FROM countries_wines_region
WHERE id IN (1471);

CREATE VIEW countries_wines_region_vintages1 AS 
SELECT * 
FROM countries_wines_region
INNER JOIN vintages
ON countries_wines_region.id = vintages.wine_id;

SELECT * 
FROM countries_wines_region_vintages1
LIMIT 3;

SELECT name AS country, ROUND(AVG("ratings_average:1"), 2) AS vintage_average_rating
FROM countries_wines_region_vintages1
GROUP BY country
ORDER BY vintage_average_rating DESC;

SELECT c.name AS country, ROUND(AVG(v.ratings_average), 2) AS vintage_average_rating
FROM vintages AS v
INNER JOIN wines AS w 
ON v.wine_id = w.id
INNER JOIN regions AS r 
ON w.region_id = r.id
INNER JOIN countries AS c 
ON r.country_code = c.code
GROUP BY c.name 
ORDER BY vintage_average_rating DESC;

/*markdown
Give us any other useful insights you found in our data. Be creative!
*/

/*markdown
One of our VIP client like Cabernet Sauvignon, he would like a top 5 recommandation, which wines would you recommend to him?
*/

SELECT *
FROM wines_keywords_wine_keywords1
WHERE name IN ('Cabernet Sauvignon')
LIMIT 3;

SELECT DISTINCT wine_id, name AS wine_name, group_name
FROM wines_keywords_wine_keywords1
WHERE wine_name IN ('Cabernet Sauvignon')
AND keyword_type IN ('primary')
AND count > 10
GROUP BY wine_id, group_name
ORDER BY wine_id;

SELECT DISTINCT wine_id, name AS wine_name, tannin, "name:1" AS tastes
FROM wines_keywords_wine_keywords1
WHERE wine_name IN ('Cabernet Sauvignon')
GROUP BY tastes
ORDER BY wine_id;

SELECT DISTINCT group_name
FROM wines_keywords_wine_keywords1
GROUP BY group_name;

SELECT DISTINCT wine_id, name AS wine_name, group_name
FROM wines_keywords_wine_keywords1
WHERE wine_name IN ('Cabernet Sauvignon')
AND keyword_type IN ('primary')
AND count > 10
GROUP BY wine_id, group_name
ORDER BY wine_id;