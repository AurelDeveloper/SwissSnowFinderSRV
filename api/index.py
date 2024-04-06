from flask import Flask
from api.utils.weather import fetch_and_store_weather_data

app = Flask(__name__)

@app.route('/fetch_weather')
def fetch_weather():
    fetch_and_store_weather_data()
    return 'Weather data fetched and stored successfully.'

if __name__ == '__main__':
    app.run(debug=True)