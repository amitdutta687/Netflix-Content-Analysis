# Netflix Content Analysis — SQL Server & Power BI

## Project Overview

An end-to-end data analytics portfolio project analyzing a Netflix titles dataset using **SQL Server (T-SQL)** and **Microsoft Power BI**.

The project follows a practical analytics workflow: data exploration, data-quality assessment, cleaning and validation, SQL analysis, KPI development, and interactive dashboard reporting.

The objective is to transform a raw content dataset into clear, business-oriented insights around content mix, release trends, genres, production countries, IMDb ratings, runtime, and TV-show season structure.

---

## Business Questions

This project explores questions such as:

- What is the overall split between Movies and TV Shows?
- How has the number of titles changed across release years?
- Which genres occur most frequently?
- Which production countries contribute the most titles?
- How do IMDb scores vary across release years and content types?
- What is the average runtime for Movies versus TV Shows?
- How are TV Shows distributed by number of seasons?
- What percentage of TV Shows have only one season?
- Which shows have the highest number of seasons?
- What data-quality issues exist in the dataset?

---

## Tools & Technologies

| Tool | Purpose |
|---|---|
| **SQL Server / T-SQL** | Data exploration, cleaning, validation and analysis |
| **Power BI** | Interactive dashboard and data visualization |
| **Power Query** | Data preparation within Power BI |
| **DAX** | KPI and calculated measures |
| **GitHub** | Version control and portfolio presentation |

---

## Project Workflow

### 1. Data Exploration

The raw dataset was profiled to understand its structure and identify potential data-quality issues.

Areas investigated included:

- Missing values
- Duplicate and repeated records
- Data types
- Content types
- Release-year range
- IMDb scores and vote counts
- Runtime values
- Age certifications
- Genres
- Production countries
- Potential invalid or unexpected values

**SQL file:** `SQL/01_Data_Exploration.sql`

### 2. Data Cleaning & Validation

A dedicated `Titles_Cleaned` table was created from the raw data.

The cleaning process focused on preserving valid information while removing records that could not be reliably used for title-level analysis.

Key decisions included:

- Retaining NULL IMDb scores because NULL represents unknown/unavailable information rather than a score of zero
- Retaining NULL IMDb vote counts because missing votes do not mean zero votes
- Retaining missing descriptions and age certifications
- Investigating repeated titles before deleting records
- Removing records where `title IS NULL`
- Validating the cleaned dataset after the cleaning step

**SQL file:** `SQL/02_Data_Cleaning.sql`

### 3. SQL Data Analysis

The cleaned dataset was analyzed using T-SQL to produce business-oriented metrics and comparisons.

Analysis included:

- Movie and TV Show counts and percentages
- Content release trends
- IMDb score statistics
- IMDb vote analysis
- Top-rated and highly voted titles
- Runtime analysis
- Age-certification distribution
- TV Show season analysis
- Genre frequency
- Production-country analysis
- Final data validation

**SQL file:** `SQL/03_Data_Analysis.sql`

### 4. Power BI Dashboard

The cleaned SQL dataset was connected to Power BI and transformed into a four-page analytical dashboard.

#### Netflix Overview

- Total Titles
- Total Movies
- Total TV Shows
- Titles released by year
- Movies vs. TV Shows distribution

#### Content Analysis

- Top 10 genres
- Top 10 production countries
- Average IMDb score by release year
- Age-certification distribution
- Average runtime by release year
- Average runtime by content type

#### Show Analysis

- Average seasons per show
- Percentage of one-season shows
- Shows by number of seasons
- Longest-running shows

#### Key Insights

A consolidated view of the major findings from the SQL analysis and Power BI dashboard.

---

## Key Results & Insights

### Overall Content Mix

The cleaned dataset contains **5,849 titles**:

- **3,743 Movies**
- **2,106 TV Shows**
- Movies represent approximately **64%** of the dataset.

### TV Show Season Structure

TV Shows average approximately **2.16 seasons**, while **57.98%** of shows have exactly one season.

### Most Common Genres

The most frequently occurring genres include:

1. Drama
2. Comedy
3. Thriller

### Production Countries

The leading production countries include the **United States, India, and the United Kingdom**.

> A title can contain multiple production countries, so country-level counts are not mutually exclusive.

### Longest-Running Show

The longest-running show in the cleaned dataset has **42 seasons**.

### Content Release Period

The dataset contains titles released between **1945 and 2022**.

### Data Quality

The dataset contains **2,618 titles with missing age-certification information**. These values were retained because missing certification does not make the underlying title invalid.

---

## Project Structure

```text
Netflix-Content-Analysis/
│
├── SQL/
│   ├── 01_Data_Exploration.sql
│   ├── 02_Data_Cleaning.sql
│   └── 03_Data_Analysis.sql
│
├── PowerBI/
│   └── Netflix_Content_Analysis.pbix
│
└── README.md
```

---

## Skills Demonstrated

This project demonstrates practical experience with:

- SQL Server and T-SQL
- Data exploration and profiling
- Data-quality assessment
- Data cleaning and validation
- Missing-value analysis
- Duplicate and repeated-record investigation
- Aggregation and analytical queries
- `GROUP BY` and `HAVING`
- Filtering and sorting
- `CASE` expressions
- Subqueries
- Conditional aggregation
- String functions and `STRING_SPLIT`
- Power BI dashboard development
- Basic DAX measures
- Power Query
- KPI reporting
- Translating analytical findings into business insights

---

## Portfolio Relevance

This project is particularly relevant to entry-level and junior roles such as:

- **Data Analyst**
- **Business Analyst**
- **Operations Analyst**
- **Reporting Analyst**
- **Business Operations Analyst**
- **Supply Chain / Operations Analyst**

It demonstrates the ability to take a dataset from **raw data → data-quality assessment → cleaning → SQL analysis → KPI reporting → business insights**.

---

## Future Improvements

Possible extensions include:

- Adding more advanced DAX measures
- Introducing interactive slicers and drill-through analysis
- Expanding trend analysis
- Adding additional business KPIs
- Connecting Power BI directly to a refreshed SQL data source
- Extending the analysis with additional datasets

---

## Author

**Amit Dutta**

**MSc International Business Management | Operations & Business Analytics**

**Core skills:** SQL Server | T-SQL | Power BI | DAX | Power Query | Data Analysis | Data Quality | KPI Reporting
