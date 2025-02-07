from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import requests
import pandas as pd
import mysql.connector
import requests

# Function to fetch and store data
def fetch_and_store_data():
    # Define API URL
    API_URL = "https://api.openbrewerydb.org/v1/breweries"
    
    # Make API Request
    response = requests.get(API_URL)
    response_code = response.status_code  # Store response code separately

    # Debug: Print URL and response code
    print(f"API Request URL: {API_URL}")
    print(f"Response Code: {response_code}")

    # Check for successful response
    if response_code != 200:
        raise Exception(f"Failed to fetch data from API. Status code: {response_code}")

    data = response.json()

    # Create MySQL connection
    try:
        connection = mysql.connector.connect(
            host='localhost',  
            user='root',
            password='#Dave12345',
            database='BREW'
        )
        cursor = connection.cursor()

        # Ensure table exists
        create_table_query = """
        CREATE TABLE IF NOT EXISTS breweries (
            id VARCHAR(255) PRIMARY KEY,
            name VARCHAR(255),
            
        );
        """
        cursor.execute(create_table_query)

        # Insert data
        insert_query = """
        INSERT INTO breweries (id, name, brewery_type, address_1, address_2, address_3, 
                               city, state_province, postal_code, country, '''longitude''', 
                               '''latitude''', phone, website_url, state, street)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        ON DUPLICATE KEY UPDATE
            name = VALUES(name),
            brewery_type = VALUES(brewery_type),
            address_1 = VALUES(address_1),
            address_2 = VALUES(address_2),
            address_3 = VALUES(address_3),
            city = VALUES(city),
            state_province = VALUES(state_province),
            postal_code = VALUES(postal_code),
            country = VALUES(country),
            # longitude = VALUES(longitude),
            # latitude = VALUES(latitude),
            phone = VALUES(phone),
            website_url = VALUES(website_url),
            state = VALUES(state),
            street = VALUES(street)
        """
        
        for brewery in data:
            values = (
                brewery['id'],
                brewery['name'],
                brewery['brewery_type'],
                brewery['address_1'],
                brewery.get('address_2', None),
                brewery.get('address_3', None),
                brewery['city'],
                brewery['state_province'],
                brewery['postal_code'],
                brewery['country'],
                # float(brewery['longitude']) if brewery['longitude'] else None,
                # float(brewery['latitude']) if brewery['latitude'] else None,
                brewery['phone'],
                brewery['website_url'],
                brewery['state'],
                brewery['street']
            )

            # Debug: Print each row before insertion
            print("Inserting row:", values)

            cursor.execute(insert_query, values)

        connection.commit()
        print("Data successfully inserted into MySQL!")

    except mysql.connector.Error as err:
        print(f"MySQL Error: {err}")

    finally:
        cursor.close()
        connection.close()

# Execute the function to fetch and store data
fetch_and_store_data()

