/*markdown
We want to highlight 10 wines to increase our sales, which ones should we choose and why?
*/

SELECT countries.name AS country_name, wines.name AS wine_name, ratings_average, ratings_count, countries.users_count AS number_of_users
FROM regions
INNER JOIN wines
ON regions.id = wines.region_id
INNER JOIN countries
ON regions.country_code = countries.code
ORDER BY ratings_count DESC
LIMIT 10;


/*markdown
We have a marketing budget for this year, which country should we prioritise and why?
*/

SELECT countries.name AS country_name, ROUND(AVG(ratings_average), 1) AS ratings, countries.users_count AS number_of_users, countries.wineries_count AS number_of_wineries 
FROM regions
INNER JOIN wines
ON regions.id = wines.region_id
INNER JOIN countries
ON regions.country_code = countries.code
INNER JOIN wineries
ON wines.winery_id = wineries.id
GROUP BY country_name
ORDER BY number_of_users DESC
LIMIT 10;

/*markdown
We would like to give a price to the best winery, which one should we choose and why?
*/

SELECT wineries.name AS winery_name, countries.name AS country_name,
SUM(wines.ratings_count) AS ratings_count,
ROUND(AVG(ratings_average), 1) AS ratings,
SUM(countries.users_count) AS number_of_users
FROM regions
INNER JOIN wines
ON regions.id = wines.region_id
INNER JOIN countries
ON regions.country_code = countries.code
INNER JOIN wineries
ON wines.winery_id = wineries.id
GROUP BY winery_name
HAVING ratings > 4.6
ORDER BY ratings_count DESC
LIMIT 3;

/*markdown
We has detected that a big cluster of customers like a specific combination of tastes. We have identified few primary keywords that matches this and we would like you to find all the wines that have those keywords. To ensure accuracy of our selection, ensure that more than 10 users confirmed those keywords. Also, identify the flavor_groups related to those keywords.
Coffee
Toast
Green apple
cream
citrus
*/

SELECT wines.id AS wine_id, wines.name AS wine_name, wines.ratings_average, regions.country_code
FROM regions
INNER JOIN wines
ON regions.id = wines.region_id
INNER JOIN keywords_wine
ON wines.id = keywords_wine.wine_id
INNER JOIN keywords
ON keywords_wine.keyword_id = keywords.id
WHERE keywords_wine.count > 10
AND keywords.name IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
AND keywords_wine.keyword_type IN ('primary')
GROUP BY wine_id
HAVING COUNT(DISTINCT keywords.name) = 5
ORDER BY wines.ratings_average DESC;

SELECT DISTINCT keywords_wine.group_name AS flavor_groups, keywords.name
FROM keywords
INNER JOIN keywords_wine
ON keywords_wine.keyword_id = keywords.id
WHERE keywords_wine.count > 10
/*AND keywords_wine.keyword_type IN ('primary')*/
AND keywords.name IN ('coffee', 'toast', 'green apple', 'cream', 'citrus')
ORDER BY flavor_groups;

/*markdown
We would like to do a selection of wines that are easy to find all over the world. Find the top 3 most common grape all over the world and for each grape, give us the the 5 best rated wines.
*/

SELECT grape_id, name AS grape_name, COUNT(country_code), wines_count
FROM most_used_grapes_per_country_grapes
GROUP BY grape_id
ORDER BY wines_count DESC
LIMIT 3;

SELECT DISTINCT most_used_grapes_per_country.grape_id AS grape_id, grapes.name AS grapes_name,
COUNT(most_used_grapes_per_country.country_code) AS country_code, most_used_grapes_per_country.wines_count
FROM most_used_grapes_per_country
INNER JOIN grapes
ON grapes.id = most_used_grapes_per_country.grape_id
GROUP BY grape_id
ORDER BY wines_count DESC
LIMIT 3;

/*markdown
We would to give create a country leaderboard, give us a visual that shows the average wine rating for each country. Do the same for the vintages.
*/

SELECT c.code, ROUND(AVG(w.ratings_average), 2) AS average_rating
FROM wines w
JOIN regions r 
ON w.region_id = r.id
JOIN countries c 
ON r.country_code = c.code
GROUP BY c.code
ORDER BY average_rating DESC;

/*markdown
Vintages
*/

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

*/

SELECT v.name,w.ratings_average,w.ratings_count
from wines as w 
inner join vintages as v
on v.wine_id=w.id
WHERE w.name LIKE "Cabernet Sauvignon%"
AND w.ratings_average > 4.5
ORDER BY w.ratings_count DESC;