-- ============================================
-- BOSTON MARATHON 2015-2017: DATA CLEANING
-- ============================================
-- source: Kaggle Boston Marathon results (2015, 2016, 2017)
-- goal: merge 3 yearly tables into one, detect and fix data
--       quality issues, and prepare clean numeric/time columns
--       for analysis.

-- merge 2015-2017 into one table
CREATE TABLE boston_all AS
SELECT *,
    ROW_NUMBER() OVER () AS row_id
FROM (
    SELECT * FROM boston_2015
    UNION ALL
    SELECT * FROM boston_2016
    UNION ALL
    SELECT * FROM boston_2017
) AS combined_years;

-- check total rows, should be around 79k
SELECT COUNT(*) FROM boston_all;


-- ============================================
-- STEP 1: check for weird formats in the time columns
-- ============================================
-- these columns should all follow HH:MM:SS. anything that
-- doesn't match is either missing data or a formatting bug.

SELECT official_time, COUNT(*)
FROM boston_all
WHERE official_time !~ '^\d{1,2}:\d{2}:\d{2}$'
GROUP BY official_time
ORDER BY COUNT(*) DESC;

SELECT pace, COUNT(*)
FROM boston_all
WHERE pace !~ '^\d{1,2}:\d{2}:\d{2}$'
GROUP BY pace
ORDER BY COUNT(*) DESC;

SELECT half, COUNT(*)
FROM boston_all
WHERE half !~ '^\d{1,2}:\d{2}:\d{2}$'
GROUP BY half
ORDER BY COUNT(*) DESC;

SELECT proj_time, COUNT(*)
FROM boston_all
WHERE proj_time !~ '^\d{1,2}:\d{2}:\d{2}$'
GROUP BY proj_time
ORDER BY COUNT(*) DESC;

SELECT k5, COUNT(*)
FROM boston_all
WHERE k5 !~ '^\d{1,2}:\d{2}:\d{2}$'
GROUP BY k5
ORDER BY COUNT(*) DESC;


-- ============================================
-- STEP 2: investigate the k5 (5K checkpoint) gaps
-- ============================================
-- k5 has the most missing values of any checkpoint column,
-- so it's worth understanding whether these are DNFs or just
-- a timing mat issue at that one checkpoint.

SELECT bib, name, year, k5, k10, half, official_time
FROM boston_all
WHERE k5 = '-'
LIMIT 20;

-- breakdown by year
SELECT year, COUNT(*) AS total_k5_missing
FROM boston_all
WHERE k5 = '-'
GROUP BY year;

-- check if it's just k5 missing, or k10/half too
SELECT
    COUNT(*) FILTER (WHERE k10 != '-' AND half != '-') AS only_k5_missing,
    COUNT(*) FILTER (WHERE k10 = '-' AND half = '-') AS all_splits_missing
FROM boston_all
WHERE k5 = '-';

SELECT k5, k10, half, COUNT(*)
FROM boston_all
WHERE k5 = '-'
GROUP BY k5, k10, half
ORDER BY COUNT(*) DESC;


-- ============================================
-- STEP 3: full missing-value overview, all checkpoints, per year
-- ============================================

SELECT year,
    COUNT(*) FILTER (WHERE k5 = '-') AS k5_missing,
    COUNT(*) FILTER (WHERE k10 = '-') AS k10_missing,
    COUNT(*) FILTER (WHERE k15 = '-') AS k15_missing,
    COUNT(*) FILTER (WHERE k20 = '-') AS k20_missing,
    COUNT(*) FILTER (WHERE half = '-') AS half_missing,
    COUNT(*) FILTER (WHERE k25 = '-') AS k25_missing,
    COUNT(*) FILTER (WHERE k30 = '-') AS k30_missing,
    COUNT(*) FILTER (WHERE k35 = '-') AS k35_missing,
    COUNT(*) FILTER (WHERE k40 = '-') AS k40_missing,
    COUNT(*) FILTER (WHERE official_time = '-') AS official_time_missing,
    COUNT(*) AS total_rows
FROM boston_all
GROUP BY year
ORDER BY year;

-- conclusion: missing rates are small (<1%) and official_time is
-- always present, so these are isolated timing-mat gaps, not DNFs.
-- safe to clean.


-- ============================================
-- STEP 4: execute cleaning
-- ============================================

-- swap '-' for NULL everywhere
UPDATE boston_all
SET k5 = NULLIF(k5, '-'),
    k10 = NULLIF(k10, '-'),
    k15 = NULLIF(k15, '-'),
    k20 = NULLIF(k20, '-'),
    half = NULLIF(half, '-'),
    k25 = NULLIF(k25, '-'),
    k30 = NULLIF(k30, '-'),
    k35 = NULLIF(k35, '-'),
    k40 = NULLIF(k40, '-'),
    pace = NULLIF(pace, '-'),
    proj_time = NULLIF(proj_time, '-'),
    official_time = NULLIF(official_time, '-');

-- fix the one row hit by an Excel serial-date export bug
-- (0.124548611 days = 02:59:00, confirmed against neighboring times)
UPDATE boston_all
SET official_time = '02:59:00'
WHERE official_time = '0.124548611';


-- ============================================
-- STEP 5: add typed interval columns so we can do math on times
-- ============================================
-- the original columns are VARCHAR (raw text). we add parallel
-- INTERVAL columns so finish times, splits, etc. can be
-- aggregated and compared directly.

ALTER TABLE boston_all
ADD COLUMN k5_t INTERVAL,
ADD COLUMN k10_t INTERVAL,
ADD COLUMN k15_t INTERVAL,
ADD COLUMN k20_t INTERVAL,
ADD COLUMN half_t INTERVAL,
ADD COLUMN k25_t INTERVAL,
ADD COLUMN k30_t INTERVAL,
ADD COLUMN k35_t INTERVAL,
ADD COLUMN k40_t INTERVAL,
ADD COLUMN official_time_t INTERVAL,
ADD COLUMN pace_t INTERVAL;

-- confirm the columns actually got created
SELECT column_name
FROM information_schema.columns
WHERE table_name = 'boston_all'
AND column_name LIKE '%_t';

-- fill in the new columns
UPDATE boston_all
SET k5_t = k5::INTERVAL,
    k10_t = k10::INTERVAL,
    k15_t = k15::INTERVAL,
    k20_t = k20::INTERVAL,
    half_t = half::INTERVAL,
    k25_t = k25::INTERVAL,
    k30_t = k30::INTERVAL,
    k35_t = k35::INTERVAL,
    k40_t = k40::INTERVAL,
    official_time_t = official_time::INTERVAL,
    pace_t = pace::INTERVAL;


-- ============================================
-- STEP 6: final validation
-- ============================================

-- sanity check on age
SELECT MIN(age), MAX(age) FROM boston_all;

-- sanity check on gender (should only be M/F)
SELECT gender, COUNT(*) FROM boston_all GROUP BY gender;

-- check for duplicate entries (same bib + name + year)
SELECT bib, name, year, COUNT(*)
FROM boston_all
GROUP BY bib, name, year
HAVING COUNT(*) > 1;

-- ============================================
-- CLEANING COMPLETE — data ready for 02_eda_queries.sql
-- ============================================
