# 🌦️ Weather ETL Pipeline (Python + SQLite + Matplotlib)  

Dieses Projekt lädt aktuelle Wetterdaten über die OpenWeatherMap‑API, speichert die Rohdaten als JSON, transformiert sie in ein Pandas‑DataFrame und schreibt sie anschließend in eine SQLite‑Datenbank.  
Zusätzlich werden die Daten visualisiert (Temperaturverlauf) und die Datenbank automatisch in DataGrip geöffnet.  

<br>  

## 🚀 Features  

- Abruf aktueller Wetterdaten über die OpenWeatherMap API   
- Speicherung der Rohdaten als JSON (Auditing)  
- Transformation in ein Pandas‑DataFrame  
- Laden in eine SQLite‑Datenbank (`weather.db`)  
- Automatisches Öffnen der Datenbank in DataGrip  
- Matplotlib‑Visualisierung des Temperaturverlaufs  
- Vollständig automatisierte ETL‑Pipeline  

<br>

## 📦 Verwendete Technologien  

- Python 3.10+  
- Requests  
- Pandas  
- SQLite3  
- Matplotlib  
- JetBrains DataGrip    

<br>

## 🧠 Funktionsweise der ETL-Pipeline  

### 1. **Extract**  
Das Skript ruft Wetterdaten über die OpenWeatherMap‑API ab:  

```python  
response = requests.get(API_URL, params=params)  
raw_json = response.json()  
