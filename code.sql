/**Letzte 10 Einträge*/
SELECT * FROM weather
ORDER BY timestamp DESC
LIMIT 10;


/**Anzahl der Messpunkte pro Stadt*/
SELECT city, COUNT(*) AS count_records
FROM weather
GROUP BY city;


/**Durchschnittstemperatur pro Tag*/
SELECT DATE(timestamp) AS day, AVG(temp) AS avg_temp
FROM weather
WHERE city = 'Cologne'
GROUP BY DATE(timestamp)
ORDER BY day DESC;


/**Höchste und niedrigste Temperatur*/
SELECT min(temp) AS kleinsteTemperatur,
       max(temp) AS größteTemperatur
FROM weather
WHERE city = 'Cologne'
ORDER BY temp DESC;


/**Durchschnittliche Luftfeuchtigkeit pro Stunde*/
SELECT
    strftime('%Y-%m-%d %H:00', timestamp) AS hour,
    AVG(humidity) AS avg_humidity
FROM weather
WHERE city = 'Cologne'
GROUP BY hour
ORDER BY hour DESC;


/**Stärkste Windgeschwindigkeit*/
SELECT * FROM weather
WHERE city = 'Cologne'
ORDER BY wind_speed DESC
LIMIT 1;


/**Häufigkeit der Wetterbedingungen*/
SELECT weather_main, COUNT(*) AS Anzahl
FROM weather
WHERE city = 'Cologne'
GROUP BY weather_main
ORDER BY Anzahl DESC;


/**Detaillierte Beschreibungshäufigkeit*/
SELECT weather_desc, COUNT(*) AS count
FROM weather
WHERE city = 'Cologne'
GROUP BY weather_desc
ORDER BY count DESC;


/**Temperaturtrend über die letzten 7 Tage*/
SELECT timestamp, temp
FROM weather
WHERE city = 'Cologne' AND timestamp >= datetime('now', '-7 days')
ORDER BY timestamp;


/**Tagesminimum und Tagesmaximum*/
SELECT
    date(timestamp) AS Tag,
    min(temp) AS kleinsteTemperatur,
    max(temp) AS größteTemperatur
FROM weather
WHERE city = 'Cologne'
GROUP BY Tag
ORDER BY Tag;


/**3‑Punkte Moving Average*/
SELECT
    timestamp,
    temp,
    AVG(temp) OVER (
        ORDER BY timestamp
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS moving_avg_3
FROM weather
WHERE city = 'Cologne';


/**Tagesstatistik*/
CREATE VIEW daily_weather_stats AS
SELECT
    city,
    date(timestamp) AS Tag,
    avg(temp) AS durchschnittsTemperatur,
    min(temp) AS kleinsteTemperatur,
    max(temp) AS größteTemperatur,
    avg(humidity) AS durchschnittlicheFeuchtigkeit
FROM weather
GROUP BY city, Tag;
