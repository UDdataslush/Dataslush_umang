# Brewery Data Pipeline with Apache Airflow

## Overview
This project sets up an ETL (Extract, Transform, Load) data pipeline using Apache Airflow to fetch brewery data from the Open Brewery DB API, store it in a MySQL database, and visualize it using Apache Superset.

## Components
- **Apache Airflow**: Used to schedule and automate data extraction.
- **MySQL**: Stores the fetched brewery data.
- **Apache Superset**: Visualizes the data.
- **Python (3.9.21)**: Managed via `pyenv` and used inside a virtual environment (`superdash`).

## Installation
### 1. Set Up Python Environment
```sh
pyenv install 3.9.21
pyenv virtualenv 3.9.21 superdash
pyenv activate superdash
```

### 2. Install Dependencies
```sh
pip install -r requirements.txt
```

### 3. Setup MySQL Database
Ensure MySQL is installed and running. Create a database named `BREW`:
```sql
CREATE DATABASE BREW;
```

### 4. Configure Apache Airflow
Initialize Airflow:
```sh
export AIRFLOW_HOME=~/airflow
airflow db init
```
Create an Airflow user:
```sh
airflow users create --username admin --password admin --firstname Admin --lastname User --role Admin --email admin@example.com
```

### 5. Start Airflow
Run the scheduler and webserver:
```sh
airflow scheduler &
airflow webserver &
```

### 6. Setup Apache Superset
```sh
superset db upgrade
superset fab create-admin
superset init
superset run -p 8088 --with-threads --reload --debugger
```

## Running the Pipeline
1. Place the DAG script in Airflow's DAGs directory.
2. Start the Airflow webserver and enable the DAG from the UI.
3. Verify data in MySQL.
4. Use Apache Superset to connect to MySQL and visualize the data.

## Troubleshooting
- If MySQL connection fails, verify database credentials.
- If Airflow webserver doesn't start, check logs in `~/airflow/logs/`.
- Ensure all required Python packages are installed.


