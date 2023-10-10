-- How many trips were provided from April to September?

SELECT COUNT(*) AS total_number_of_trips
FROM uber_pickups;


-- How does the demand vary across different months?

SELECT MONTHNAME(date) AS month,
       COUNT(*) AS number_of_trips,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM uber_pickups
GROUP BY month
ORDER BY number_of_trips DESC;


-- Are there any specific days with higher demand?

SELECT DAYNAME(date) AS day,
       COUNT(*) AS number_of_trips,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM uber_pickups
GROUP BY day
ORDER BY number_of_trips DESC;

SELECT DAYOFMONTH(date) AS day,
       COUNT(*) AS number_of_trips,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM uber_pickups
GROUP BY day
ORDER BY number_of_trips DESC
LIMIT 10;

SELECT date, DAYNAME(date) AS day,
       COUNT(*) AS number_of_trips
FROM uber_pickups
GROUP BY date
ORDER BY number_of_trips DESC
LIMIT 10;


-- What is the average number of trips per day?

SELECT COUNT(*) / COUNT(DISTINCT date) AS average_trips_per_day
FROM uber_pickups;


-- What are the peak hours for Uber pickups?

SELECT hour,
       COUNT(*) AS number_of_trips,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM uber_pickups
GROUP BY hour
ORDER BY number_of_trips DESC
LIMIT 5;

WITH hour_slots AS (
    SELECT CASE 
            WHEN hour BETWEEN 0 AND 3 THEN 'Late Night'
            WHEN hour BETWEEN 4 AND 7 THEN 'Early Morning'
            WHEN hour BETWEEN 8 AND 11 THEN 'Morning'
            WHEN hour BETWEEN 12 AND 15 THEN 'Afternoon'
            WHEN hour BETWEEN 16 AND 19 THEN 'Evening'
            WHEN hour BETWEEN 20 AND 23 THEN 'Night'
           END AS time_slot
    FROM uber_pickups
)
SELECT time_slot,
       COUNT(*) AS number_of_trips,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM hour_slots
GROUP BY time_slot
ORDER BY number_of_trips DESC;

WITH peak_hours AS (
    SELECT CASE 
            WHEN hour BETWEEN 7 AND 10 THEN 'Morning Rush'
            WHEN hour BETWEEN 16 AND 19 THEN 'Evening Rush'
            ELSE 'Off-peak'
           END AS time_slot
    FROM uber_pickups
)
SELECT time_slot,
       COUNT(*) AS number_of_trips,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM peak_hours
GROUP BY time_slot
ORDER BY number_of_trips DESC;


-- What is the average number of trips per hour?

SELECT COUNT(*) / (COUNT(DISTINCT date) * 24) AS average_trips_per_hour
FROM uber_pickups;


-- Is there any correlation between weather conditions and the number of Uber pickups?

WITH temp_categories AS (
    SELECT CASE 
            WHEN temperature > 85 THEN 'Hot'
            WHEN temperature >= 70 AND temperature <= 85 THEN 'Warm'
            WHEN temperature >= 50 AND temperature < 70 THEN 'Cool'
            WHEN temperature < 50 THEN 'Cold'
           END AS temp_category,
           date, hour
    FROM weather
)
SELECT t.temp_category,
       COUNT(u.date) AS number_of_trips,
       ROUND(COUNT(u.date) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM uber_pickups u
JOIN temp_categories t
ON u.date = t.date AND u.hour = t.hour
GROUP BY t.temp_category
ORDER BY number_of_trips DESC;

WITH wind_categories AS (
    SELECT CASE 
            WHEN wind > 18 THEN 'Windy'
            WHEN wind >= 8 AND wind <= 18 THEN 'Moderate Wind'
            WHEN wind < 8 THEN 'Calm'
           END AS wind_category,
           date, hour
    FROM weather
)
SELECT w.wind_category,
       COUNT(u.date) AS number_of_trips,
       ROUND(COUNT(u.date) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM uber_pickups u
JOIN wind_categories w
ON u.date = w.date AND u.hour = w.hour
GROUP BY w.wind_category
ORDER BY number_of_trips DESC;

WITH vis_categories AS (
    SELECT CASE 
            WHEN visibility > 7 THEN 'Clear Visibility'
            WHEN visibility >= 5 AND visibility <= 7 THEN 'Moderate Visibility'
            WHEN visibility >= 2 AND visibility < 5 THEN 'Haze'
            WHEN visibility >= 1 AND visibility < 2 THEN 'Mist'
            WHEN visibility < 1 THEN 'Fog'
           END AS vis_category,
           date, hour
    FROM weather
)
SELECT v.vis_category,
       COUNT(u.date) AS number_of_trips,
       ROUND(COUNT(u.date) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM uber_pickups u
JOIN vis_categories v
ON u.date = v.date AND u.hour = v.hour
GROUP BY v.vis_category
ORDER BY number_of_trips DESC;

SELECT w.cloud_cover,
       COUNT(u.date) AS number_of_trips,
       ROUND(COUNT(u.date) * 100 / (SELECT COUNT(*) FROM uber_pickups), 2) AS percentage
FROM uber_pickups u
JOIN weather w
ON u.date = w.date AND u.hour = w.hour
GROUP BY w.cloud_cover
ORDER BY number_of_trips DESC;