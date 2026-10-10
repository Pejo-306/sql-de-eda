-- SQL dialect: DuckDB

/*
Question: What are the highest-paying skills for data engineers?
- Calculate the median salary for each skill required in data engineer positions
- Focus on remote positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also
  showing how common those skills are, providing a more complete picture for
  skill development priorities.
- The median is used instead of the average to reduce the impact of outlier salaries.
- Include skills which have at least 100 job postings

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
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM
    job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_work_from_home = TRUE
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_title_short = 'Data Engineer'
GROUP BY
    sd.skills
HAVING
    COUNT(jpb.*) >= 100
ORDER BY
    median_salary DESC
LIMIT 25;

/*
┌────────────┬───────────────┬──────────────┐
│   skills   │ median_salary │ demand_count │
│  varchar   │    double     │    int64     │
├────────────┼───────────────┼──────────────┤
│ terraform  │      165000.0 │          228 │
│ kubernetes │      155000.0 │          183 │
│ airflow    │      150000.0 │          490 │
│ kafka      │      145000.0 │          352 │
│ spark      │      140000.0 │          611 │
│ pandas     │      140000.0 │          116 │
│ go         │      140000.0 │          147 │
│ pyspark    │      139000.0 │          228 │
│ scala      │      137500.0 │          291 │
│ git        │      137500.0 │          251 │
│ looker     │      136000.0 │          101 │
│ aws        │      135500.0 │          970 │
│ java       │      135290.0 │          360 │
│ python     │      135000.0 │         1394 │
│ snowflake  │      135000.0 │          549 │
│ gcp        │      135000.0 │          246 │
│ mongodb    │      135000.0 │          162 │
│ hadoop     │      135000.0 │          222 │
│ docker     │      135000.0 │          175 │
│ r          │      134888.0 │          144 │
│ nosql      │      133458.0 │          226 │
│ sql        │      130000.0 │         1411 │
│ redshift   │      130000.0 │          330 │
│ databricks │      130000.0 │          387 │
│ github     │      127500.0 │          139 │
└────────────┴───────────────┴──────────────┘
  25 rows                         3 columns

Key takeways
- Niche and hard to learn skills demand the highest pay
- Highest paying skills are related to Spark (distributed processing),
  infrastructure, orchestration and streaming data
- Data Engineering is moving away from valuing coding data pipelines to deploying
  and managing data infrastructure, presumably due to the increase in big data
  which requires distributed data processing 
- Older technologies like hadoop, r, mysql are falling off
- Go is surprisingly highly paid and with decent demand. This may be because Go
  is the language used for software engineering in cloud / distributed processing
  environments.
- Python and SQL still remain cornerstone (highly paid, highly demanded) technologies,
  pointing juniors to the skills they need to learn to break in the field.
*/

