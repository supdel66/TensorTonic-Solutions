select 
job_posted_date :: DATE, 
job_posted_date :: time,
job_posted_date :: timestamp,
job_posted_date :: timestamptz 
from job_postings_fact limit 1;

select 
year (job_posted_date :: timestamp),
extract(year from job_posted_date)
from job_postings_fact limit 1;

select date_trunc('month', job_posted_date) from job_postings_fact order by random(); 
rounds to first day of the month 

for year, first month of the year and likelyyyy 

select '2026-01-01 00:00:00+00'::timestamptz;

select job_posted_date at time zone 'utc' at time zone 'est', count(*) from job_postings_fact;


union, union all, except , except all, intersect, intersect all  

select unnest([1,2,4])
union all
select unnest ([3,2,4]);


create or replace temp table job2023 as select * from job_postings_fact where year(job_posted_date::timestamp)=2023 limit 100;

select count(*) from job2023;


create or replace temp table job2024 as select * from job_postings_fact where year(job_posted_date::timestamp)=2024 limit 100;

select count(*) from job2024;

select * from job2023 intersect select * from job2024 limit 10;

select 
(select count(*) from job2024 ) as j2024,
(select count(*) from job2023 ) as j2023;


create or replace temp table h1_2023 as select * from job_postings_fact where job_posted_date>'2023-01-01';
select * from h1_2023;

CREATE OR REPLACE TEMP TABLE h2_2023 AS 
SELECT * FROM job_postings_fact 
WHERE job_posted_date >= '2023-07-01' 
  AND job_posted_date <  '2024-01-01';
 select * from h1_2023;

select 
(select count(*) from h1_2023 ) as j2023,
(select count(*) from h2_2023 ) as j2024;

select job_id from h1_2023 intersect 
select job_id from h2_2023;


select * from h1_2023 union all 
select * from h2_2023;

select skills from job_postings_fact as jpf 
inner join skills_job_dim as sjd on jpf.job_id=sjd.job_id 
inner join skills_dim as sd on sd.skill_id = sjd.skill_id
where extract(quarter from job_posted_date)=1
except
select skills from job_postings_fact as jpf 
inner join skills_job_dim as sjd on jpf.job_id=sjd.job_id 
inner join skills_dim as sd on sd.skill_id = sjd.skill_id
where extract(quarter from job_posted_date)=4
;


with jan_companies as (
    select company_id from job_postings_fact where month(job_posted_date::timestamp)=1 
) ,
feb_companies as (
    select company_id from job_postings_fact where month(job_posted_date::timestamp)=2
)
select * from jan_companies intersect select * from feb_companies;



--- STRING FUNCTIONS 

char_length
upper 
lower 
left('sql',2) - sq 
right('sql',2) - ql 
select substring('sqqs',2,2);  qq 

select concat('sd','sd'); or || 
trim ltrim rtrim 
select replace ('sql', 'q', 's');  ssl 

select regex_replace('sql', '[a-z]', )



---UTILITY FUNCTIONS 
nullif(exp1, exp2)  returns null is exp1=exp2 else exp1 

select nullif(12,221);

select median(nullif(salary_year_avg,0));

coalesce returns first non null value 
select coalesce(null,1, 2);

coalesce(salary_year_avg, 2080*salary_hour_avg)
shortcuttttt 