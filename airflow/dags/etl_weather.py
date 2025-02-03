from airflow import DAG
from airflow.decorators import task
from airflow.utils.dates import days_ago
import requests
import mysql.connector
import json

# Latitude and longitude for the desired location (India in this case)
LATITUDE = '22'
LONGITUDE = '79'
MYSQL_CONN_ID = 'mysql_default'  # Ensure this matches your MySQL connection in Airflow
API_URL = 'https://api.open-meteo.com'

default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
}

with DAG(dag_id='weather_etl_pipeline',
         default_args=default_args,
         schedule_interval='@daily',
         catchup=False) as dag:

    @task()
    def extract_weather_data():
        """Extract data from Open-Meteo API."""
        endpoint = f'{API_URL}/v1/forecast?latitude={LATITUDE}&longitude={LONGITUDE}&current_weather=true'
        response = requests.get(endpoint)
        if response.status_code == 200:
            return response.json()  # raw weather data
        else:
            raise Exception(f"Failed to fetch weather data: {response.status_code}, {response.text}")

    @task()
    def transform_weather_data(weather_data):
        """Transform extracted weather data."""
        current_weather = weather_data['current_weather']
        transformed_data = {
            'latitude': LATITUDE,
            'longitude': LONGITUDE,
            'temperature': current_weather['temperature'],
            'windspeed': current_weather['windspeed'],
            'winddirection': current_weather['winddirection'],
            'weathercode': current_weather['weathercode']
        }
        return transformed_data
      

     # this below code for connect or load data with in  mysql
    @task()
    def load_weather_data(transformed_data):
        """Load transformed data into MySQL database."""
        connection = mysql.connector.connect(
            host='127.0.0.1',  # Replace with your MySQL host if not localhost
            user='root',       # Replace with your MySQL username
            password='#dave12345', # Replace with your MySQL password
            port = 3306,
            database='weather'  # Replace with your MySQL database name
        )
        cursor = connection.cursor()

        # Insert query
        insert_sql = """
        INSERT INTO weather_data (latitude, longitude, temperature, windspeed, winddirection, weathercode)
        VALUES 
        """
        
        # Data to insert
        data = (
            transformed_data['latitude'],
            transformed_data['longitude'],
            transformed_data['temperature'],
            transformed_data['windspeed'],
            transformed_data['winddirection'],
            transformed_data['weathercode']
        )
        
        # Execute the query
        cursor.execute(insert_sql, data)
        connection.commit()

        # Close connections
        cursor.close()
        connection.close()

    # Define task dependencies
    weather_data = extract_weather_data()  # provides the raw data output 
    transformed_data = transform_weather_data(weather_data)   # uses this output to structure data
    load_weather_data(transformed_data)  #  stores the structured data into the database
