from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
import requests
import pandas as pd
import mysql.connector

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 1, 31),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    'brewery_data_pipeline',
    default_args=default_args,
    schedule_interval=timedelta(days=1),  # Run daily
    catchup=False
)

# Function to fetch and store brewery data
def fetch_and_store_data():
    url = "https://api.openbrewerydb.org/v1/breweries"
    response = requests.get(url)

    if response.status_code != 200:
        raise Exception(f"Failed to fetch data from API. Status code: {response.status_code}")

    data = response.json()
    breweries_df = pd.DataFrame(data)

    # Create MySQL connection
    connection = mysql.connector.connect(
        host='localhost',
        user='root',
        password='your_new_password',
        database='BREW'
    )
    cursor = connection.cursor()

    # Ensure table exists
    create_table_query = """
    CREATE TABLE IF NOT EXISTS breweries (
        id VARCHAR(255) PRIMARY KEY,
        name VARCHAR(255),
        brewery_type VARCHAR(100),
        address_1 VARCHAR(255),
        address_2 VARCHAR(255),
        address_3 VARCHAR(255),
        city VARCHAR(100),
        state_province VARCHAR(100),
        postal_code VARCHAR(20),
        country VARCHAR(100),
        longitude DECIMAL(10, 8),
        latitude DECIMAL(10, 8),
        phone VARCHAR(20),
        website_url VARCHAR(255),
        state VARCHAR(100),
        street VARCHAR(255)
)
 """
    cursor.execute(create_table_query)

    # Insert or update records
    insert_query = """
    INSERT INTO breweries (id, name, type, city, state)
    VALUES (%s, %s, %s, %s, %s)
    ON DUPLICATE KEY UPDATE
        name = VALUES(name),
        type = VALUES(type),
        city = VALUES(city),
        state = VALUES(state)
    """

    for _, row in breweries_df.iterrows():
        cursor.execute(insert_query, (
            row.get("id"), row.get("name"), row.get("brewery_type"),
            row.get("city"), row.get("state")
        ))

    connection.commit()
    cursor.close()
    connection.close()

# Define PythonOperator task for fetching and storing data
fetch_store_task = PythonOperator(
    task_id='fetch_store_brewery_data',
    python_callable=fetch_and_store_data,
    dag=dag,
)

# Set task execution order
fetch_store_task
