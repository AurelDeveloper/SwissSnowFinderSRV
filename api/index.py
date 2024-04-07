def run_script():
    with open('./utils/weather.py', 'r') as file:
        exec(file.read())

run_script()