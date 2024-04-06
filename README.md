The project is in progress

## SwissSnowFinderSRV

SwissSnowFinderSRV is your ultimate server script for discovering ski stations with the best snow conditions in Switzerland.

### 🧱 Building Steps

1. **Create Ski Station Information Table:**
   - Develop a table containing crucial ski station details, including name, coordinates, and region.

2. **Establish API Request Mechanism:**
   - Set up a robust API request mechanism to fetch the ski stations' table.
   - Initiate API requests for all ski station coordinates, aggregating the results into another comprehensive table.

3. **Implement SQL View for Meteorological Data:**
   - Integrate an SQL view to generate a summarized timeline of all meteorological data from the ski stations.
   - Enable subscriptions for snow accumulation notifications triggered by high temperatures.

4. **Devise Snow Identification Algorithm:**
   - Develop a smart algorithm to identify the ski station with the most snow in the user's chosen region, leveraging data from the SQL view.

### 🚀 Getting Started

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/AurelDeveloper/SwissSnowFinderSRV.git
   ```
   
2. **Navigate to the Project Directory:**
   ```bash
   cd SwissSnowFinderSRV
   ```
   
3. **Install the venv and the requirements**
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

4. **Launch the test.py**
   ```bash
   python tests/test.py
   ```

### License

This project is licensed under the [GNU General Public License v3.0](LICENSE).
