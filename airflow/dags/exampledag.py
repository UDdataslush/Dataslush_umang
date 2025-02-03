from airflow import DAG
from airflow.operators.python import PythonOperator
import pendulum
from datetime import datetime


def print_welcome():
    print('Welcome to Airflow Learner!')

def print_date():
    print('Today is {}'.format(datetime.today().date()))

# Define default arguments
default_args = {
    'start_date': pendulum.today('UTC').add(days=-1),
}

# Define the DAG
with DAG(
    'hey_ud_dag',
    default_args=default_args,
    schedule='0 23 * * *',  # Updated argument name
    catchup=False,
    description="this is a  simple DAG that prints messages",
) as dag:
    # Define the tasks
    print_welcome_task = PythonOperator(
        task_id='print_welcome',
        python_callable=print_welcome,
    )
    print_date_task = PythonOperator(
        task_id='print_date',
        python_callable=print_date,
    )
    # Set task dependencies
    print_welcome_task >> print_date_task
