from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import requests
import pandas as pd
import mysql.connector
import requests


# Default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2025, 2, 2),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Define the DAG
dag = DAG(
    dag_id='A_brewery_data_pipeline',
    default_args=default_args,
    schedule='@daily',  
    catchup=False
)




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

    # Convert the data into a DataFrame
    df = pd.DataFrame(data)

    # Replace all NaN (None) values with 0
    df.fillna(0, inplace=True)



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
            brewery_type VARCHAR(100),
            address_1 VARCHAR(255),
            address_2 VARCHAR(255),
            address_3 VARCHAR(255),
            city VARCHAR(100),
            state_province VARCHAR(100),
            postal_code VARCHAR(20),
            country VARCHAR(100),
            # longitude FLOAT,
            # latitude FLOAT,
            phone VARCHAR(20),
            website_url VARCHAR(255),
            state VARCHAR(100),
            street VARCHAR(255)
        );
        """
        cursor.execute(create_table_query)



        # Insert data
        insert_query = """
        INSERT INTO breweries (id, name, brewery_type, address_1, address_2, address_3, 
                               city, state_province, postal_code, country,   
                               phone, website_url, state, street)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
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
            # try:
            #    longitude = float(brewery['longitude']) if brewery['longitude'] else 0.0
            #    latitude = float(brewery['latitude']) if brewery['latitude'] else 0.0
            # except (ValueError, TypeError):
            #    longitude = 0.0
            #    latitude = 0.0


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
                # longitude,
                # latitude,
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

