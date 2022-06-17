create table death_stats(name string,death_number int,country string,country_code string,year int) row format delimited fields terminated by ';' stored as textfile location '/user/cloudera/HiveDATA/';

-- TOP 10 des causes de décès les plus faibles
SELECT
    t1.name,
    t1.nb_mort
FROM
(
    SELECT 
        SUM(death_number) AS nb_mort, 
        name 
    FROM 
        death_stats
    GROUP BY 
        name 
) t1
ORDER BY
    t1.nb_mort ASC
LIMIT 10;

-- Total décès
SELECT SUM(death_number) AS mort_total FROM death_stats;

-- Analyse des principaux cause de décès (TOP 5)
SELECT
    t1.name,
    t1.nb_mort
FROM
(
    SELECT 
        SUM(death_number) AS nb_mort, 
        name 
    FROM 
        death_stats
    GROUP BY 
        name 
) t1
ORDER BY
    t1.nb_mort DESC
LIMIT 5;

-- Top 5 des pays avec le plus grand nombre de décès provenant des maladies cardiovasculaires
SELECT
    t1.country,
    t1.name,
    t1.nb_mort
FROM
(
    SELECT 
        country, 
        name, 
        SUM(death_number) AS nb_mort
    FROM 
        death_stats 
    WHERE 
        name = 'Cardiovascular diseases' 
    GROUP BY 
        country,
        name
) t1
ORDER BY 
    t1.nb_mort DESC 
LIMIT 5;

-- Maladie causant le plus de décès par pays
SELECT
    t3.country,
    t3.name,
    t3.max_death_disease
FROM
(
    SELECT
        t2.country,
        t2.name,
        t2.max_death_disease,
        ROW_NUMBER() OVER(
            PARTITION BY t2.country
            ORDER BY t2.max_death_disease DESC
        ) as rn
    FROM
    (
        SELECT
            t1.country,
            t1.name,
            MAX(t1.nb_mort) AS max_death_disease
        FROM
        (
            SELECT
                country,
                name,
                SUM(death_number) AS nb_mort
            FROM 
                death_stats
            GROUP BY
                country, 
                name
        ) t1
        GROUP BY
            t1.country,
            t1.name
    ) t2
)t3
WHERE
    t3.rn = 1
ORDER BY
    t3.max_death_disease DESC
LIMIT 5;

-- Répartion du nombre de décés en fonction du continent
SELECT
    t1.continetnt_det,
    t1.mort
FROM
(
    SELECT
        pays.continetnt_det,
        SUM(mort_det.death_number) AS mort
    FROM 
        death_stats mort_det
    INNER JOIN country_continent pays ON
        (mort_det.country = pays.country)
    GROUP BY
        pays.continetnt_det
) t1
ORDER BY
    t1.mort DESC;

-- Répartion du nombre de décés en fonction du continent en 2019 qui ont pour cause nature et environment
SELECT
    t1.continetnt_det,
    t1.mort_nature,
    t1.year
FROM
(
    SELECT
        pays.continetnt_det,
        SUM(mort_det.death_number) AS mort_nature,
        mort_det.year
    FROM 
        death_stats mort_det
    INNER JOIN country_continent pays ON
        (mort_det.country = pays.country)
    WHERE
        mort_det.name IN ('Fire', 'Environmental heat and cold exposure', 'Exposure to forces of nature') AND mort_det.year = 2019
    GROUP BY
        pays.continetnt_det, mort_det.year
) t1
ORDER BY 
    t1.mort_nature DESC;


-- Répartion du nombre de décés en fonction du continent entre 2000 et 2019 qui ont pour cause des crimes et des guerres
SELECT
    t1.continetnt_det,
    t1.mort_terreur,
    t1.year
FROM
(
    SELECT
        pays.continetnt_det,
        SUM(mort_det.death_number) AS mort_terreur,
        mort_det.year
    FROM 
        death_stats mort_det
    INNER JOIN country_continent pays ON
        (mort_det.country = pays.country)
    WHERE
        mort_det.name IN ('Self-harm', 'Conflict and terrorism', 'Terrorism (deaths)', 'Number of executions (Amnesty International)') AND mort_det.year BETWEEN 2000 AND 2019
    GROUP BY
        pays.continetnt_det, mort_det.year
) t1
ORDER BY 
    t1.year DESC, t1.mort_terreur DESC;

-- TOP 10 des pays avec le moins de décès en 2019
SELECT
    t1.country,
    t1.nb_mort
FROM
(
    SELECT 
        SUM(death_number) AS nb_mort, 
        country 
    FROM 
        death_stats
    WHERE
        year = 2019 AND country != "America"
    GROUP BY 
        country 
) t1
ORDER BY
    t1.nb_mort ASC
LIMIT 10;

-- TOP 10 des pays avec le plus de décès en 2019
SELECT
    t1.country,
    t1.nb_mort
FROM
(
    SELECT 
        SUM(death_number) AS nb_mort, 
        country 
    FROM 
        death_stats
    WHERE
        year = 2019 AND country != "America"
    GROUP BY 
        country 
) t1
ORDER BY
    t1.nb_mort DESC
LIMIT 10;

-- Répartiton du nombre de décés en France

SELECT death_stats.name,sum(death_stats.death_number) FROM `deathanalysis`.`death_stats` where death_stats.country ="France" group by death_stats.name ;

