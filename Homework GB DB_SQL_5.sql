USE das_auto;
CREATE TABLE cars
(
 id INT NOT NULL PRIMARY KEY,
    name VARCHAR(45),
    cost INT
);
INSERT cars
VALUES
 (1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
 (5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
SELECT * FROM cars;
CREATE VIEW cars_under_25000 AS
SELECT *
FROM cars
WHERE cost < 25000;
SELECT * FROM cars_under_25000;
CREATE OR REPLACE VIEW cars_under_30000 AS
SELECT *
FROM cars
WHERE cost < 30000;
SELECT * FROM cars_under_30000;
CREATE VIEW skoda_audi_cars AS
SELECT *
FROM cars
WHERE name IN ('Skoda', 'Audi');
SELECT * FROM skoda_audi_cars;

CREATE TABLE train_schedule (
    train_id INTEGER,
    station VARCHAR(20),
    station_time TIME
);

INSERT INTO train_schedule (train_id, station, station_time) VALUES
(110, 'San Francisco', '10:00:00'),
(110, 'Redwood City', '10:54:00'),
(110, 'Palo Alto', '11:02:00'),
(110, 'San Jose', '12:35:00'),
(120, 'San Francisco', '11:00:00'),
(120, 'Palo Alto', '12:49:00'),
(120, 'San Jose', '13:30:00');
SELECT * FROM train_schedule;
ALTER TABLE train_schedule ADD COLUMN time_to_next_station TIME;
CREATE TEMPORARY TABLE temp_train_schedule AS
SELECT
  train_id,
  station,
  station_time,
  LEAD(station_time) OVER (PARTITION BY train_id ORDER BY station_time) AS next_station_time
FROM train_schedule;
SET SQL_SAFE_UPDATES = 0;
UPDATE train_schedule AS t1
JOIN temp_train_schedule AS t2 ON t1.train_id = t2.train_id AND t1.station_time = t2.station_time
SET t1.time_to_next_station = TIMEDIFF(t2.next_station_time, t1.station_time);
DROP TABLE temp_train_schedule;
SELECT * FROM train_schedule;