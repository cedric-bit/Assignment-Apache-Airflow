from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta

default_args = {
    'start_date': datetime(2023, 11, 11),
    'catchup': False
}

with DAG(dag_id='process_web_log', default_args=default_args, schedule_interval='@daily',
         description='A simple DAG to process web log files', tags=['data_engineering']) as dag:

    def scan_for_log():
        import os
        log_folder = 'the_logs'
        log_file = '/home/ubuntus/airflow/dags/the_logs/log.txt' 
        log_file_path = os.path.join(log_folder, log_file)
        if os.path.exists(log_file_path):
            print(f"Found '{log_file_path}'")
        else:
            print(f"'{log_file_path}' not found")

    scan_log_task = PythonOperator(
        task_id='scan_for_log',
        python_callable=scan_for_log)

    def extract_data():
        log_file_path = '/home/ubuntus/airflow/dags/the_logs/log.txt'   # Chemin complet vers log.txt
        output_file_path = '/home/ubuntus/airflow/dags/extracted_data.txt'  # Chemin complet pour le fichier de sortie

        with open(log_file_path, 'r') as file:
            with open(output_file_path, 'w') as output_file:
                for line in file:
                    ip_address = line.split()[0]  # On suppose que l'adresse IP est le premier élément de la ligne
                    output_file.write(ip_address + '\n')


    extract_data_task = PythonOperator(
        task_id='extract_data',
        python_callable=extract_data)

    def transform_data():
        input_file = '/home/ubuntus/airflow/dags/extracted_data.txt' 
        output_file = '/home/ubuntus/airflow/dags/transformed_data.txt'
        filter_ip = '198.46.149.143'
        with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
            for line in infile:
                if filter_ip not in line:
                    outfile.write(line)

    transform_data_task = PythonOperator(
        task_id='transform_data',
        python_callable=transform_data)

    def load_data():
        import tarfile
        with tarfile.open('/home/ubuntus/airflow/dags/weblog.tar', 'w') as tar:
            tar.add('/home/ubuntus/airflow/dags/transformed_data.txt')

    load_data_task = PythonOperator(
        task_id='load_data',
        python_callable=load_data)
    
    def notify_execution():
        message_file_path = '/home/ubuntus/airflow/dags/workflow_execution_message.txt'
        message = 'The workflow was executed successfully.'
        with open(message_file_path, 'w') as file:
            file.write(message)

    notify_execution_task = PythonOperator(
      task_id='notify_execution',
       python_callable=notify_execution,
    )



    scan_log_task >> extract_data_task >> transform_data_task >> load_data_task>> notify_execution_task
