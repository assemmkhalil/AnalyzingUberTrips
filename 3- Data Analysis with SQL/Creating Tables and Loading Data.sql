-- Creating a table for Uber pickups

CREATE TABLE uber_pickups(
    pickup_id INT AUTO_INCREMENT PRIMARY KEY,  -- Adding a Surrogate Key to serve as the PK
    date DATE NOT NULL,
    hour INT NOT NULL,
    latitude DECIMAL(6, 4) NOT NULL,
    longitude DECIMAL(6, 4) NOT NULL,
    
    INDEX idx_uber_date_hour (date, hour)  -- Creating a composite index
);


-- Creating a table for weather data

CREATE TABLE weather (
    weather_id INT AUTO_INCREMENT PRIMARY KEY,  -- Adding a Surrogate Key to serve as the PK
    date DATE NOT NULL,
    hour INT NOT NULL,
    temperature DECIMAL(3, 1) NOT NULL,  
    altitude DECIMAL(4, 2) NOT NULL,
    wind DECIMAL(4, 2) NOT NULL,
    visibility DECIMAL(4, 2) NOT NULL,
    cloud_cover VARCHAR(13) NOT NULL,
    
    INDEX idx_weather_date_hour (date, hour)  -- Creating a composite index
);


-- Defining the foreign key in the table uber_pickups

ALTER TABLE uber_pickups
ADD CONSTRAINT fk_uber_weather
FOREIGN KEY (date, hour)
REFERENCES weather(date, hour);


-- Loading data into weather table

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/weather.csv'
INTO TABLE weather
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, hour, temperature, altitude, wind, visibility, cloud_cover);


-- Loading data into uber_pickups table

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/uber_pickups.csv'
INTO TABLE uber_pickups
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(date, hour, latitude, longitude);