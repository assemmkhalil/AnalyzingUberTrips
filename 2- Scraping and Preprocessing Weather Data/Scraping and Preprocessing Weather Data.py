#!/usr/bin/env python
# coding: utf-8


import requests
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime
import re


# Data Scraping

def remove_empty_strings(data):
    """
    This recursive function removes empty strings that may result from the scraping process.
    Args: data structure (nested list).
    Returns: cleaned data structre.
    """
    if isinstance(data, list):
        return [remove_empty_strings(item) for item in data if item != '']
    else:
        return data


def weather_scraping(year, days_of_months):
    """
    This function scrapes the hourly weather status.
    Args: the year, and a dictionary of the months and the corresponding number of days in each month.
    Returns: a nested list where each sublist contains the weather status for an hour.
    """
    rows = []
    
    for month in days_of_months:
        for day in range(1, days_of_months[month]+1):
            url = f'https://weatherspark.com/h/d/23912/{year}/{month}/{day}/' \
                   'Historical-Weather-on-Tuesday-April-1-2014-in-New-York-City-New-York-United-States'
            
            response = requests.get(url)
            if response.status_code == 200:
                source_code = response.text
                soup = BeautifulSoup(source_code, 'lxml')
                table = soup.find('table', class_='History-MetarReports-outer_table')
                
                # Iterating over the hours from 00 to 19
                for i in range(2):
                    for j in range(10):
                        new_row = []
                        records = table.find_all('tr', id=f'metar-{i}{j}-51')
                        for record in records:
                            if record.find('td', class_='nowrap b'):
                                for cell in record:
                                    new_row.append(cell.text.strip())
                        new_row.insert(0, f'{year}-{month}-{day}')
                        rows.append(new_row)
                
                # Iterating over the hours from 20 to 23
                for i in range(2, 3):
                    for j in range(4):
                        new_row = []
                        records = table.find_all('tr', id=f'metar-{i}{j}-51')
                        for record in records:
                            if record.find('td', class_='nowrap b'):
                                for cell in record:
                                    new_row.append(cell.text.strip())
                        new_row.insert(0, f'{year}-{month}-{day}')
                        rows.append(new_row)
            
            else:
                print('HTTP request failed.')
            
    filt_rows = remove_empty_strings(rows)
    return filt_rows


months = {4:30, 5:31, 6:30, 7:31, 8:31, 9:30}
rows = weather_scraping(2014, months)


columns = ['date', 'time', 'temperature', 'altitude', 'wind', 'visibility', 'cloud_cover']
weather_df = pd.DataFrame(rows, columns=columns)


# Data Preprocessing

weather_df.head()


weather_df.info()


# Firstly, we need to parse the date and convert the hour to the 24-hour system.

weather_df.date = pd.to_datetime(weather_df.date)


weather_df.date.head()


def get_hour(time):
    """
    This function parses the string containing the time formatted in the
    12-hours system and returns only the hour formatted in the 24-hours system.
    Args: the hour in 12-hours format.
    Returns: the hour in 24-hours format.
    """
    hour = datetime.strptime(time, "%I:%M %p").hour
    return hour


weather_df['hour'] = weather_df.time.apply(get_hour)

weather_df[['time', 'hour']].sample(5)  # Validation


# Next, we will keep only the numeric values of "temperature", "altitude", "wind", "visibility" and drop the measurement unit.

def get_value(record):
    """
    This function extracts only the numeric value from each string record.
    Args: the string.
    Returns: the numeric value.
    """
    value = re.search(r'(\d+\.\d+|\d+)', record)
    if value:
        return float(value.group())
    else:
        return None


weather_df['parsed_temp'] = weather_df.temperature.apply(get_value)

weather_df[['temperature', 'parsed_temp']].sample(5)  # Validation


weather_df['parsed_alt'] = weather_df.altitude.apply(get_value)

weather_df[['altitude', 'parsed_alt']].sample(5)  # Validation


weather_df['parsed_wind'] = weather_df.wind.apply(get_value)

weather_df[['wind', 'parsed_wind']].sample(5)  # Validation


weather_df['parsed_vis'] = weather_df.visibility.apply(get_value)

weather_df[['visibility', 'parsed_vis']].sample(5)  # Validation


# Finally, for "cloud_cover", we will remove any text enclosed in parentheses and the surrounding whitespace.

weather_df['parsed_cloud'] = weather_df['cloud_cover'].str.replace(r'\s*\(.+?\)\s*', '', regex=True)

weather_df[['cloud_cover', 'parsed_cloud']].sample(5)  # Validation


filt_df = weather_df[['date', 'hour', 'parsed_temp', 'parsed_alt', 'parsed_wind', 'parsed_vis', 'parsed_cloud']]

filt_df.rename(columns={'parsed_temp':'temperature', 'parsed_alt':'altitude', 'parsed_wind':'wind',
                        'parsed_vis':'visibility', 'parsed_cloud':'cloud_cover'}, inplace=True)


filt_df.info()


filt_df.to_csv('weather.csv', index=False)