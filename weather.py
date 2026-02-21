import requests
import json
import sqlite3
import pandas as pd
import os
import matplotlib.pyplot as plt
from datetime import datetime
from pathlib import Path

API_URL = "https://api.openweathermap.org/data/2.5/weather"
RAW_DATA_PATH = Path("data/raw")
DB_PATH = Path("db/weather.db")


def run_weather_etl(api_key, city="Cologne", units="metric"):

    #EXTRACT
    params = {
        "q": city,
        "appid": api_key,
        "units": units
    }

    response = requests.get(API_URL, params=params)
    response.raise_for_status()
    raw_json = response.json()

    #Save raw JSON
    RAW_DATA_PATH.mkdir(parents=True, exist_ok=True)
    timestamp = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
    file_path = RAW_DATA_PATH / f"{city}_weather_{timestamp}.json"

    with open(file_path, "w") as f:
        json.dump(raw_json, f, indent=4)

    #TRANSFORM
    df = pd.DataFrame([{
        "city": raw_json["name"],
        "temp": raw_json["main"]["temp"],
        "feels_like": raw_json["main"]["feels_like"],
        "humidity": raw_json["main"]["humidity"],
        "wind_speed": raw_json["wind"]["speed"],
        "weather_main": raw_json["weather"][0]["main"],
        "weather_desc": raw_json["weather"][0]["description"],
        "timestamp": pd.to_datetime(raw_json["dt"], unit="s")
    }])

    #LOAD
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    df.to_sql("weather", conn, if_exists="append", index=False)
    conn.close()

    print("ETL erfolgreich ausgeführt!")

    #Datei automatisch öffnen
    os.system(r'"C:\Program Files\JetBrains\DataGrip\bin\datagrip64.exe" "{}"'.format(DB_PATH))


run_weather_etl("d50ecaafcfaa1e7fd3e6ac41c01614ba")


conn = sqlite3.connect(DB_PATH)
df_all = pd.read_sql_query("SELECT * FROM weather WHERE city='Cologne' ORDER BY timestamp", conn)
conn.close()

print(df_all.tail())

#Temperaturverlauf Köln
plt.figure(figsize=(10, 5))
plt.plot(df_all["timestamp"], df_all["temp"], marker="o")
plt.title("Temperaturverlauf Köln")
plt.xlabel("Zeit")
plt.ylabel("Temperatur (°C)")
plt.grid(True)
plt.tight_layout()
plt.show()
