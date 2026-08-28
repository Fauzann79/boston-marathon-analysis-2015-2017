-- ============================================
-- BOSTON MARATHON 2015-2017: CORE EDA
-- ============================================
-- run after 01_data_cleaning.sql
-- covers the 5 main analyses: finish time distribution,
-- pace by age/gender, country comparison, split behavior,
-- and year-over-year trend.


-- ============================================
-- 1. FINISH TIME DISTRIBUTION
-- ============================================

SELECT
    year,
    ROUND(AVG(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS avg_menit,
    ROUND(MIN(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS min_menit,
    ROUND(MAX(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS max_menit,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM official_time_t))::numeric/60, 1) AS median_menit
FROM boston_all
GROUP BY year
ORDER BY year;

-- sanity check: fastest finishers
SELECT bib, name, year, age, gender, official_time
FROM boston_all
ORDER BY official_time_t ASC
LIMIT 5;

-- sanity check: slowest finishers
SELECT bib, name, year, age, gender, official_time
FROM boston_all
ORDER BY official_time_t DESC
LIMIT 5;


-- ============================================
-- 2. PACE VS AGE & GENDER
-- ============================================

SELECT
    (age/10)*10 AS kelompok_usia,
    gender,
    COUNT(*) AS jumlah_runner,
    ROUND(AVG(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS avg_finish_menit
FROM boston_all
WHERE age IS NOT NULL
GROUP BY kelompok_usia, gender
ORDER BY kelompok_usia, gender;


-- ============================================
-- 3. COUNTRY COMPARISON
-- ============================================

-- countries with the most participants
SELECT
    country,
    COUNT(*) AS jumlah_runner,
    ROUND(AVG(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS avg_finish_menit
FROM boston_all
WHERE country IS NOT NULL
GROUP BY country
ORDER BY jumlah_runner DESC
LIMIT 15;

-- fastest countries, min 30 runners to avoid small-sample bias
SELECT
    country,
    COUNT(*) AS jumlah_runner,
    ROUND(AVG(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS avg_finish_menit
FROM boston_all
WHERE country IS NOT NULL
GROUP BY country
HAVING COUNT(*) >= 30
ORDER BY avg_finish_menit ASC
LIMIT 15;

-- note: elite countries (Kenya, Ethiopia) have very few runners
-- and get filtered out above. worth showing without the filter too:
SELECT
    country,
    COUNT(*) AS jumlah_runner,
    ROUND(AVG(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS avg_finish_menit
FROM boston_all
WHERE country IS NOT NULL
GROUP BY country
ORDER BY avg_finish_menit ASC
LIMIT 15;


-- ============================================
-- 4. POSITIVE / NEGATIVE SPLIT BEHAVIOR
-- ============================================
-- positive split = slower second half, negative split = faster second half

SELECT
    bib, name, year, age, gender,
    half_t AS waktu_paruh_pertama,
    (official_time_t - half_t) AS waktu_paruh_kedua,
    CASE
        WHEN (official_time_t - half_t) > half_t THEN 'positive split'
        WHEN (official_time_t - half_t) < half_t THEN 'negative split'
        ELSE 'even split'
    END AS tipe_split
FROM boston_all
WHERE half_t IS NOT NULL AND official_time_t IS NOT NULL
LIMIT 20;

-- summary: % of runners in each split category
SELECT
    CASE
        WHEN (official_time_t - half_t) > half_t THEN 'positive split'
        WHEN (official_time_t - half_t) < half_t THEN 'negative split'
        ELSE 'even split'
    END AS tipe_split,
    COUNT(*) AS jumlah_runner,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS persen
FROM boston_all
WHERE half_t IS NOT NULL AND official_time_t IS NOT NULL
GROUP BY tipe_split;

-- does split type correlate with finish time?
SELECT
    CASE
        WHEN (official_time_t - half_t) > half_t THEN 'positive split'
        WHEN (official_time_t - half_t) < half_t THEN 'negative split'
        ELSE 'even split'
    END AS tipe_split,
    ROUND(AVG(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS avg_finish_menit
FROM boston_all
WHERE half_t IS NOT NULL AND official_time_t IS NOT NULL
GROUP BY tipe_split;


-- ============================================
-- 5. YEAR-OVER-YEAR TREND
-- ============================================

SELECT
    year,
    COUNT(*) AS jumlah_peserta,
    ROUND(AVG(EXTRACT(EPOCH FROM official_time_t)/60)::numeric, 1) AS avg_finish_menit,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM official_time_t))::numeric/60, 1) AS median_finish_menit
FROM boston_all
GROUP BY year
ORDER BY year;
