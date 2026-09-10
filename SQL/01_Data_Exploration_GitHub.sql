-- ============================================
-- Netflix Content Analysis
-- 01 - Data Exploration
-- Database: NetflixAnalysis
-- Tool: SQL Server / T-SQL
-- ============================================

USE NetflixAnalysis;
GO

-- ============================================================
-- Question 1: How many Movies and TV Shows are in the dataset?
-- ============================================================

SELECT
    type,
    COUNT(*) AS Total
FROM Titles_Raw
GROUP BY type;


-- ============================================================
-- Question 2: How many Netflix titles were released in each year?
-- ============================================================

SELECT
    release_year,
    COUNT(*) AS Total_Titles
FROM Titles_Raw
GROUP BY release_year
ORDER BY release_year DESC;


-- ============================================================
-- Question 3: How many Movies are in the dataset?
-- ============================================================

SELECT
    COUNT(*) AS Movies_count
FROM dbo.Titles_Raw
WHERE type = 'MOVIE';


-- ============================================================
-- Question 4: How many TV Shows are in the dataset?
-- ============================================================

select
COUNT(*) as Total_shows
from Titles_Raw
where type='SHOW';


-- ============================================================
-- Question 5: How many titles were released from 2020 onwards?
-- ============================================================

select
	COUNT(*) as Total_titles
from Titles_Raw
where release_year >= 2020;


-- ============================================================
-- Question 6: How many titles were released in each year from 2020 onwards?
-- ============================================================

SELECT
    release_year,
    COUNT(*) AS Total_titles
FROM dbo.Titles_Raw
WHERE release_year >= 2020
GROUP BY release_year
ORDER BY release_year DESC;


-- ============================================================
-- Question 7: How many titles have a missing IMDb score?
-- ============================================================

select
	COUNT(*) as total_null_score
from Titles_Raw
where imdb_score is null;


-- ============================================================
-- Question 8: How many titles have an IMDb score of 8.0 or higher?
-- ============================================================
select
	COUNT(*) as total_titles
from Titles_Raw
where imdb_score >=8.0;


-- ============================================================
-- Question 9: How many Movies have an IMDb score of 8.0 or higher?
-- ============================================================

select
	COUNT(*) as Total_movies
from Titles_Raw
where imdb_score>=8.0 and type='MOVIE';

-- ============================================================
-- Question 10: How many titles are either Movies OR TV Shows?
-- ============================================================

	select
		Type,
		COUNT(*) as Total_count
	from Titles_Raw
	where type='MOVIE'OR
	type = 'SHOW'
	group by type;

SELECT
    COUNT(*) AS Total_count
FROM dbo.Titles_Raw
WHERE type = 'MOVIE'
   OR type = 'SHOW';


-- ============================================================
-- Question 11: How many titles are either Movies or TV Shows using IN?
-- ============================================================

select
	COUNT(*) as Total_titles
from Titles_Raw
where type in ('MOVIE','SHOW');


-- ============================================================
-- Question 12: How many titles are NOT Movies?
-- ============================================================

SELECT
    COUNT(*) AS Total_Titles
FROM dbo.Titles_Raw
WHERE type <> 'MOVIE';


-- ============================================================
-- Question 13: How many titles were released between 2010 and 2020?
-- ============================================================

select
COUNT(*) as Total_titles
from Titles_Raw
WHERE release_year BETWEEN 2010 AND 2020;


-- ============================================================
-- Question 14: How many titles were released in each year between 2010 and 2020?
-- ============================================================

SELECT
    release_year,
    COUNT(*) AS Total_titles
FROM Titles_Raw
WHERE release_year BETWEEN 2010 AND 2020
GROUP BY release_year;


-- ============================================================
-- Question 15: How many titles have the word "Love" somewhere in their title?
-- ============================================================

select
	COUNT(*) as total_titles
from Titles_Raw
where title like '%love%';


-- ============================================================
-- Question 16: How many titles start with the letter "A"?
-- ============================================================

select
	COUNT(*) as Total_Titles_withA
from Titles_Raw
where title like 'A%';


-- ============================================================
-- Question 17: How many Movies have "Love" somewhere in their title?
-- ============================================================

select
	count(*) as Tital_movies
from Titles_Raw
where type='MOVIE' and title like '%love%';


-- ============================================================
-- Question 18: How many titles do NOT contain the word "Love"?
-- ============================================================

select
	COUNT(*) as Total_titles
from Titles_Raw
where title not like '%love%';


-- ============================================================
-- Question 19: How many titles contain either "Love" OR "Life" in the title?
-- ============================================================

select
	COUNT(*) as Total_titles
from Titles_Raw
where title like '%love%' or title like '%life%';


-- ============================================================
-- Question 20: How many titles contain BOTH "Love" AND "Life" in the title?
-- ============================================================

select
	COUNT(*) as Total_titles
from Titles_Raw
where title like '%love%' and title like '%life%';


-- ============================================================
-- Question 21: Classify each title as High Rated or Regular
-- High Rated = IMDb score 8.0 or higher
-- ============================================================

select
	title,
	imdb_score,
	case
	when imdb_score>=8.0 then 'High Rated'
	else 'Regular'
	End as Rating
from Titles_Raw


-- ============================================================
-- Question 22: How many titles are High Rated vs Regular?
-- ============================================================

select
rating,
COUNT(*) as Total_titles
from
(select
	case
	when imdb_score>=8.0 then 'High Rated'
	else 'Regular'
	end as rating
	from Titles_Raw) as Titles_rating
	group by rating;


-- ============================================================
-- Question 23: Classify titles by runtime
-- Less than 60 minutes  -> Short
-- 60-120 minutes        -> Standard
-- More than 120 minutes -> Long
-- ============================================================

select
Title,
	case
	when runtime > 120 then 'Long'
	when runtime<=120 and runtime >=60 then 'Standard'
	else 'short'
	end as Movie_Duration
from Titles_Raw

-- ============================================================
-- Question 24: How many titles fall into each runtime category?
-- ============================================================

select
Movie_Duration,
COUNT(*) as total_titles
from (select
Title,
	case
	when runtime > 120 then 'Long'
	when runtime<=120 and runtime >=60 then 'Standard'
	else 'short'
	end as Movie_Duration
from Titles_Raw) as Duration_data
group by Movie_Duration


-- ============================================================
-- Question 25: Create a category called Content_Type
-- MOVIE -> Film
-- SHOW  -> TV Series
-- ============================================================


select
	Title,
	case
	   WHEN type = 'MOVIE' THEN 'Film'
	WHEN type = 'SHOW' THEN 'TV Series'
    ELSE 'Other'
	end as Category
from Titles_Raw


-- ============================================================
-- Question 26: How many titles have an IMDb score, and how many don't?
-- ============================================================
	
select
	Rating,
	count(*) as Total_score
	from 
	(select
	title,
	case
	when imdb_score Is null then 'Not Rated'
	else 'Rated'
	end as Rating
	from Titles_Raw) as Rating_data
	group by rating;


-- ============================================================
-- Question 27: How many titles are rated vs not rated, but only for Movies?
-- ============================================================

select
	rating_status,
	count(*) as Total_Titles
	from
	(select
	Title,
	case
	when imdb_score Is null then 'Not Rated'
	else 'Rated'
	end as Rating_status
	from Titles_Raw
	where type='MOVIE') as Rating_data
	group by Rating_status;


-- ============================================================
-- Question 28: What is the average IMDb score of all titles?
-- ============================================================

SELECT
    AVG(CAST(imdb_score AS DECIMAL(10,2))) AS Avg_score
FROM Titles_Raw;


-- ============================================================
-- Question 29: What is the average IMDb score for Movies vs Shows?
-- ============================================================

SELECT
    type,
    AVG(CAST(imdb_score AS DECIMAL(10,2))) AS Avg_score
FROM Titles_Raw
   GROUP BY type;


-- ============================================================
-- Question 30: What is the highest IMDb score among all titles?
-- ============================================================

SELECT TOP (1)
    title,
    imdb_score
FROM Titles_Raw
ORDER BY CAST(imdb_score AS DECIMAL(10,2)) DESC;

SELECT
    MAX(CAST(imdb_score AS DECIMAL(10,2))) AS Highest_Score
FROM Titles_Raw;

-- ============================================================
-- Question 31: What is the lowest IMDb score among all titles?
-- ============================================================

SELECT TOP (1)
    title,
    imdb_score
FROM Titles_Raw
where imdb_score is not null
ORDER BY CAST(imdb_score AS DECIMAL(10,2)) asc;

select
MIN(CAST(imdb_score as decimal(10,2))) as min_Score
from Titles_Raw;


-- ============================================================
-- Question 32: What is the total number of IMDb votes across all titles?
-- ============================================================

SELECT
    SUM(CAST(imdb_votes AS DECIMAL(18,2))) AS Total_IMDb_Votes
FROM Titles_Raw;


-- ============================================================
-- Question 33: How many total IMDb votes are there for Movies vs Shows?
-- ============================================================

select
	type,
	SUM(cast(imdb_votes as decimal(18,2))) as Total_Imdb_votes
from Titles_Raw
group by type;


-- ============================================================
-- Question 34: What is the average runtime of all titles?
-- ============================================================

select
avg(cast(runtime as int)) as AVg_runtime
from Titles_Raw;


-- ============================================================
-- Question 35: What is the average runtime for Movies vs Shows?
-- ============================================================

select
type,
AVG(CAST(runtime as int))as Avg_runtime
from Titles_Raw
group by type;


-- ============================================================
-- Question 36: What are the shortest and longest runtimes among all titles?
-- ============================================================

select
	MIN(CAST(runtime as int)) as Shortest_runtime,
	max(CAST(runtime as int)) as longest_runtime
from Titles_Raw;


-- ============================================================
-- Question 37: How many titles were released in each year?
-- ============================================================

select
release_year,
COUNT(*) as Total_titles
from Titles_Raw
group by release_year
order by release_year desc;


-- ============================================================
-- Question 38: Which 10 release years had the highest number of titles?
-- ============================================================

select top(10)
release_year,
COUNT(*) as Total_release
from Titles_Raw
group by release_year
order by Total_release desc;


-- ============================================================
-- Question 39: What are the 10 highest-rated titles based on IMDb score?
-- ============================================================

select top(10)
title,
type,
imdb_score
from Titles_Raw
ORDER BY CAST(imdb_score AS DECIMAL(10,2)) DESC;


-- ============================================================
-- Question 40: Which 10 titles have the highest number of IMDb votes?
-- ============================================================

select top(10)
	title,
	type,
	imdb_votes
from Titles_Raw
order by CAST(imdb_votes as decimal(18,2)) desc;


-- ============================================================
-- Question 41: How many titles are High Rated (IMDb >= 8.0) vs Regular?
-- ============================================================

select
Rating,
COUNT(*) as Total_titles
from(
select
	Title,
case
	when cast(imdb_score as Decimal(18,2))>=8 then 'High Rated' 
	else 'Regular'
	end as Rating
from Titles_Raw) as Rating_data
group by Rating;


-- ============================================================
-- Question 42: How many High Rated titles are Movies and how many are Shows?
-- ============================================================

select
type,
COUNT(*) as Hight_rated
from Titles_Raw
where cast(imdb_score as decimal(18,2))>=8
group by type;


-- ============================================================
-- Question 43: What is the average IMDb score for Movies vs Shows?
-- ============================================================

select
	type,
	AVG(CAST(imdb_score AS decimal(12,2))) as Avg_score
from Titles_Raw
group by type;


-- ============================================================
-- Question 44: What was the average IMDb score for titles released in each year?
-- ============================================================

select
release_year,
AVG(CAST(imdb_score as decimal(12,2))) as Avg_Score
from Titles_Raw
group by release_year;


-- ============================================================
-- Question 45: Which 10 release years had the highest average IMDb score?
-- ============================================================

select top(10)
	release_year,
	AVG(cast(imdb_score AS decimal(12,2))) as Avg_score
from Titles_Raw
group by release_year
order by Avg_score desc;


-- ============================================================
-- Question 46: How many Movies and Shows were released in each year?
-- ============================================================

select
release_year,
type,
COUNT(*) as Total_release_titles
from Titles_Raw
group by release_year,type
order by release_year desc;


-- ============================================================
-- Question 47: For each year from 2015 to 2020, which type had more titles?
-- ============================================================

select
	release_year,
	Movies,
	Shows,
	case
		when Movies > Shows then 'Movie'
		else 'Shows'
	end as More_titles
from
	(select
	release_year,
		SUM(CASE WHEN type = 'MOVIE' THEN 1 ELSE 0 END) AS Movies,
		SUM(CASE WHEN type = 'SHOW' THEN 1 ELSE 0 END) AS Shows
	from Titles_Raw
	where release_year between '2015' and '2020'
	group by release_year) as Data_titles
order by release_year desc;


-- ============================================================
-- Question 48: How many titles are missing an IMDb score?
-- ============================================================

select
COUNT(*) as Title_without_imbd
from Titles_Raw
where imdb_score is null;


-- ============================================================
-- Question 49: How many titles are missing an IMDb score for Movies vs Shows?
-- ============================================================

select
	type,
	COUNT(*) as Missing_imdb
from Titles_Raw
where imdb_score is null
group by type;


-- ============================================================
-- Question 50: For each type, what is the highest IMDb score and average IMDb score?
-- ============================================================

select
	type,
	MAX(CAST(imdb_score as decimal(10,2))) as Highest_IMDB,
	avg(cast(imdb_score as decimal(10,2))) as avg_IMDB
From Titles_Raw
Group by type;




