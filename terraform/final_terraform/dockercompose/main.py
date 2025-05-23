from flask import Flask, request
import os
import mysql.connector
from mysql.connector import Error
from datetime import datetime

app = Flask(__name__)

# Получаем переменные окружения
db_host = os.environ.get('DB_HOST')
db_user = os.environ.get('DB_USER')
db_password = os.environ.get('DB_PASSWORD')
db_database = os.environ.get('DB_NAME')
db_table = os.environ.get('DB_TABLE')

# Подключение к базе данных
try:
    db = mysql.connector.connect(
        host=db_host,
        user=db_user,
        password=db_password,
        database=db_database,
        autocommit=True
    )
    cursor = db.cursor()

    # Создание таблицы, если не существует
    create_table_query = f"""
    CREATE TABLE IF NOT EXISTS `{db_table}` (
        id INT AUTO_INCREMENT PRIMARY KEY,
        request_date DATETIME,
        request_ip VARCHAR(255)
    )
    """
    cursor.execute(create_table_query)

except Error as e:
    print("Ошибка подключения к базе данных:", e)
    cursor = None


@app.route('/')
def index():
    if cursor is None:
        return "Ошибка подключения к базе данных", 500

    # Получаем IP адрес клиента
    ip_address = request.headers.get('X-Forwarded-For', request.remote_addr)

    # Запись в базу
    try:
        now = datetime.now()
        current_time = now.strftime("%Y-%m-%d %H:%M:%S")
        query = f"INSERT INTO `{db_table}` (request_date, request_ip) VALUES (%s, %s)"
        values = (current_time, ip_address)
        cursor.execute(query, values)
        db.commit()

        return f'TIME: {current_time}, IP: {ip_address}'

    except Error as e:
        print("Ошибка при вставке данных:", e)
        return "Ошибка сервера", 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
