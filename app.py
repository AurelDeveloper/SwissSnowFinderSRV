from src.api import weather

def run_script():
    weather.fetch_and_store_weather_data()

if __name__ == '__main__':
    run_script()