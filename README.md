# Analyzing Uber Trips in New York:
![Dashboard](https://github.com/assemmkhalil/AnalyzingUberTrips/assets/126206911/09b02060-64ce-41d6-ab7d-ac0a283292bb)


## Introduction:
This project aims to explore and analyze Uber pickup data in New York during the period from April to September 2014. <br>
The primary objectives of this project are to gain insights into Uber pickup patterns, explore correlations between pickups and time, location, and weather conditions, and create visualizations to better understand the trends in the data.


## Data Collection and Preparation:

#### Data Collection:
The project utilized two datasets:
1. Uber Pickups Data: Obtained by FiveThirtyEight from the NYC Taxi & Limousine Commission (TLC), providing the date, time, and coordinates of Uber pickups in New York City from April to September 2014. [Source](https://www.kaggle.com/datasets/fivethirtyeight/uber-pickups-in-new-york-city)
2. Weather Data: Scraped from the website [Weather Spark](https://weatherspark.com), providing hourly weather conditions in New York City for the same period.

#### Data Preprocessing:
* Uber datasets were concatenated, and the dates and hours were parsed.
* Weather dataset was cleaned, with the dates parsed and the hours converted to 24-hour format, the numeric values parsed, and the categorical values standardized.


## Data Analysis with SQL:
* For each dataset, a table was created with a surrogate key to serve as the primary key, and a composite index was created on the date and hour columns to optimize querying and retrieving data.
* EDA was performed using SQL queries to investigate patterns, relationships, and trends within the data. Various statistical and aggregate functions were utilized to extract meaningful insights about the demand for Uber and pickup patterns and correlations.

## Data Analysis with Power BI:
* For each dataset, a column combining date and hour was created to serve as a composite key to create the many to one relationship between the uber_pickups and weather tables.
* Five columns (day_of_month, day_name, month_name, time_slot, rush_hours) and three measures (total_rides_count, avg_trips_per_day, avg_trips_per_hour) were calculated in the uber_pickups table to further expand the analysis.
* Three columns (temp_category, wind_category, vis_category) were calculated in the weather table to categorize the weather condition to make it easier to interpret.
* EDA was performed by creating a series of visualizations to answer key questions and display crucial metrics. At the end, a comprehensive and interactive dashboard was built, incorporating the visualizations and metrics derived from the analysis.

## Findings and Insights:
For the detailed findings and insights of the analysis, please refer to the notebook file.
