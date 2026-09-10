-- ============================================
-- Netflix Titles Analysis Project
-- File: 02_Data_Cleaning.sql
-- Purpose: Data quality checks, cleaning, and final validation
-- ============================================

USE NetflixAnalysis;
GO

-- Q1: Find titles with missing title values

select
title
from Titles_Raw
where title is null;

-- Q1b: How many titles are missing?

select
COUNT(*)
from Titles_Raw
where title is null;

-- Q2: Are there any titles where the type (MOVIE/SHOW) is missing?

select
title,
type
from Titles_Raw
where type is null;

-- Q3: Which titles are missing an IMDb score?

select
	title,
	imdb_score
from Titles_Raw
where imdb_score is null;

-- Q4: Which titles are missing IMDb votes?

select
	title,
	imdb_votes
from Titles_Raw
where imdb_votes is null;

-- Q5: Which titles are missing runtime?

select
	title,
	runtime
from Titles_Raw
where runtime is null;

-- Q6: How many rows have a missing value in title OR type OR IMDb score OR IMDb votes OR runtime?

select
COUNT(*) as Missing_value
from Titles_Raw
where title is null or type is null or imdb_score is null or imdb_votes is null or runtime is null;

-- Q7: Which column has the most missing values?

SELECT
    'title' AS Column_Name,
    COUNT(*) AS Missing_Value
FROM Titles_Raw
WHERE title IS NULL

UNION ALL

SELECT
    'type',
    COUNT(*)
FROM Titles_Raw
WHERE type IS NULL

UNION ALL

SELECT
    'imdb_score',
    COUNT(*)
FROM Titles_Raw
WHERE imdb_score IS NULL

UNION ALL

SELECT
    'imdb_votes',
    COUNT(*)
FROM Titles_Raw
WHERE imdb_votes IS NULL

UNION ALL

SELECT
    'runtime',
    COUNT(*)
FROM Titles_Raw
WHERE runtime IS NULL;

-- Q8: Are there duplicate titles in the dataset?

select
    title,
    COUNT(*) as Total_count
from Titles_Raw
group by title
having COUNT(*) >1

-- Q9: Which combinations of title, type, and release year appear more than once?

select
title,
type,
release_year,
COUNT(*) as Total_count
from Titles_Raw
group by title,
type,
release_year
having COUNT(*)> 1;

-- Q10: What different values exist in the type column?

select 
    distinct type
from Titles_Raw

-- Q11: What is the minimum and maximum release year in the dataset?

select
MIN(release_year) as Min_Releaseyr,
MAX(release_year) as Max_releaseyr
from Titles_Raw

-- Q12: Are there any titles with a release year outside the expected range of 1900–2025?

SELECT
    title,
    release_year
FROM Titles_Raw
WHERE release_year < 1900
   OR release_year > 2025;

SELECT
    title,
    release_year
FROM Titles_Raw
WHERE release_year NOT BETWEEN 1900 AND 2025;

-- Q13: Are there any titles where release year is missing?

Select
title,
release_year
from Titles_Raw
WHERE release_year IS NULL;

-- Q14: What data type is release year actually stored as?

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Titles_Raw'
  AND COLUMN_NAME = 'release_year';

-- Q15: What data types are being used for all columns in Titles_Raw?

 select
     column_name,
     Data_type
 from information_schema.COLUMNS
 where TABLE_NAME='titles_raw';

-- Q16: Are there any IMDb score values that are not numeric?

select
    title,
    imdb_score
from Titles_Raw
Where imdb_score is not null 
and TRY_CAST(imdb_score as decimal(10,2)) is Null;

-- Q17: Are there any IMDb votes values that exist but cannot be converted to a number?

select
    title,
    imdb_votes
from Titles_Raw
where imdb_votes is not null 
and TRY_CAST(imdb_votes as decimal(10,2)) is null;

-- Q18: Are there any IMDb scores below 0 or above 10?

Select
    title,
    imdb_score
from Titles_Raw
where TRY_CAST(imdb_score as decimal(10,2))>10 
or 
TRY_CAST(imdb_score as decimal(10,2)) <0;

-- Q19: Are there any titles with a negative number of IMDb votes?

select
title,
imdb_votes
from Titles_Raw
where try_cast(imdb_votes as decimal(10,2))<0;

-- Q20: Are there any runtime values that cannot be converted to a number?

select
    title,
    runtime
from Titles_Raw
where runtime is not null
And
TRY_CAST(runtime as decimal(10,2)) is null;

-- Q21: Are there any leading/trailing spaces in the type values?

SELECT DISTINCT type,
    LEN(type) AS Type_Length
FROM Titles_Raw;

-- Q22: Are there any type values containing extra spaces?

select distinct type,
LEN(type) AS Type_Length,
DATALENGTH(type) as datalength_value
from Titles_Raw

-- Q23: Are there any titles stored as empty strings?

select
title
from Titles_Raw
where title ='';

-- Q24: Check for whitespace-only titles

SELECT
    title
FROM Titles_Raw
WHERE TRIM(title) = '';

-- Q25: Check type for empty/whitespace values

select
type,
TRIM(type)
from Titles_Raw

select
type
from Titles_Raw
where trim(type)='';

-- Q26: Are there any titles with only 1 character?

select
    title,
    len(title) as Title_Length
from Titles_Raw
where LEN(title)=1

-- Q27: Find titles with fewer than 3 characters.

select
    title,
    LEN(title) as Title_length
from Titles_Raw
where LEN(title)<3;

-- Q28: Are there any titles longer than 200 characters?

select
    title,
    LEN(title) as title_lenth
from Titles_Raw
where LEN(title) > 200;

-- Q29: Negative IMDb scores stored as text
--Business question

--Are there any imdb_score values that start with -?

select
    title,
    imdb_score
from Titles_Raw
where imdb_score like '-%'

-- Q30: Check for decimal values in runtime

--Business question

--Are there any runtime values containing a decimal point?

select
    title,
    runtime
from Titles_Raw
where runtime like '%.%'

-- Q31: Check release year for invalid/non-numeric values

--Are there any non-NULL release_year values that cannot be converted to a number?

--Try_cast
--If the column is stored as text but I want SQL to calculate or compare its numeric value, I need to convert it.

select
title,
release_year
from Titles_Raw
where release_year is not null
and
TRY_CAST(release_year as int) is null

-- Q32: Check the valid range of release year

--Business question

--Are there any titles with a release_year before 1900 or after 2025?

select
title,
release_year
from Titles_Raw
where TRY_CAST(release_year As int) < 1900 
or TRY_CAST(release_year As int) > 2025 ;

-- Q33: Check runtime for negative values

select
    title,
    runtime
from Titles_Raw
where TRY_CAST(runtime as int) < 0;

-- Q34: Check for unrealistically long runtimes

--Business Question

--Find titles where runtime is greater than 300 minutes.

select
    title,
    runtime
from Titles_Raw
where TRY_CAST(runtime as int) > 300

-- Q35: Check for runtime = 0

--Business question

--Are there any titles with a runtime of 0?

select
    title,
    runtime
from Titles_Raw
where TRY_CAST(runtime as Int) = 0;

-- Q36: Check for zero IMDb votes

--Are there any titles with exactly 0 IMDb votes?

select
    title,
    imdb_votes
from Titles_Raw
where TRY_CAST(imdb_votes as int) = 0;

-- Q37: Check for extremely high IMDb votes

--Are there any titles with more than 10 million IMDb votes?

select
    title,
    imdb_votes
from Titles_Raw
where TRY_CAST(imdb_votes as int) > 10000000;

-- Q38: Check IMDb score for exactly 0

--Are there any titles with an IMDb score of exactly 0?

select
    title,
    imdb_score
from Titles_Raw
where TRY_CAST(imdb_score as decimal(10,2))= 0;

-- Q39: Check for IMDb scores below 1

--Are there any IMDb scores greater than 0 but less than 1?

select
    title,
    imdb_score
from Titles_Raw
where TRY_CAST(imdb_score AS decimal(10,2)) > 0
and
TRY_CAST(imdb_score AS decimal(10,2)) < 1;

-- Q40: Check scores above 10

--Are there any IMDb scores greater than 10?

select
    title,
    imdb_score
from Titles_Raw
where TRY_CAST(imdb_score as decimal(10,2)) > 10;

-- Q41: Handling missing IMDb scores
-- Decision: Keep NULL values.
-- Reason: NULL means the IMDb score is unknown.
-- Do not replace NULL with 0.

-- Q42: Handling missing IMDb votes
-- Decision: Keep NULL values.
-- Reason: NULL means the number of votes is unknown;
-- replacing it with 0 would imply that the title actually received zero votes.

-- Q43: Handling missing titles
-- Decision: Delete rows where title IS NULL.
-- Reason: Title is a key identifying field and a record without a title
-- cannot be reliably identified or used for title-level analysis.

-- Q44: Handling duplicate-looking records
-- Decision: Investigate before deleting.
-- Reason: Matching title, type, and release_year do not necessarily
-- mean the entire records are identical.

SELECT
    title,
    type,
    release_year,
    COUNT(*) AS Total_Count
FROM Titles_Raw
GROUP BY
    title,
    type,
    release_year
HAVING COUNT(*) > 1;



-- Q45: Investigating repeated/duplicate titles
-- Finding: Several titles appear more than once by name.
-- Investigation: Repeated titles can represent different movies/shows
-- or different release years.
-- Decision: Do not delete based on title alone.

SELECT
    title,
    COUNT(*) AS Total_Count
FROM Titles_Raw
GROUP BY title
HAVING COUNT(*) > 1;


-- Q46: Check type for unexpected values
-- Finding: Only MOVIE and SHOW are present.
-- Decision: No cleaning required.

SELECT DISTINCT
    type
FROM Titles_Raw;


-- Q47: Validate type categories
-- Finding: Only MOVIE and SHOW are present.
-- Decision: No cleaning required.

SELECT DISTINCT
    type
FROM Titles_Raw;

-- Q48: Check type for whitespace problems

select
    title,
    type
from Titles_Raw
where type<> TRIM(type);

-- Q49: Check whitespace in title

select
title,
type
from Titles_Raw
where title<>TRIM(title);

-- Q50: Find titles containing only spaces

select
title
from Titles_Raw
where TRIM(title)='';

-- Q51: Validate age certification categories
-- Finding: Values are valid rating categories; NULL represents missing certification.
-- Decision: No cleaning required.

select distinct
    age_certification
from Titles_Raw ;

-- Q52: Check whitespace in age certification

---- Q52: Check whitespace in age_certification
-- Finding: No leading or trailing spaces found.
-- Decision: No cleaning required.

select
    age_certification
from Titles_Raw
where age_certification<>TRIM(age_certification);

-- Q53: Check age certification for empty strings

select
    title,
    age_certification
from Titles_Raw
where age_certification=''; 

-- Q54: Check missing descriptions
-- Finding: 18 titles have NULL descriptions.
-- Decision: Keep NULL values.
-- Reason: A missing description does not make the title invalid,
-- and NULL accurately represents unavailable information.

select
title,
description
from Titles_Raw
where description is null;

-- Q55: Check description for empty strings

select
    title,
    description
from Titles_Raw
where description='';

-- Q56: Check description for whitespace-only values

select
    title,
    description
from Titles_Raw
where TRIM(description)='';

-- Q58: Check release year for empty strings

select 
    title,
    release_year
from Titles_Raw
where release_year=''

-- Q59: Check release year for whitespace

select 
    title,
    release_year
from Titles_Raw
where release_year<>TRIM(release_year);

-- Q61: Check runtime for empty strings

select
    title,
    runtime
from Titles_Raw
where runtime='';

-- Q62: Check runtime for whitespace

select
    title,
    runtime
from Titles_Raw
where runtime<>TRIM(runtime);

-- Q64: Empty IMDb scores

select
    title,
    imdb_score
from Titles_Raw
where imdb_score='';

-- Q65: Check whitespace in IMDb score

select
    title,
    imdb_score
from Titles_Raw
where imdb_score<>TRIM(imdb_score);

-- Q67: Empty IMDb votes

SELECT
    title,
    imdb_votes
FROM Titles_Raw
where imdb_votes='';

-- Q68: Check whitespace in IMDb votes

SELECT
    title,
    imdb_votes
FROM Titles_Raw
WHERE imdb_votes<>TRIM(imdb_votes);

-- Q69: Check IMDb score for non-numeric values

select
    title,
    imdb_score
from Titles_Raw
where TRY_CAST(imdb_score as decimal(10,2)) is null
and 
imdb_score is not null;

-- Q70: Check IMDb votes for non-numeric values

select
    title,
    imdb_votes
from Titles_Raw
where try_cast(imdb_votes as decimal(10,2)) is null
and
imdb_votes is not null;

-- ============================================
-- ACTUAL CLEANING
-- ============================================

-- Create cleaned table
SELECT *
INTO Titles_Cleaned
FROM Titles_Raw;

-- ============================================
-- VERIFY CLEANED TABLE
-- ============================================

-- Compare row counts before cleaning

SELECT COUNT(*) AS Total_Raw
FROM Titles_Raw;

SELECT COUNT(*) AS Total_Cleaned
FROM Titles_Cleaned;

-- Check records with missing title

SELECT *
FROM Titles_Cleaned
WHERE title IS NULL;

-- ============================================
-- REMOVE MISSING TITLES
-- ============================================

-- Remove records with missing title
-- Reason: title is a key identifying field for the analysis

DELETE FROM Titles_Cleaned
WHERE title IS NULL;

-- Verify that no records with missing title remain

SELECT COUNT(*) AS Missing_Title
FROM Titles_Cleaned
WHERE title IS NULL;

-- ============================================
-- FINAL VALIDATION
-- ============================================

-- Q71: Verify final row count of cleaned table

select
    COUNT(*) as total_cleaned
from Titles_Cleaned ;

-- Q72: Verify no missing titles remain

select
    COUNT(*) as missing_title
from Titles_Cleaned
where title is null;

-- Q73: Final duplicate check

select
    title,
    type,
    release_year,
    COUNT(*) as total_count
from Titles_Cleaned
group by title,
    type,
    release_year
having count(*)>1

-- Q74: Final check for type values

select distinct
    type
from Titles_Cleaned ;

-- Q75: Final check for missing release years

select
    release_year
from Titles_Cleaned
where release_year is null;

SELECT
    COUNT(*) AS Missing_Release_Year
FROM Titles_Cleaned
WHERE release_year IS NULL;

-- Q76: Final check for missing runtime

SELECT
    COUNT(*) AS Missing_Runtime
FROM Titles_Cleaned
WHERE runtime IS NULL;

-- Q77: Final check for negative runtime

select
    COUNT(*) as Negative_runtime
from Titles_Cleaned
where TRY_CAST(runtime as decimal(10,2))<0;

-- Q78: Final check for invalid IMDb scores

    select
        COUNT(*) as Invalid_score
    from Titles_Cleaned
    where try_cast(imdb_score As decimal(10,2))>10 
    or
    try_cast(imdb_score As decimal(10,2))<0;

-- Q79: Final check for negative IMDb votes

select
COUNT(*) as Negative_imdb_votes
from Titles_Cleaned
where TRY_CAST(imdb_votes as decimal(10,2))<0;

-- Q80: Final check for non-numeric IMDb votes

select
    COUNT(*) as Non_num_votes
from Titles_Cleaned
where try_cast(imdb_votes  as decimal(10,2)) is null
and
imdb_votes is not null;

-- Q81: Final check for missing IMDb scores
-- NULL values are retained because missing IMDb scores
-- represent unavailable data, not an invalid score.

select
COUNT(*) as missing_Imdb_scores
from Titles_Cleaned
where imdb_score is null;

-- Q82: Final check for missing IMDb votes
-- NULL values are retained because missing vote counts
-- represent unavailable data, not an invalid value.

select
    COUNT(*) as Missing_imdb_votes
from Titles_Cleaned
where imdb_votes is null;

-- Q83: Final check for empty titles

select
    COUNT(*) as Empty_titles
from Titles_Cleaned
where title='';

-- Q84: Final check for whitespace-only titles

select
    COUNT(*) as white_space_titles
from Titles_Cleaned
where TRIM(title)='';

-- Q85: Final check for leading/trailing spaces in titles

select
COUNT(*) as Titles_With_Spaces
from Titles_Cleaned
where title<>TRIM(title);

-- Q86: Final check for empty descriptions

select
COUNT(*) as Empty_desc
from Titles_Cleaned
where description=''

-- Q87: Final check for whitespace-only descriptions

select
    COUNT(*) as whitespace_desc
from Titles_Cleaned
where trim(description)=''

-- Q88: Final check for leading/trailing spaces in descriptions

select
    COUNT(*) as Descriptions_With_Spaces
from Titles_Cleaned
where description<>TRIM(description); 

-- Q89: Check release year range

SELECT
    MIN(TRY_CAST(release_year AS INT)) AS Earliest_Year,
    MAX(TRY_CAST(release_year AS INT)) AS Latest_Year
FROM Titles_Cleaned;

-- Q89b: Final check for release year range

SELECT
    COUNT(*) AS Invalid_Release_Year
FROM Titles_Cleaned
WHERE TRY_CAST(release_year AS INT) < 1945
   OR TRY_CAST(release_year AS INT) > 2022;

-- Q90: Final check for non-numeric release years

select
COUNT(*) as Non_Num_Release_Years
from Titles_Cleaned
WHERE TRY_CAST(release_year AS INT) IS NULL
  AND release_year IS NOT NULL;

-- Q91: Final check for non-numeric runtime

select
COUNT(*) as Non_num_runtime
from Titles_Cleaned
where TRY_CAST(runtime as decimal(10,2)) is null
and runtime is not null ;

-- Q92: Final check for missing type

select
    COUNT(*) as Missing_type
from Titles_Cleaned
where type is null;

-- Q93: Final check for unexpected type values

select
    COUNT(*) as Unexp_type
from Titles_Cleaned
where type not in ('Movie','Show');

-- Q94: Final check for missing age certification

select
    COUNT(*) as Missing_certification
from Titles_Cleaned
where age_certification is null ;

-- Finding:
-- 2,618 records have missing age certification.
-- Decision: Keep NULL values because missing certification does not make the title record invalid.

-- Q95: Final check for empty age certification

select
    COUNT(*) as empty_certification
from Titles_Cleaned
where age_certification = ''

-- Q96: Final check for whitespace-only age certification

select
COUNT(*) as age_certification_with_only_space
from Titles_Cleaned
where TRIM(age_certification)=''

-- Q97: Final check for leading/trailing spaces in age certification

select
COUNT(*) as Certification_With_Spaces
from Titles_Cleaned 
where age_certification<>TRIM(age_certification);

-- Q98: Check available age certification values

select
    age_certification,
    COUNT(*) as Available_certification
from Titles_Cleaned
    where age_certification is not null
    group by age_certification
    order by COUNT(*) desc;

-- Finding:
-- 11 distinct age certification values were identified.
-- No unexpected values were found.
-- NULL values are retained because missing certification does not make the record invalid.

-- Q99: Final check for missing genres

select
    COUNT(*) as missing_genres
from Titles_Cleaned
where genres is null;

-- Q100: Final check for empty genres

select
    COUNT(*) as empty_genres
from Titles_Cleaned
where genres='';

-- Q101: Final check for whitespace-only genres

select
    COUNT(*) as whitespace_genres_only
from Titles_Cleaned
where TRIM(genres)='';

-- Q102: Final check for leading/trailing spaces in genres

select
    COUNT(*) as Genres_with_space
from Titles_Cleaned
where genres<>TRIM(genres);

-- Q103: Inspect genre values

select distinct
    genres
from Titles_Cleaned

SELECT TOP 20
    genres
FROM Titles_Cleaned
WHERE genres IS NOT NULL;

-- Q104: Check distinct genre combinations

SELECT DISTINCT
    genres
FROM Titles_Cleaned
WHERE genres IS NOT NULL;

-- Q105: Check for empty genre lists

SELECT
    COUNT(*) AS Empty_Genre_Lists
FROM Titles_Cleaned
WHERE genres = '[]';

-- Finding:
-- 58 records contain an empty genre list ('[]').
-- Decision: Keep these records because missing genre information does not make the title invalid.

-- Q106: Check for invalid genre format

select
    COUNT(*) as Invalid_genre
from Titles_Cleaned
where genres is not null
    and (  
         LEFT(genres,1)<>'[' 
         or RIGHT(genres,1)<>']'
         );

-- Q107: Inspect production country values

 select
 production_countries
 from Titles_Cleaned

 select top 20
    production_countries
 from Titles_Cleaned;

  --Inspect distinct production country values

 select distinct
    production_countries
 from Titles_Cleaned

-- Q108: Check empty country lists

 select
    COUNT(*) as Empty_country
 from Titles_Cleaned
 where production_countries = '[]';

 -- Finding:
-- 228 records contain an empty production country list ('[]').
-- Decision: Keep these records because missing country information
-- does not make the title invalid.

-- Q109: Check for empty production country values

select
    COUNT(*) as empty_prod_country
from Titles_Cleaned
where production_countries='';

-- Q110: Check for missing production countries

select
    COUNT(*) as Missing_counrties
from Titles_Cleaned
where production_countries is null;

-- Q111: Check for whitespace-only production countries

select
    COUNT(*) as Space_only_prod_countries
from Titles_Cleaned
where TRIM(production_countries)='';

-- Q112: Check for leading/trailing spaces

select
    COUNT(*) as prod_countries_with_space
from Titles_Cleaned
where TRIM(production_countries)<>production_countries;

-- Q113: Check for invalid production country format

select
    COUNT(*) as Invalid_prod_county
from Titles_Cleaned
where production_countries is not null
    And 
    (LEFT(production_countries,1)<>'['
        or
     RIGHT(production_countries,1)<>']');

-- Q114: Inspect seasons

SELECT DISTINCT
    seasons
FROM Titles_Cleaned;

-- Q115: Check for missing seasons

select
    COUNT(*) as Missing_seasons
from Titles_Cleaned
where seasons is null;

-- Q116: Check missing seasons by title type

select
    type,
    COUNT(*) as missing_seasons
from Titles_Cleaned
where seasons is null
group by type;

-- Q117: Check for shows with missing seasons

SELECT
    COUNT(*) AS Shows_Missing_Seasons
FROM Titles_Cleaned
WHERE type = 'SHOW'
  AND seasons IS NULL;

-- Q118: Check for zero seasons

select
seasons
from Titles_Cleaned

select
    COUNT(*) as Zero_seasons
from Titles_Cleaned
where try_cast(seasons as decimal(10,2))=0;

-- Q119: Check for negative seasons

select
    COUNT(*) as negative_seasons
from Titles_Cleaned
where try_cast(seasons as decimal(10,2))<0;

-- Q120: Check for non-numeric seasons

select
COUNT(*) as Total_non_num_seasons
from Titles_Cleaned
where TRY_CAST(seasons as decimal(10,2)) is null
    and
 seasons is not null;

-- Q121: Inspect IMDb IDs

 select distinct
    imdb_id
 from Titles_Cleaned

-- Q122: Check for missing IMDb IDs

 select
    COUNT(*) as Missing_imdb_ID
 from Titles_Cleaned
 where imdb_id is null;

-- Q123: Check for empty IMDb IDs

select
COUNT(*) as Empty_imdb_id
from Titles_Cleaned
where imdb_id='';

-- Q124: Check for invalid IMDb ID format

select
    COUNT(*) as Invalid_imdb_ID_format
from Titles_Cleaned
where imdb_id is not null
and imdb_id not like 'tt%';

-- Q125: Check for spaces

select
COUNT(*) as imdb_id_with_space
from Titles_Cleaned
where TRIM(imdb_id)<>imdb_id;

-- Q126: Are there any IMDb IDs that contain only spaces (or other whitespace) instead of an actual ID?

select
COUNT(*) as Imdb_id_only_space
from Titles_Cleaned
where trim(imdb_id)='';

-- Q127: Inspect IMDb scores

select distinct
imdb_score
from Titles_Cleaned ;

-- Q128: Check for IMDb scores outside the valid range

select
COUNT(*) as Invalid_imdb_score
from Titles_Cleaned
where TRY_CAST(imdb_score as decimal(10,2))>10 
or TRY_CAST(imdb_score as decimal(10,2))<0;

-- Q130: Check for non-numeric IMDb scores

select
    COUNT(*) as Non_num_imdb_score
from Titles_Cleaned
where imdb_score is not null
AND
TRY_CAST(imdb_score AS decimal(10,2)) IS NULL 

-- Q131: Check for spaces in IMDb scores

select
COUNT(*) as imdb_score_withspace
from Titles_Cleaned
where TRIM(imdb_score)<>imdb_score;

-- Q132: Check for empty IMDb scores

select
COUNT(*) as empty_score
from Titles_Cleaned
where imdb_score='';

-- Q133: Check for whitespace-only IMDb scores

select
COUNT(*) as Spaceonly_imdb_score
from Titles_Cleaned
where TRIM(imdb_score)=''
and imdb_score is not null;

-- Q134: Inspect IMDb votes

SELECT DISTINCT
    imdb_votes
FROM Titles_Cleaned
ORDER BY imdb_votes;

-- Q136: Check for zero IMDb votes

SELECT
    COUNT(*) AS Zero_IMDb_Votes
FROM Titles_Cleaned
WHERE TRY_CAST(imdb_votes AS DECIMAL(10,2)) = 0;

-- Q137: Check for negative IMDb votes

SELECT
    COUNT(*) AS Negative_IMDb_Votes
FROM Titles_Cleaned
WHERE TRY_CAST(imdb_votes AS DECIMAL(10,2)) < 0;

-- Q138: Check for non-numeric IMDb votes

SELECT
    COUNT(*) AS Non_Num_IMDb_Votes
FROM Titles_Cleaned
WHERE imdb_votes IS NOT NULL
  AND TRY_CAST(imdb_votes AS DECIMAL(10,2)) IS NULL;

-- Q139: Check for spaces in IMDb votes

SELECT
    COUNT(*) AS IMDb_Votes_With_Space
FROM Titles_Cleaned
WHERE TRIM(imdb_votes) <> imdb_votes;

-- Q140: Check for empty IMDb votes

SELECT
    COUNT(*) AS Empty_IMDb_Votes
FROM Titles_Cleaned
WHERE imdb_votes = '';

-- Q141: Check for whitespace-only IMDb votes

SELECT
    COUNT(*) AS Space_Only_IMDb_Votes
FROM Titles_Cleaned
WHERE TRIM(imdb_votes) = ''
  AND imdb_votes IS NOT NULL;

-- Q142: Inspect TMDB popularity

SELECT DISTINCT
    tmdb_popularity
FROM Titles_Cleaned
ORDER BY tmdb_popularity;

-- Q143: Check for missing TMDB popularity

SELECT
    COUNT(*) AS Missing_TMDB_Popularity
FROM Titles_Cleaned
WHERE tmdb_popularity IS NULL;

-- Q144: Check for negative TMDB popularity

SELECT
    COUNT(*) AS Negative_TMDB_Popularity
FROM Titles_Cleaned
WHERE TRY_CAST(tmdb_popularity AS DECIMAL(10,4)) < 0;

-- Q145: Check for non-numeric TMDB popularity

SELECT
    COUNT(*) AS Non_Num_TMDB_Popularity
FROM Titles_Cleaned
WHERE tmdb_popularity IS NOT NULL
  AND TRY_CAST(tmdb_popularity AS DECIMAL(10,4)) IS NULL;

-- Q146: Check for spaces in TMDB popularity

SELECT
    COUNT(*) AS TMDB_Popularity_With_Space
FROM Titles_Cleaned
WHERE TRIM(tmdb_popularity) <> tmdb_popularity;

-- Q147: Check for empty TMDB popularity

SELECT
    COUNT(*) AS Empty_TMDB_Popularity
FROM Titles_Cleaned
WHERE tmdb_popularity = '';

-- Q148: Check for whitespace-only TMDB popularity

SELECT
    COUNT(*) AS Space_Only_TMDB_Popularity
FROM Titles_Cleaned
WHERE TRIM(tmdb_popularity) = ''
  AND tmdb_popularity IS NOT NULL;

-- Q149: Inspect TMDB score

SELECT DISTINCT
    tmdb_score
FROM Titles_Cleaned
ORDER BY tmdb_score;

-- Q150: Check for TMDB scores outside the valid range

SELECT
    COUNT(*) AS Invalid_TMDB_Score
FROM Titles_Cleaned
WHERE TRY_CAST(tmdb_score AS DECIMAL(10,2)) > 10
   OR TRY_CAST(tmdb_score AS DECIMAL(10,2)) < 0;

-- Q151: Check for missing TMDB scores

SELECT
    COUNT(*) AS Missing_TMDB_Score
FROM Titles_Cleaned
WHERE tmdb_score IS NULL;

-- Q152: Check for non-numeric TMDB scores

SELECT
    COUNT(*) AS Non_Num_TMDB_Score
FROM Titles_Cleaned
WHERE tmdb_score IS NOT NULL
  AND TRY_CAST(tmdb_score AS DECIMAL(10,2)) IS NULL;

-- Q153: Check for spaces in TMDB scores

SELECT
    COUNT(*) AS TMDB_Score_With_Space
FROM Titles_Cleaned
WHERE TRIM(tmdb_score) <> tmdb_score;

-- Q154: Check for empty TMDB scores

SELECT
    COUNT(*) AS Empty_TMDB_Score
FROM Titles_Cleaned
WHERE tmdb_score = '';

-- Q155: Check for whitespace-only TMDB scores

SELECT
    COUNT(*) AS Space_Only_TMDB_Score
FROM Titles_Cleaned
WHERE TRIM(tmdb_score) = ''
  AND tmdb_score IS NOT NULL;

-- Q156: Summary of both IMDb and TMDB metrics

SELECT
    SUM(CASE WHEN imdb_score IS NULL THEN 1 ELSE 0 END) AS Missing_IMDb_Score,
    SUM(CASE WHEN imdb_votes IS NULL THEN 1 ELSE 0 END) AS Missing_IMDb_Votes,
    SUM(CASE WHEN tmdb_popularity IS NULL THEN 1 ELSE 0 END) AS Missing_TMDB_Popularity,
    SUM(CASE WHEN tmdb_score IS NULL THEN 1 ELSE 0 END) AS Missing_TMDB_Score
FROM Titles_Cleaned;

select
SUM(case when imdb_score is null then 1 else 0 End) as Missing_imdb_score,
SUM(case when imdb_votes is null then 1 else 0 End) as Missing_imdb_Vote,
SUM(case when tmdb_popularity is null then 1 else 0 End) as Missing_Tmdb_popularity,
SUM(case when tmdb_score is null then 1 else 0 End) as Missing_tmdb_score
from Titles_Cleaned;

-- Q157: Check rows missing both IMDb score and IMDb votes

SELECT
    COUNT(*) AS Missing_Both_IMDb
FROM Titles_Cleaned
WHERE imdb_score IS NULL
  AND imdb_votes IS NULL;

-- Q158: Check rows missing both TMDB score and popularity

SELECT
    COUNT(*) AS Score_Missing_Popularity_Available
FROM Titles_Cleaned
WHERE tmdb_score IS NULL
  AND tmdb_popularity IS NOT NULL;

-- Q159: Check type of rows missing both TMDB metrics

SELECT
    type,
    COUNT(*) AS Missing_Both_TMDB
FROM Titles_Cleaned
WHERE tmdb_score IS NULL
  AND tmdb_popularity IS NULL
GROUP BY type;

-- Q159b: Count every TMDB NULL combination

SELECT
    CASE
        WHEN tmdb_score IS NULL AND tmdb_popularity IS NULL
            THEN 'Both NULL'
        WHEN tmdb_score IS NULL AND tmdb_popularity IS NOT NULL
            THEN 'Score NULL only'
        WHEN tmdb_score IS NOT NULL AND tmdb_popularity IS NULL
            THEN 'Popularity NULL only'
        ELSE 'Neither NULL'
    END AS TMDB_Status,
    COUNT(*) AS Total
FROM Titles_Cleaned
GROUP BY
    CASE
        WHEN tmdb_score IS NULL AND tmdb_popularity IS NULL
            THEN 'Both NULL'
        WHEN tmdb_score IS NULL AND tmdb_popularity IS NOT NULL
            THEN 'Score NULL only'
        WHEN tmdb_score IS NOT NULL AND tmdb_popularity IS NULL
            THEN 'Popularity NULL only'
        ELSE 'Neither NULL'
    END;

-- Q160: Check missing both IMDb metrics by type

SELECT
    type,
    COUNT(*) AS Missing_Both_IMDb
FROM Titles_Cleaned
WHERE imdb_score IS NULL
  AND imdb_votes IS NULL
GROUP BY type;

-- Q161: IMDb votes available but IMDb score missing

SELECT
    COUNT(*) AS Votes_Without_Score
FROM Titles_Cleaned
WHERE imdb_score IS NULL
  AND imdb_votes IS NOT NULL;

-- Q162: IMDb score available but IMDb votes missing

SELECT
    COUNT(*) AS Score_Without_Votes
FROM Titles_Cleaned
WHERE imdb_score IS NOT NULL
  AND imdb_votes IS NULL;

-- Q163: How many titles have a release year earlier than 1900 or later than the current year (2026)?

select
COUNT(*) as Total_release_yr
from Titles_Cleaned
where release_year>2026 or release_year<1900;

-- Q164: Count missing release years

SELECT
    COUNT(*) AS Missing_release_year
FROM Titles_Cleaned
WHERE release_year IS NULL;

-- Q165: How many titles have an invalid runtime — either 0 minutes or a negative value?

select
    COUNT(*) as Invalid_runtime
from Titles_Cleaned
where runtime <=0;

-- Q166: Count missing runtimes

select
count(*) as Total_missing_runtime
from titles_Cleaned
where runtime is null;

-- Q167: Count titles with runtime over 300 minutes

select
COUNT(*) as Runtime_over_300
from Titles_Cleaned
where TRY_CAST(runtime as int)>300;

-- Q168: Count non-numeric runtime values

select
COUNT(*) as Non_num_runtime
from Titles_Cleaned
where runtime is not null 
and
TRY_CAST(runtime as int) is null;

-- Q169: Count invalid seasons values

select
COUNT(*) as Invalid_seasons
from Titles_Cleaned
where try_cast(seasons as int)<1;

-- Q171: Missing seasons by type

select
Type,
COUNT(*) as Missing_season_by_type
from Titles_Cleaned
where seasons is null
group by type;

-- Q172: Count SHOWs with missing seasons

SELECT
    COUNT(*) AS Missing_seasons
FROM Titles_Cleaned
WHERE type = 'SHOW'
  AND seasons IS NULL;

-- Q173: Count SHOWs with zero seasons

select
    COUNT(*) as Show_Zero_seasons
from Titles_Cleaned
where type='SHOW'
            and try_cast(seasons as Int)=0; 

-- Q174: How many non-NULL seasons values cannot be converted to a decimal number?

select
    COUNT(*) as NoN_null_Seasons
from Titles_Cleaned
where seasons is not null 
            and
            TRY_CAST(seasons As decimal(10,2)) is null;

--Inspect distinct seasons values

select distinct
seasons
from Titles_Cleaned ;

SELECT DISTINCT seasons
FROM Titles_Cleaned
WHERE seasons IS NOT NULL
ORDER BY seasons;

-- Q175: How many SHOWs have a seasons value that is not a whole number?

SELECT
    COUNT(*) AS Non_Whole_Seasons
FROM Titles_Cleaned
WHERE type = 'SHOW'
  AND TRY_CAST(seasons AS DECIMAL(10,2))
      <> TRY_CAST(seasons AS INT);

-- Q176: Find the maximum number of seasons

select
    MAX(try_cast(seasons as decimal(10,2))) as Maximum_seasons
from Titles_Cleaned
where type='SHOW'

-- Q177: Find minimum seasons among SHOWs

select
    min(try_cast(seasons as decimal(10,2))) as Minimum_seasons
from Titles_Cleaned
where type='SHOW'

-- Q178: Average number of seasons among SHOWs

select
AVG(try_cast(seasons as decimal(10,2))) as AVG_Seasons
from Titles_Cleaned
where type='SHOW';

-- Q179: How many SHOWs have more than 5 seasons?

select
        COUNT(*) as Total_shows_morethan_5Shows
from Titles_Cleaned
where type='SHOW'
            and try_cast(seasons as decimal(10,2))>5

-- Q180: SHOWs with exactly 1 season

select
    COUNT(*) as Shows_with_1Season
from Titles_Cleaned
where type='SHOW'
            and
            try_cast(seasons as decimal(10,2))=1;

-- Q181: SHOWs with exactly 2 seasons

select
COUNT(*) as show_with_2Seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons As decimal(10,2))=2;

-- Q182: SHOWs with 3 seasons

select
    COUNT(*) as Shows_with_3seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=3;

-- Q183: How many SHOWs have exactly 4 seasons?

select
    COUNT(*) as Shows_with_4seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=4;

-- Q184: SHOWs with exactly 5 seasons

select
    COUNT(*) as Shows_with_5seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=5;

-- Q185: SHOWs with 6 seasons

select
    COUNT(*) as Shows_with_6seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=6;

-- Q186: SHOWs with 7 seasons

select
    COUNT(*) as Shows_with_7seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=7;

-- Q187: SHOWs with 8 seasons

select
    COUNT(*) as Shows_with_8seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=8;

-- Q188: How many SHOWs have exactly 9 seasons?

select
    COUNT(*) as Shows_with_9seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=9;

-- Q189: How many SHOWs have exactly 10 seasons?

select
    COUNT(*) as Shows_with_10seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=10;

-- Q190: How many SHOWs have more than 10 seasons?

select
    COUNT(*) as Shows_with_10seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))>10;

-- Q191: Which SHOW(s) have 42 seasons?

select
count(*) as Shows_42Season
from Titles_Cleaned
where type='SHOW' 
            and
            TRY_CAST(seasons as decimal(10,2))=42;

-- Maximum seasons again, but this time identify the title(s)

select
title,
seasons
from Titles_Cleaned
where TRY_CAST(seasons as decimal(10,2))=(
select
MAX(TRY_CAST(seasons as Decimal(10,2))) as Max_seasons
from Titles_Cleaned);

-- Q192: Maximum seasons without knowing the maximum
--Find the title(s) that have the maximum number of seasons among SHOWs, without knowing the maximum value beforehand.

select
title,
TRY_CAST(seasons as decimal(10,2)) as Total_seasons
from Titles_Cleaned
where type='SHOW' 
            and
            TRY_CAST(seasons AS decimal(10,2))=(
            select
            MAX(TRY_CAST(seasons as decimal(10,2))) as Max_Seasons
            from Titles_Cleaned);

select
title,
TRY_CAST(seasons AS decimal(10,0)) as total_seasons
from Titles_Cleaned
where TRY_CAST(seasons AS decimal(10,0))=(select MAX(TRY_CAST(seasons AS decimal(10,0))) as MAx_seasons
                                    from titles_cleaned)

-- Q193: Find the SHOW with the minimum number of seasons
--Which SHOW(s) have the minimum number of seasons?

select
title,
TRY_CAST(seasons as decimal(10,2)) as Seasons
from Titles_Cleaned
where type='SHOW'
            and
            TRY_CAST(seasons as decimal(10,2))=(
            select
            MIN(TRY_CAST(seasons As decimal(10,2))) as Min_Seasons
            from Titles_Cleaned);

SELECT
    title,
    TRY_CAST(seasons AS DECIMAL(10,2)) AS Seasons
FROM Titles_Cleaned
WHERE type = 'SHOW'
  AND TRY_CAST(seasons AS DECIMAL(10,2)) =
  (
      SELECT MIN(TRY_CAST(seasons AS DECIMAL(10,2))) as min_seasons
      FROM Titles_Cleaned
      WHERE type = 'SHOW'
  );

-- Q195: What percentage of all SHOWs have only 1 season?

 SELECT
    COUNT(*) AS Shows_With_1_Season
FROM Titles_Cleaned
WHERE type = 'SHOW'
  AND TRY_CAST(seasons AS DECIMAL(10,2)) = 1;

--SHows with 1 seasons
select
    count(*) as Shows_with_1_seasons
from Titles_Cleaned
where TRY_CAST(seasons as decimal(10,2))=1

--Total shows

select
COUNT(*) as Total__Shows
from Titles_Cleaned
where type='SHOW';

--  --Q195. What percentage of all SHOWs have only 1 season?

select
    cast(
        (select
            count(*) as Shows_with_1_seasons
        from Titles_Cleaned
        where TRY_CAST(seasons as decimal(10,2))=1) * 100.0
        /
        (select
            COUNT(*) as Total__Shows
        from Titles_Cleaned
        where type='SHOW') as decimal(10,2)) as percentage;

-- Q196: Percentage of SHOWs with exactly 2 seasons

Select
    cast(
        (select
            COUNT(*) as Total_shows_with2_seasons
        from Titles_Cleaned
        where type='SHOW'
                    and
        TRY_CAST(seasons as decimal(10,2)) =2) * 100.0
        /
        (select
            COUNT(*) as Total_shows
        from Titles_Cleaned
        where type='SHOW') as decimal(10,2)) as Percentage_2Seasons_Shows

-- Q197: Percentage of SHOWs with exactly 3 seasons

Select
    cast(
        (select
            COUNT(*) as Total_shows_with3_seasons
        from Titles_Cleaned
        where type='SHOW'
                    and
        TRY_CAST(seasons as decimal(10,2)) =3) * 100.0
        /
        (select
            COUNT(*) as Total_shows
        from Titles_Cleaned
        where type='SHOW') as decimal(10,2)) as Percentage_3Seasons_Shows;

-- Q198: Percentage of SHOWs with exactly 4 seasons

Select
    cast(
        (select
            COUNT(*) as Total_shows_with4_seasons
        from Titles_Cleaned
        where type='SHOW'
                    and
        TRY_CAST(seasons as decimal(10,2)) =4) * 100.0
        /
        (select
            COUNT(*) as Total_shows
        from Titles_Cleaned
        where type='SHOW') as decimal(10,2)) as Percentage_4Seasons_Shows;

-- Q199: Percentage of SHOWs with exactly 5 seasons

Select
    cast(
        (select
            COUNT(*) as Total_shows_with5_seasons
        from Titles_Cleaned
        where type='SHOW'
                    and
        TRY_CAST(seasons as decimal(10,2)) =5) * 100.0
        /
        (select
            COUNT(*) as Total_shows
        from Titles_Cleaned
        where type='SHOW') as decimal(10,2)) as Percentage_5Seasons_Shows;

-- Q200: Percentage of SHOWs with more than 5 seasons

Select
    cast(
        (select
            COUNT(*) as Total_shows_morethan5_seasons
        from Titles_Cleaned
        where type='SHOW'
                    and
        TRY_CAST(seasons as decimal(10,2)) >5) * 100.0
        /
        (select
            COUNT(*) as Total_shows
        from Titles_Cleaned
        where type='SHOW') as decimal(10,2)) as Percentage_morethan_5Seasons_Shows;

-- Q201: Check invalid release year

    SELECT MAX(TRY_CAST(release_year AS INT)) as Latest_release_yr
    FROM Titles_Cleaned

    select
    MIN(TRY_CAST(release_year as int)) as earliest_release_yr
    from Titles_Cleaned

select
COUNT(*) as Total_release_yr
from Titles_Cleaned
where TRY_CAST(release_year as int) > 2022 or  TRY_CAST(release_year as int) < 1945;

-- Q202: Check missing release year

select
COUNT(*) as Missing_rel_yr
from Titles_Cleaned
where release_year is null;

-- Q203: Check duplicate IDs

select
id,
count(*) as duplicate_ID
from Titles_Cleaned
group by id
having COUNT(*)>1;

-- Q204: Check missing IDs

select
COUNT(*) as Missing_ID
from Titles_Cleaned
where id is null;
