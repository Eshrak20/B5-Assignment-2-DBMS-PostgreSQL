-- Active: 1748167588588@@127.0.0.1@5432@conservation_db
-- ! Create Table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    region VARCHAR(255)
)

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(255),
    scientific_name VARCHAR(255),
    discovery_date TIMESTAMP,
    conservation_status TEXT
)

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT,
    species_id INT,
    sighting_time TIMESTAMP,
    location TEXT,
    notes TEXT,
    FOREIGN KEY (ranger_id) REFERENCES rangers (ranger_id),
    FOREIGN KEY (species_id) REFERENCES species (species_id)
)

--! Insert Data
INSERT INTO
    rangers (ranger_id, name, region)
VALUES (
        1,
        'Alice Green',
        'Northern Hills'
    ),
    (2, 'Bob White', 'River Delta'),
    (
        3,
        'Carol King',
        'Mountain Range'
    );

INSERT INTO
    species (
        species_id,
        common_name,
        scientific_name,
        discovery_date,
        conservation_status
    )
VALUES (
        1,
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        2,
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        3,
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        4,
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    );

INSERT INTO
    sightings (
        sighting_id,
        species_id,
        ranger_id,
        location,
        sighting_time,
        notes
    )
VALUES (
        1,
        3,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        1,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        1,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        4,
        2,
        3,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        'Tracks found near stream'
    ),
    (
        5,
        3,
        2,
        'Emerald Pass',
        '2024-05-18 18:30:00',
        'Fresh scat observed'
    ),
    (
        6,
        1,
        2,
        'Moonshade Pass',
        '2024-05-18 18:30:00',
        'Audio recording detected'
    ),
    (
        7,
        2,
        1,
        'Starlight Pass',
        '2024-05-18 18:30:00',
        NULL
    );

TRUNCATE TABLE sightings

--! Problem 1.
INSERT INTO
    rangers (ranger_id, name, region)
VALUES (
        4,
        'Derek Fox',
        'Coastal Plains'
    )

--! Problem 2.
SELECT count(DISTINCT species_id) as unique_species_count
FROM sightings

--! Problem 3.
SELECT * FROM sightings WHERE location ILIKE '%pass%';
--! Problem 4.
SELECT name, count(species_id) as total_sightings
FROM sightings
    INNER JOIN rangers ON rangers.ranger_id = sightings.ranger_id
GROUP BY
    name

--! Problem 5.
SELECT common_name
FROM sightings
    RIGHT JOIN species ON sightings.species_id = species.species_id
WHERE
    sightings.species_id IS NULL;
--! Problem 6.
SELECT common_name, sighting_time, name
FROM
    sightings
    INNER JOIN species ON species.species_id = sightings.species_id
    INNER JOIN rangers ON rangers.ranger_id = sightings.ranger_id
ORDER BY sighting_time DESC
LIMIT 2;

--! Problem 7.
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    EXTRACT(
        YEAR
        FROM discovery_date
    ) < 1800;

--! Problem 8.
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) < 13 THEN 'Morning'
        WHEN EXTRACT(
            HOUR
            FROM sighting_time
        ) >= 13
        AND EXTRACT(
            HOUR
            FROM sighting_time
        ) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

--! Problem 9.
DELETE FROM rangers
WHERE ranger_id IN (
    SELECT rangers.ranger_id
    FROM rangers 
    LEFT JOIN sightings  ON sightings.ranger_id = rangers.ranger_id
    WHERE sightings.sighting_id IS NULL
);
