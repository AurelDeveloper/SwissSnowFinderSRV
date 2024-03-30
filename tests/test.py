import os
import sqlite3
import subprocess

SCRIPT_PATHS = {
    'sqlite3_db': '../swisssnow.sqlite',
    'schema': '../src/sql/schemas/schema.sql',
    'insert': './insert.sql',
    'weather': '../src/scripts/weather.py',
    'cumulative_snowfall': '../src/sql/views/cumulative_snowfall.sql',
    'user_skistation_snowfall': '../src/sql/views/user_skistation_snowfall.sql'
}


def ask_continue(script_name, file_path):
    file_type = os.path.splitext(file_path)[1][1:]
    while True:
        answer = input(f"Execute {script_name}.{file_type}? (y/n): ").lower()
        if answer in ['y', 'n']:
            return answer == 'y'


def execute_sql_file(db_connection, file_path):
    with open(file_path, 'r') as sql_file:
        sql_script = sql_file.read()
    db_connection.executescript(sql_script)


def execute_python_file(file_path):
    subprocess.check_call(["python3", file_path])


if os.path.exists(SCRIPT_PATHS['sqlite3_db']):
    if ask_continue("database", SCRIPT_PATHS['sqlite3_db']):
        os.remove(SCRIPT_PATHS['sqlite3_db'])
    else:
        print("Script aborted.")
        exit()

conn = sqlite3.connect(SCRIPT_PATHS['sqlite3_db'])

if ask_continue("schema", SCRIPT_PATHS['schema']):
    execute_sql_file(conn, SCRIPT_PATHS['schema'])
else:
    print("Script aborted.")
    exit()

if ask_continue("insert", SCRIPT_PATHS['insert']):
    execute_sql_file(conn, SCRIPT_PATHS['insert'])
else:
    print("Script aborted.")
    exit()

if ask_continue("weather", SCRIPT_PATHS['weather']):
    execute_python_file(SCRIPT_PATHS['weather'])
else:
    print("Script aborted.")
    exit()

if ask_continue("cumulative_snowfall", SCRIPT_PATHS['cumulative_snowfall']):
    execute_sql_file(conn, SCRIPT_PATHS['cumulative_snowfall'])
else:
    print("Script aborted.")
    exit()

if ask_continue("user_skistation_snowfall", SCRIPT_PATHS['user_skistation_snowfall']):
    execute_sql_file(conn, SCRIPT_PATHS['user_skistation_snowfall'])
else:
    print("Script aborted.")
    exit()

conn.close()