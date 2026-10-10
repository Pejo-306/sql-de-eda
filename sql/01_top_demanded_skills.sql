-- SQL dialect: DuckDB

/*
Question: What are the most in-demand skills for data engineers?
    - Indentify the top 10 in-demand skills for data engineers
    - Focus on remote job postings
    - Why? Retrieves the top 10 skills with the highest demand in the remote
      job market, providing insights into the most valuable skills for data
      engineers seeking remote work.

Dataset notes:
- Includes job postings from 2023 - Sep 2025

┌───────────────────┬──────────────┐
│    table_name     │ record_count │
│      varchar      │    int64     │
├───────────────────┼──────────────┤
│ Company Dimension │       255627 │
│ Skills Dimension  │          263 │
│ Job Postings Fact │      1975971 │
│ Skills Job Bridge │      8795412 │
└───────────────────┴──────────────┘
┌─────────────────────┬─────────────────────┐
│  earliest_posting   │   latest_posting    │
│      timestamp      │      timestamp      │
├─────────────────────┼─────────────────────┤
│ 2023-01-01 00:00:04 │ 2026-09-30 23:05:21 │
└─────────────────────┴─────────────────────┘
*/

SELECT
    sd.skills,
    COUNT(jpf.job_id) AS demand
FROM
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_work_from_home = TRUE
GROUP BY
    sd.skills
ORDER BY
    demand DESC
LIMIT 10;

/*
┌────────────┬────────┐
│   skills   │ demand │
│  varchar   │ int64  │
├────────────┼────────┤
│ sql        │  32044 │
│ python     │  31490 │
│ aws        │  19474 │
│ azure      │  15670 │
│ spark      │  13651 │
│ airflow    │  10854 │
│ snowflake  │   9639 │
│ databricks │   9056 │
│ java       │   7729 │
│ gcp        │   7325 │
└────────────┴────────┘
  10 rows   2 columns

Key takeways:
- SQL and Python are critical for data engineers
- Cloud platforms are the infrastructure running data pipelines
- Big data tools like Spark continue to be highly valued
- Snowflake and Databricks have risen in popularity
- Java and GCP round out the data engineering toolset
*/

