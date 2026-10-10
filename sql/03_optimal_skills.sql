-- SQL dialect: DuckDB

/*
Question: What are the most optimal skills for data engineers, balancing both
demand and salary?
- Create a ranking column that combines demand count and median salary to identify
  the most valuable skills.
- Focus only on remote Data Engineer positions with specified annual salaries.
- Why? This approach highlights skills that balance market demand and financial
  reward. It weights core skills appropriately, rather than letting rare, outlier
  skills distort the results.

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
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)), 1) AS demand_multiplier,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*))/1_000_000), 2) AS optimal_score 
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
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
┌────────────┬───────────────┬──────────────┬───────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ demand_multiplier │ optimal_score │
│  varchar   │    double     │    int64     │      double       │    double     │
├────────────┼───────────────┼──────────────┼───────────────────┼───────────────┤
│ python     │      135000.0 │         1394 │               7.2 │          0.98 │
│ sql        │      130000.0 │         1411 │               7.3 │          0.94 │
│ airflow    │      150000.0 │          490 │               6.2 │          0.93 │
│ aws        │      135500.0 │          970 │               6.9 │          0.93 │
│ spark      │      140000.0 │          611 │               6.4 │           0.9 │
│ terraform  │      165000.0 │          228 │               5.4 │           0.9 │
│ snowflake  │      135000.0 │          549 │               6.3 │          0.85 │
│ kafka      │      145000.0 │          352 │               5.9 │          0.85 │
│ kubernetes │      155000.0 │          183 │               5.2 │          0.81 │
│ azure      │      125000.0 │          609 │               6.4 │           0.8 │
│ java       │      135290.0 │          360 │               5.9 │           0.8 │
│ scala      │      137500.0 │          291 │               5.7 │          0.78 │
│ databricks │      130000.0 │          387 │               6.0 │          0.77 │
│ git        │      137500.0 │          251 │               5.5 │          0.76 │
│ pyspark    │      139000.0 │          228 │               5.4 │          0.75 │
│ redshift   │      130000.0 │          330 │               5.8 │          0.75 │
│ gcp        │      135000.0 │          246 │               5.5 │          0.74 │
│ hadoop     │      135000.0 │          222 │               5.4 │          0.73 │
│ nosql      │      133458.0 │          226 │               5.4 │          0.72 │
│ docker     │      135000.0 │          175 │               5.2 │           0.7 │
│ go         │      140000.0 │          147 │               5.0 │           0.7 │
│ mongodb    │      135000.0 │          162 │               5.1 │          0.69 │
│ r          │      134888.0 │          144 │               5.0 │          0.67 │
│ pandas     │      140000.0 │          116 │               4.8 │          0.67 │
│ sql server │      121920.0 │          199 │               5.3 │          0.65 │
└────────────┴───────────────┴──────────────┴───────────────────┴───────────────┘
  25 rows                                                             5 columns

Key takeaways:
- Python and SQL are both in high demand and have high salaries, they are no-brainers.
- Cloud providers (AWS, Azure, GCP), cloud platforms (Databricks, Snowflake), and
  distributed data processing tools (Spark) are great supplements to your arsenal.
  There is both demand and a high median salary for these big data and infrastructure
  tools.
- There's still great demand and median salaries for Java/Scala-based data pipelines.
  If you have previous experience with Java/Scala, it's worth searching for those jobs.
  Newcomers should pivot to Python/SQL data pipelines.
- Nicher skills like go, r, nosql databases have high median salaries,
  although it might be harder to find job postings for them.
- Interestingly, dbt is missing from this list, even though it's gained quite some
  popularity recently.
*/

