---count rows - window functions 

select job_id, count(*) over() from job_postings_fact;
│ job_id  │ count() OVER () │
│  int32  │      int64      │
├─────────┼─────────────────┤
│    4593 │         1615930 │
│    4594 │         1615930 │
│    4595 │         1615930 │
│    4596 │         1615930 │
│    4597 │         1615930 │
│    4598 │         1615930 │
│    4599 │         1615930 │
│    4600 │         1615930 │
│    4601 │         1615930 │
│    4602 │         1615930 │
│    4603 │         1615930 

why windows imp
pipelines need row level data , keep rows intact and just add insights, 

--syntax
select coumn_1 window_function() over(
    partition by 
    order by 
) as window_column_alias 
from table_name 


3 types of windows function 
1. aggregate  avg(), max(), min sum count 
2. row rank - row_number, rank, dense rank, percent rank, ntitle
3. navigation  lag, lead, first_value, last_value, nth_value 


--partition by 
select job_title_short, salary_year_avg, company_id ,avg(salary_year_avg)  s
over( partition by job_title_short,company_id) as avg_by_title 
from job_postings_fact where salary_year_avg is not null;



select job_id, salary_hour_avg, rank() over(
    order by salary_hour_avg desc 
) as rank_sa
from job_postings_fact  
limit 100;



select job_posted_date,job_id, salary_hour_avg, rank() over(
    order by job_posted_date desc 
) as rank_sa
from job_postings_fact  
limit 100;


select job_posted_date,job_id, job_title_short,salary_hour_avg, avg(salary_hour_avg) over(
    partition by job_title_short
    order by salary_hour_avg desc
) as running_avg 
from job_postings_fact  where salary_hour_avg is not null  and job_title_short = 'Data Engineer' order by 
job_title_short,salary_hour_avg desc
limit 100;



select job_id, job_title_short, salary_hour_avg, rank() over(
    partition by job_title_short
    order by salary_hour_avg desc 
) as rank_hour
from job_postings_fact where salary_hour_avg is not null and job_title_short = 'Data Engineer' order by 
job_title_short,salary_hour_avg desc
limit 100;



select job_title_short, job_posted_date,salary_hour_avg, avg(salary_hour_avg) over(
    partition by job_title_short
    order by job_posted_date
    
) as rank_sa
from job_postings_fact  where salary_hour_avg is not null and job_title_short='Data Engineer'
limit 100;



-- rank matra use gare 
Senior Data Scientist     │ 2023-04-12 16:21:42 │           150.0 │     157 │
│ Data Engineer             │ 2023-02-21 16:34:13 │           150.0 │     157 │
│ Senior Data Scientist     │ 2023-03-17 15:03:46 │           145.0 │     163 │
│ Senior Data Scientist     │ 2023-02-20 17:04:34 │           145.0 │     163 │
│ Data Scientist            │ 2023-04-03 18:56:00 │           144.0 │     165 │

jumps 


--dense rank 
no jumpp 
│ Data Scientist            │ 2024-07-31 10:15:58 │           200.0 │       9 │
│ Data Analyst              │ 2023-07-25 20:01:11 │           200.0 │       9 │
│ Data Engineer             │ 2024-11-28 06:01:26 │           195.0 │      10 │
│ Data Scientist            │ 2023-05-09 18:26:23 │           187.5 │      11 │
└───────────────────────────┴─────────────────────┴─────────────────┴─────────┘


select job_title_short, job_posted_date,salary_hour_avg, () over(
    
    order by salary_hour_avg desc

) as rank_sa
from job_postings_fact  where salary_hour_avg is not null
limit 140;





---ROW NUMBER () - PROVIDING A NEW JOB-ID 

select * 
, row_number() over(
    order by job_posted_date
)
from job_postings_fact 
order by job_posted_date
limit 20 ;


--NAVIGATION FUNCTIONS 
lag lead first_value last value, nth_value 

select job_id, job_title_short, job_posted_date, salary_hour_avg, 
lag(salary_hour_avg) over(
    partition by extract('year' from job_posted_date)
) from job_postings_fact
where salary_hour_avg is not null limit 10;


lag satta first value garee 
┌─────────┬───────────────────────┬─────────────────────┬────────────────────┬─────────────────────────────────────────────────────────────────────────┐
│ job_id  │    job_title_short    │   job_posted_date   │  salary_hour_avg   │ first_value(salary_hour_avg) OVER (PARTITION BY main.date_part('year',  │
│         │                       │                     │                    │                            job_posted_date))                            │
│  int32  │        varchar        │      timestamp      │       double       │                                 double                                  │
├─────────┼───────────────────────┼─────────────────────┼────────────────────┼─────────────────────────────────────────────────────────────────────────┤
│ 1077777 │ Senior Data Analyst   │ 2024-06-28 16:16:01 │               32.5 │                                                                    32.5 │
├─────────┼───────────────────────┼─────────────────────┼────────────────────┼─────────────────────────────────────────────────────────────────────────┤
│ 1077822 │ Senior Data Analyst   │ 2024-06-28 16:28:29 │               62.5 │                                                                    32.5 │
├─────────┼───────────────────────┼─────────────────────┼────────────────────┼─────────────────────────────────────────────────────────────────────────┤
│ 1077824 │ Data Engineer         │ 2024-06-28 16:29:31 │               65.0 │                                                                    32.5



with job_avg as (
    select job_id, job_posted_date, job_title_short, salary_hour_avg, 
    extract('year' from job_posted_date) as yearr ,
    avg(salary_hour_avg) over (
        partition by extract('year' from job_posted_date), job_title_short
    ) as avgg 
    from job_postings_fact where salary_hour_avg is not null
)
select job_title_short,yearr, avgg, lag(avgg) over(
    order by job_title_short, yearr asc
) from job_avg
group by job_title_short, yearr,avgg
 limit 10;
 ┌──────────────────┬───────┬────────────────────┬──────────────────────────────────────────────────────┐
│ job_title_short  │ yearr │        avgg        │ lag(avgg) OVER (ORDER BY job_title_short, yearr ASC) │
│     varchar      │ int64 │       double       │                        double                        │
├──────────────────┼───────┼────────────────────┼──────────────────────────────────────────────────────┤
│ Business Analyst │  2023 │  42.82114698223232 │                                                 NULL │
│ Business Analyst │  2024 │  45.15423975040003 │                                    42.82114698223232 │
│ Business Analyst │  2025 │  44.26217821328947 │                                    45.15423975040003 │
│ Cloud Engineer   │  2023 │  45.81568197770552 │                                    44.26217821328947 │
│ Cloud Engineer   │  2024 │  58.24229168891907 │                                    45.81568197770552 │
│ Cloud Engineer   │  2025 │  60.73488103775751 │                                    58.24229168891907 │
│ Data Analyst     │  2023 │  38.16260126875727 │                                    60.73488103775751 │
│ Data Analyst     │  2024 │ 38.170799911055354 │                                    38.16260126875727 │
│ Data Analyst     │  2025 │ 33.595731532592936 │                                   38.170799911055354 │
│ Data Engineer    │  2023 │  57.23445648483083 │                                   33.595731532592936 │
└──────────────────┴───────┴────────────────────┴──────────────────────────────────────────────────────┘ 



