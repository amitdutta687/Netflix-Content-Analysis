/* ============================================================
   Netflix Titles Analysis Project
   03_Data_Analysis.sql
   ============================================================ */

USE NetflixAnalysis;
GO

--Q1.How many Movies and Shows are in the dataset?

select
type,
COUNT(*) as Total_count
from Titles_Cleaned
group by type;


--Q2.What percentage of the total titles are Movies and what percentage are Shows?

  select
    TYPE,
    COUNT(*) as total_count_per_type,
    cast(COUNT(*) *100.0 / (select COUNT(*) from Titles_Cleaned) as  decimal(10,2)) as Percentage
  from Titles_Cleaned
  Group by type;


--Q3.How many Movies and Shows were released in each year?


select
    release_year,
    type,
    COUNT(*) as total_count
from Titles_Cleaned
group by type,release_year
order by release_year desc;


--Q4.How many total titles were released in each year, regardless of whether they are Movies or Shows?

select
    release_year,
    COUNT(*) as total_titles
from Titles_Cleaned
group by release_year
order by release_year desc;


-- Q5: Which year had the highest number of titles released?

select
top 1
    release_year,count(*) as HighesT_titles
from Titles_Cleaned
group by release_year
order by COUNT(*) desc;


-- Q6: In 2019, how many Movies and Shows were released?

select
    release_year,
    type,
    COUNT(*) as Total_count
from Titles_Cleaned
where release_year=2019
group by release_year,type


-- Q7: Which year had the highest number of Movies released?

select
top 1
    release_year,
    COUNT(*) as highest_movie_released
from Titles_Cleaned
where type='MOVIE'
group by release_year
order by COUNT(*) desc;


-- Q8: Which year had the highest number of Shows released?


select
top 1
    release_year,
    COUNT(*) as highest_SHOWS_released
from Titles_Cleaned
where type='SHOW'
group by release_year
order by COUNT(*) desc;

-- Q9: How many total titles were released in 2019 and 2020?


select
release_year,
COUNT(*) as Total_tiles
from Titles_Cleaned
where release_year in (2019,2020)
group by release_year;


-- Q10: What was the percentage change in total titles from 2019 to 2020?

select
       cast( (
        (select
        COUNT(*) as titles_2020
        from Titles_Cleaned
        where release_year=2020)
        -
        (select
        COUNT(*) as titles_2020
        from Titles_Cleaned
        where release_year=2019)) * 100.0
        /
        (select
        COUNT(*) as titles_2020
        from Titles_Cleaned
        where release_year=2019)AS decimal(10,2))  as Percentage_change


-- Q11: What is the average IMDb score for Movies and Shows separately?

select
      type,
    cast(AVG(TRY_CAST(imdb_score as decimal(10,2))) as decimal(10,2)) as average_imdb
from Titles_Cleaned
group by type;


-- Q12: What is the average number of IMDb votes for Movies and Shows separately?

select
    type,
    Cast(AVG(try_cast(imdb_votes as decimal(10,2))) AS decimal(10,2)) as Avg_ImdbVotes
from Titles_Cleaned
group by type;


-- Q13: What are the top 10 highest-rated titles based on IMDb score?

select
    top 10
    title,
    type,
    imdb_score
from Titles_Cleaned
order by imdb_score desc;


-- Q14: Which 10 titles have the highest number of IMDb votes?

select top 10
    title,
    type,
    try_cast(imdb_votes as decimal(10,2)) as Imdb_votes
from Titles_Cleaned
order by Imdb_votes desc;


-- Q15: What is the highest IMDb score for Movies and Shows separately?

select
    type,
    max(imdb_score) as Highest_Imdb_score
from Titles_Cleaned
group by type;


-- Q16: What is the lowest IMDb score for Movies and Shows separately?

select
    type,
    min(imdb_score) as Lowest_Imdb_score
from Titles_Cleaned
group by type;


-- Q17: What is the total number of IMDb votes for Movies and Shows separately?

select
    type,
    Sum(try_cast(imdb_votes as decimal(10,2))) as Total_Imdb_votes
from Titles_Cleaned
group by type


-- Q18: What is the average runtime for Movies and Shows separately?

select
    type,
    cast(AVG(TRY_CAST(runtime as decimal(10,2))) as decimal(10,2)) as AVG_runtime
from Titles_Cleaned
group by type;


-- Q19: How many titles are there for each age certification?

SELECT
    age_certification,
    COUNT(*) AS Total_titles
FROM Titles_Cleaned
GROUP BY age_certification
ORDER BY COUNT(*) DESC;


-- Q20: Which age certification has the highest number of titles?


select
    top 1
    age_certification,
    COUNT(*) as Highest_titles
from Titles_Cleaned
group by age_certification
order by Highest_titles desc;


-- Q21: Which age certification (excluding NULL values) has the highest number of titles?

select
top 1
    age_certification,
    COUNT(*) as Highest_titles
from Titles_Cleaned
where age_certification is not null
group by age_certification
order by Highest_titles desc;


-- Q22: How many Movies and Shows are there for each age certification?

select
    type,
    age_certification,
    COUNT(*) as total_titles
from Titles_Cleaned
group by type,age_certification;


-- Q23: Find the most common age certification for Movies, excluding NULL.

select top 1
    age_certification,
    count(*) as total_movies
from Titles_Cleaned
where type='MOVIE' and age_certification is not null
group by age_certification
order by total_movies desc;


-- Q24: Which age certification is most common among Shows, excluding NULL?

select
    top 1
    age_certification,
    COUNT(*) as Total_Shows
from Titles_Cleaned
where age_certification is not null and type='SHOW'
group by age_certification
order by Total_Shows desc;


-- Q25: Which age certification has the highest number of Movies, excluding NULL?

select top 1
    age_certification,
    count(*) as Highest_movies
from Titles_Cleaned
where type='MOVIE' and age_certification is not null
group by age_certification
order by Highest_movies desc;


-- Q26: What percentage of all titles have a missing (NULL) age certification?

SELECT
    TRY_CAST(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM Titles_Cleaned)
        AS DECIMAL(10,2)
    ) AS Percentage_titles
FROM Titles_Cleaned
WHERE age_certification IS NULL;


-- Q27: What percentage of Movies have a missing age certification, and what percentage of Shows have a missing age certification?


select
    type,
    Cast(
     SUM(case
          when age_certification is null then 1
          else 0
          end)*100.0
          /
          COUNT(*) as decimal(10,2)) as Percentage_Titles
from Titles_Cleaned
group by type;


-- Q28: What is the average IMDb score for each age certification?

select
    age_certification,
    avg(TRY_CAST(imdb_score as decimal(10,2)))
from Titles_Cleaned
group by age_certification


-- Q29: What is the average IMDb score for Movies and Shows where the IMDb score is 7.0 or higher?

select
    type,
    AVG(TRY_CAST(imdb_score as decimal(10,2))) as AVG_Imdb_score
from Titles_Cleaned
where TRY_CAST(imdb_score as decimal(10,2))>=7
group by type;


-- Q30: Find the top 10 titles with the highest number of IMDb votes, but only include titles with an IMDb score of 7.0 or higher.

select top 10
    title,
    type,
    imdb_score,
    TRY_CAST(imdb_votes as decimal(10,2)) as Imdb_votes
from Titles_Cleaned
where TRY_CAST(imdb_score as decimal(10,2))>=7
order by Imdb_votes desc;


-- Q31: What is the average runtime for each age certification?

select
    age_certification,
    AVG(try_cast(runtime as decimal(10,2))) as avg_runtime
from Titles_Cleaned
group by age_certification;


-- Q32: Which age certification has the highest average runtime?

SELECT TOP 1
    age_certification,
    AVG(TRY_CAST(runtime AS DECIMAL(10,2))) AS avg_runtime
FROM Titles_Cleaned
GROUP BY age_certification
ORDER BY avg_runtime DESC;


-- Q33: Is the average runtime higher for Movies or Shows?

select top 1
    type,
    (try_cast(AVG(TRY_CAST(runtime as decimal(10,2))) as decimal(10,2))) as avg_runtime
from Titles_Cleaned
group by type
order by avg_runtime desc;


-- Q34: Find the 10 longest Movies based on runtime.

select
        top 10
        title,
        try_cast(runtime as decimal(10,2)) as Run_time
from Titles_Cleaned
where type='MOVIE'
order by Run_time desc;


-- Q35: Find the 10 Shows with the highest number of seasons.

select
    top 10
    title,
    type,
    try_cast(seasons as decimal(10,2)) as Sea_sons
from Titles_Cleaned
where type='SHOW'
order by Sea_sons desc;


-- Q36: Find the show with the highest number of seasons.

select top 1
    title,
    type,
TRY_CAST(seasons as decimal(10,2)) as season
from Titles_Cleaned
where type='SHOW'
order by season desc;


-- Q37: How many Shows have more than 5 seasons?


select
    COUNT(*) as Total_shows
from Titles_Cleaned
where type='SHOW'
        and
TRY_CAST(seasons as decimal(10,2))>5


-- Q38: How many Shows have exactly 1 season?

select
    COUNT(*) as total_shows
from Titles_Cleaned
where type='SHOW' and TRY_CAST(seasons as decimal(10,2))=1;


-- Q39: What percentage of all Shows have exactly 1 season?

select
        Cast(
            COUNT(*)* 100.0
            /
            (select
            COUNT(*)
            from Titles_Cleaned
            where type='SHOW') as decimal(10,2)) as Percentage_Season1_shows
from Titles_Cleaned
where type='SHOW' and TRY_CAST(seasons as decimal(10,2))=1;


-- Q40: What percentage of all Shows have more than 5 seasons?

select
    try_cast
        (COUNT(*) * 100.0
                /
        (select
        COUNT(*)
    from Titles_Cleaned
    where type='SHOW') as decimal(10,2)) as Percentage_SHows_5
from Titles_Cleaned
where type='SHOW' and TRY_CAST(seasons as decimal(10,2))>5


-- Q41: Which genre appears most frequently in the dataset?

SELECT
    TRIM(value) AS genre,
    COUNT(*) AS Total
FROM Titles_Cleaned
CROSS APPLY STRING_SPLIT(
    REPLACE(
        REPLACE(
            REPLACE(genres, '[', ''),
            ']', ''
        ),
        '''', ''
    ),
    ','
)
GROUP BY TRIM(value)
ORDER BY Total DESC;

-- Q42: Which genre appears least frequently in the dataset?

SELECT
    TRIM(value) AS genre,
    COUNT(*) AS Total
FROM Titles_Cleaned
CROSS APPLY STRING_SPLIT(
    REPLACE(
        REPLACE(
            REPLACE(genres, '[', ''),
            ']', ''
        ),
        '''', ''
    ),
    ','
)
GROUP BY TRIM(value)
ORDER BY Total Asc;

-- Q43: Most common production country

SELECT
    TRIM(value) AS country,
    count(*) as Individual_country
FROM Titles_Cleaned
 cross apply string_split(REPLACE(
    Replace
    (REPLACE(production_countries, '[', ''),
    ']',''),
    '''',''),',') AS cleaned_countries
    group by TRIM(value)
    order by Individual_country desc;


-- Q44: How many titles have missing production-country information?

select
COUNT(*) as Total_missing_country
from Titles_Cleaned
where production_countries is null;


-- Q45: Top 10 production countries

select top 10
TRIM(value) as Country,
COUNT(*) as total_prodcution_count
from Titles_Cleaned
cross apply string_split(replace
                            (replace
                            (replace(production_countries,'[','')
                            ,']',''),
                            '''',''),',')
group by TRIM(Value)
order by total_prodcution_count desc;


-- Q46: Country vs. content type

select
TRIM(Value) as Country,
type,
COUNT(*) as total_titles
from Titles_Cleaned
cross apply string_split(REPLACE
                            (REPLACE
                            (replace(production_countries,'[','')
                            ,']',''),
                            '''',''),',')
group by trim(value), type
ORDER BY total_titles DESC;


-- Q47: Average IMDb score by production country
select
TRIM(Value) as country,
cast(AVG(try_cast(imdb_score as decimal(10,2))) as decimal(10,2)) as avg_Score
from Titles_Cleaned
cross apply string_split(
                    REPLACE
                    (replace
                    (replace(production_countries,'[','')
                            ,']',''),
                            '''',''),',')
group by TRIM(value)
order by avg_Score desc;


-- Q48: Which production countries have an average IMDb score of at least 7 and at least 50 titles?

select
TRIM(value) as country,
cast(avg(try_cast(imdb_score as decimal(10,2))) as decimal(10,2)) as avg_Score
from Titles_Cleaned
cross apply string_split(REPLACE
                            (replace
                            (replace
                            (production_countries,'[','')
                            ,']',''),
                            '''',''),',')
group by TRIM(value)
having avg(try_cast(imdb_score as decimal(10,2)))>=7 and COUNT(*)>=50
ORDER BY avg_Score desc;


-- Q49: What are the top 10 titles with an IMDb score of 8.0 or higher and at least 100,000 IMDb votes?

select top 10
    title,
    try_cast(imdb_score as decimal(10,2)) as Imdb_Scr,
    try_cast(imdb_votes as decimal(10,2)) as Imdb_Vots
from Titles_Cleaned
where try_cast(imdb_score as decimal(10,2))>=8.0
and
try_cast(imdb_votes as decimal(10,2))>=100000
order by imdb_votes desc;


-- Q50: How many total records are currently in Titles_Cleaned, and how many are Movies vs Shows?

select
COUNT(*) as Total_titles,
sum(case when TYPE ='MOVIE' then 1 else 0 end) as total_movie,
sum(case when type='SHOW' then 1 else 0 end) as Total_show
from Titles_Cleaned
