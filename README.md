# Exploratory Data Analysis on Job Market Data

![EDA Project Overview](./assets/01_eda_project_overview.png)

As part of my 2026 search for a senior engineering role, I took on [Luke Barousse's SQL for Data Engineering Course](https://lukeb.co/sql-de). My goals are to refresh my SQL skills with some basic queries on relevant job market data.

You can check out [Luke's Free SQL for Data Engineering Course on YouTube](https://www.youtube.com/watch?v=UjhFbq4uU2Y). The data analyzed in this query is for remote data engineering job postings from 2023 - Sep 2026, hailing from [datanerd.tech](https://datanerd.tech).

## Summary

- **Project scope:** Built 3 analytical queries, answering key questions on valuable skills in the data engineer job market
- **SQL complexity:** Used multi-table joins, aggregations, filtering, sorting across fact and dimension tables to find top skills by demand, salary, and overall value
- **Outcomes:** Analyzed the query results for actionable insights on data engineering trends

```md
.
├── README.md                       # You are here
└── sql
    ├── 01_top_demanded_skills.sql  # Demand analysis query
    ├── 02_top_paying_skills.sql    # Salary analysis query
    └── 03_optimal_skills.sql       # Combined demand/salary optimization
```

## Overview

Job market analysts need to answer questions like:
- **Most in-demand**: *Which skills are most in-demand for data engineers?*
- **Highest paid**: *Which skills command the highest salaries?*
- **Best trade-off**: *What is the optimal skill set balancing demand and compensation?*

This project analyzes a data warehouse built using star schema design. The warehouse structure consists of:

![Data Warehouse Schema](./assets/02_data_warehouse.png)

- **Fact table**: `job_postings_fact` - Central table with job posting details (job titles, locations, salaries, etc.)
- **Dimension tables**:
    * `company_dim` - Company information linked to job postings
    * `skills_dim` - Skills catalog with skill names and types
- **Bridge table**: `skills_job_dim` - Resolves the many-to-many relationship between job postings and skills

By querying across these interconnected tables, I extracted insights about skill demand, salary patterns, and optimal skill combinations for data engineering roles.

## Tech Stack

- SQL
- [DuckDB](https://duckdb.org): OLAP SQL engine
- [MotherDuck](https://motherduck.com): Cloud-based data warehouse

## Setup

Refer to [Luke Barousse's free YouTube course](https://www.youtube.com/watch?v=UjhFbq4uU2Y&t=16251s).

## Analysis

Takeways and result sets are located inside files with SQL queries:

1. **[Top 10 Demanded Skills](./sql/01_top_demanded_skills.sql)**: Identifies top 10 most in-demand skills for remote data engineer postings
2. **[Top Paying Skills](./sql/02_top_paying_skills.sql)**: Identifies top 25 highest paying skills for remote data engineer postings
3. **[Optimal Skills](./sql/03_optimal_skills.sql)**: Calculates optimal score of each skill using natural log of demand combined with median salary to identify the current most valuable skills

**NOTE on dataset**: Data used for these queries is for remote data engineering job postings from 2023 - Sep 2026, hailing from [datanerd.tech](https://datanerd.tech).

## Key Insights

- **Core skills**: SQL and Python remain cornersone programming languages in most data engineering job postings
- **Cloud trends**: Cloud providers (AWS and Azure) are becoming embedded into modern data engineering roles, with cloud platforms (Snowflake, Databricks) following closely
- **Premium skills**: Infrastructure (Terraform, Kubernetes, Docker) and Big Data (Apache Spark) are associated with above average salaries

