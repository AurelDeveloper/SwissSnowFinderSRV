import os
import sqlite3
import subprocess

SCRIPT_PATHS = {
    'schema': '../db/swisssnow.sql',
    'insert': './insert.sql',
    'weather': '../src/weather.py',
    'view': '../db/view.sql',
    'finder': '../src/finder.py'
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
    subprocess.check_call(["python", file_path])

db_path = 'swisssnow.sqlite'

if os.path.exists(db_path):
    if ask_continue("database", db_path):
        os.remove(db_path)
    else:
        print("Script aborted.")
        exit()

conn = sqlite3.connect(db_path)

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

if ask_continue("view", SCRIPT_PATHS['view']):
    execute_sql_file(conn, SCRIPT_PATHS['view'])
else:
    print("Script aborted.")
    exit()

if ask_continue("finder", SCRIPT_PATHS['finder']):
    execute_python_file(SCRIPT_PATHS['finder'])
else:
    print("Script aborted.")
    exit()

conn.close()