-- ============================================
-- BOSTON MARATHON 2015-2017: ADVANCED ANALYSIS
-- ============================================
-- run after 01_data_cleaning.sql
-- deeper-dive analyses: pace per 5K segment ("hitting the
-- wall"), returning runners across years, gender participation
-- trend, and elite performer density by age group.


-- ============================================
-- 1. PACE PER SEGMENT ("HITTING THE WALL")
-- ============================================
-- add the remaining interval columns needed for segment splits
-- (k15/k20/k25/k30 weren't converted in the base cleaning script)

ALTER TABLE boston_all
ADD COLUMN IF NOT EXISTS k15_t INTERVAL,
ADD COLUMN IF NOT EXISTS k20_t INTERVAL,
ADD COLUMN IF NOT EXISTS k25_t INTERVAL,
ADD COLUMN IF NOT EXISTS k30_t INTERVAL;

UPDATE boston_all
SET k15_t = k15::INTERVAL,
    k20_t = k20::INTERVAL,
    k25_t = k25::INTERVAL,
    k30_t = k30::INTERVAL
WHERE k15_t IS NULL;

-- average pace (min/km) for each 5K segment across the race.
-- only includes runners with complete checkpoint data, so
-- segments compare apples to apples.
WITH segments AS (
    SELECT
        bib, name, year,
        EXTRACT(EPOCH FROM k5_t)/60 AS t_0_5,
        EXTRACT(EPOCH FROM (k10_t - k5_t))/60 AS t_5_10,
        EXTRACT(EPOCH FROM (k15_t - k10_t))/60 AS t_10_15,
        EXTRACT(EPOCH FROM (k20_t - k15_t))/60 AS t_15_20,
        EXTRACT(EPOCH FROM (k25_t - k20_t))/60 AS t_20_25,
        EXTRACT(EPOCH FROM (k30_t - k25_t))/60 AS t_25_30,
        EXTRACT(EPOCH FROM (k35_t - k30_t))/60 AS t_30_35,
        EXTRACT(EPOCH FROM (k40_t - k35_t))/60 AS t_35_40,
        EXTRACT(EPOCH FROM (official_time_t - k40_t))/60 AS t_40_finish
    FROM boston_all
    WHERE k5_t IS NOT NULL AND k10_t IS NOT NULL AND k15_t IS NOT NULL
        AND k20_t IS NOT NULL AND k25_t IS NOT NULL AND k30_t IS NOT NULL
        AND k35_t IS NOT NULL AND k40_t IS NOT NULL AND official_time_t IS NOT NULL
)
SELECT
    ROUND(AVG(t_0_5)::numeric / 5, 2) AS pace_0_5km,
    ROUND(AVG(t_5_10)::numeric / 5, 2) AS pace_5_10km,
    ROUND(AVG(t_10_15)::numeric / 5, 2) AS pace_10_15km,
    ROUND(AVG(t_15_20)::numeric / 5, 2) AS pace_15_20km,
    ROUND(AVG(t_20_25)::numeric / 5, 2) AS pace_20_25km,
    ROUND(AVG(t_25_30)::numeric / 5, 2) AS pace_25_30km,
    ROUND(AVG(t_30_35)::numeric / 5, 2) AS pace_30_35km,
    ROUND(AVG(t_35_40)::numeric / 5, 2) AS pace_35_40km,
    ROUND(AVG(t_40_finish)::numeric / 2.195, 2) AS pace_40_finish
FROM segments;

-- result: pace climbs steadily from ~5.1 min/km to a peak of
-- ~6.05 min/km at the 30-35km mark, then eases slightly to the
-- finish — the classic "hitting the wall" pattern.


-- ============================================
-- 2. RETURNING RUNNERS (ACROSS MULTIPLE YEARS)
-- ============================================

-- attempt 1: match by bib + name. bib numbers are reassigned
-- each year though, so this only reliably catches elite
-- runners with low, stable bib numbers.
SELECT bib, name, COUNT(DISTINCT year) AS jumlah_ikut,
    STRING_AGG(year::text, ', ' ORDER BY year) AS tahun_ikut
FROM boston_all
GROUP BY bib, name
HAVING COUNT(DISTINCT year) > 1
ORDER BY jumlah_ikut DESC
LIMIT 20;

-- attempt 2 (better coverage): match by name only. risk of
-- collisions on common names, so cross-check with age below.
SELECT name, COUNT(DISTINCT year) AS jumlah_ikut,
    STRING_AGG(year::text, ', ' ORDER BY year) AS tahun_ikut
FROM boston_all
GROUP BY name
HAVING COUNT(DISTINCT year) > 1
ORDER BY jumlah_ikut DESC
LIMIT 20;

-- validate matches: age should increase by ~1 per year for a
-- genuine repeat runner, not jump around (which would signal
-- a name collision between two different people)
WITH candidate AS (
    SELECT name, COUNT(DISTINCT year) AS jumlah_ikut,
        STRING_AGG(year::text || ':' || age::text, ', ' ORDER BY year) AS detail_tahun_usia
    FROM boston_all
    GROUP BY name
    HAVING COUNT(DISTINCT year) > 1
)
SELECT * FROM candidate
ORDER BY jumlah_ikut DESC
LIMIT 30;

-- total count of returning runners (name-based match)
SELECT COUNT(*) AS total_returning_runner
FROM (
    SELECT name
    FROM boston_all
    GROUP BY name
    HAVING COUNT(DISTINCT year) > 1
) x;

-- did returning runners get faster or slower from their first
-- to their last participation?
WITH returning_runners AS (
    SELECT name
    FROM boston_all
    GROUP BY name
    HAVING COUNT(DISTINCT year) > 1
),
first_last AS (
    SELECT
        b.name,
        MIN(b.year) AS tahun_pertama,
        MAX(b.year) AS tahun_terakhir,
        (ARRAY_AGG(EXTRACT(EPOCH FROM b.official_time_t)/60 ORDER BY b.year ASC))[1] AS waktu_pertama,
        (ARRAY_AGG(EXTRACT(EPOCH FROM b.official_time_t)/60 ORDER BY b.year DESC))[1] AS waktu_terakhir
    FROM boston_all b
    JOIN returning_runners r ON b.name = r.name
    WHERE b.official_time_t IS NOT NULL
    GROUP BY b.name
)
SELECT
    COUNT(*) AS total_returning_runner,
    ROUND(AVG(waktu_terakhir - waktu_pertama)::numeric, 1) AS avg_perubahan_menit,
    COUNT(*) FILTER (WHERE waktu_terakhir < waktu_pertama) AS jumlah_membaik,
    COUNT(*) FILTER (WHERE waktu_terakhir > waktu_pertama) AS jumlah_memburuk
FROM first_last;

-- result: 9,805 returning runners identified. 73.2% were slower
-- in their last participation than their first (avg +11.9 min),
-- only 26.8% improved. note: name-only matching means a small
-- number of these could be name collisions, not true repeats.


-- ============================================
-- 3. GENDER PARTICIPATION TREND BY YEAR
-- ============================================

SELECT year, gender, COUNT(*),
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY year), 1) AS persen
FROM boston_all
GROUP BY year, gender
ORDER BY year, gender;


-- ============================================
-- 4. ELITE DENSITY BY AGE GROUP (% SUB-3-HOUR FINISHERS)
-- ============================================

SELECT
    (age/10)*10 AS kelompok_usia,
    COUNT(*) AS total_runner,
    COUNT(*) FILTER (WHERE official_time_t < INTERVAL '3 hours') AS sub_3jam,
    ROUND(100.0 * COUNT(*) FILTER (WHERE official_time_t < INTERVAL '3 hours') / COUNT(*), 1) AS persen_sub_3jam
FROM boston_all
WHERE age IS NOT NULL AND official_time_t IS NOT NULL
GROUP BY kelompok_usia
ORDER BY kelompok_usia;

-- result: elite density peaks at ages 20-29 (14.3%), then
-- declines steadily with age, near 0% by the 60s.
