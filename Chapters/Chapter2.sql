--CASE EXPRESSIONS 
select 
job_title_short, salary_year_avg,
case 
when salary_year_avg>40 then 'high'
when salary_year_avg <20 then 'low '
else 'null' 
end as category from data_jobs.job_postings_fact where salary_year_avg is not null 
limit 10;

select job_title,
case 
when job_title_short like '%Data%' then 'lol'
end as category 
 from data_jobs.job_postings_fact 
order by random()
limit 10;

--conditional aggregation 
select job_title_short, 
count(*), 
median ( case when salary_year_avg<100000 then salary_year_avg end ) as med 
,  
median ( case when salary_year_avg>100000 then salary_year_avg end ) as high 
from job_postings_fact where salary_year_avg is not null group by job_title_short;


end is necessary for case
() is for aggregated for individual we dont really do.. 


with  salaries as (
  select 
  salary_year_avg, salary_hour_avg,
  case when salary_year_avg is not null then salary_year_avg
 when salary_hour_avg is not null then salary_hour_avg*2080
  end as standarda
  from job_postings_fact where salary_year_avg is not null or salary_hour_avg is not null 
)
select standarda,
case when standarda>25000 then 'gpood'
else 'bad' end 
from salaries ;


with salaries as (
select job_title_short, 
case 
when salary_year_avg is not null then salary_year_avg
When salary_hour_avg is not null then salary_hour_avg *2080 
end as salary_year 
from job_postings_fact order by random() limit 100
) 
select count(*) from salaries where salary_year is null;


---standardized slary into bucket 
with  salaries as (
  select job_title_short,
  salary_year_avg, salary_hour_avg,
  case when salary_year_avg is not null then salary_year_avg
 when salary_hour_avg is not null then salary_hour_avg*2080
  end as standarda
  from job_postings_fact where salary_year_avg is not null or salary_hour_avg is not null 
)
select job_title_short, standarda,
case 
when standarda<75000 then 'low'
when standarda>150000 then 'high'
else 'medium'
end as salary_bucket from salaries limit 12;




select column_name, data_type from information_schema.columns
where table_catalog='data_jobs' and table_name='job_postings_fact'
;

---specific to duck db sabai ma hudiana 
describe job_postings_fact;

describe
select job_id, company_id from job_postings_fact limit 10;
┌─────────────────────────────┐
│      job_postings_fact      │
│                             │
│ job_id     integer not null │
│ company_id integer          │
└─────────────────────────────┘


SELECT 'Hello' || ' ' || 'World' AS result;
Hello World

select cast('12' as integer);

select cast(job_work_from_home as int) , cast(job_posted_date as date)
from job_postings_fact limit 10;

select job_title|| ' ' ||job_location , cast(job_work_from_home as int) , cast(job_posted_date as date)
from job_postings_fact limit 10;

select '12'::integer;

7 14 12

use data_jobs;
drop database if exists job_mart;
create database if not exists job_mart;


select * from information_schema.schemata;

create schema job_mart.staging; 

use job_mart;
create schema staging; -- no need specifying db name here  

--if schema not specified sidhai main schema ma janxa 
create table staging.prefered_roles (
    role_id int primary key,
    role_name varchar(20)
);

select * from information_schema.tables where table_catalog='job_mart';


insert into staging.prefered_roles values 
(1,'data engineer'),
(2,'never ml ai engineer')
;

describe
select * from staging.prefered_roles;

describe
SELECT
  constraint_name
FROM information_schema.table_constraints
WHERE table_catalog = 'job_mart'
ORDER BY table_name;


alter table staging.prefered_roles add column age int;
update staging.prefered_roles set age=20;

alter table staging.prefered_roles rename column age to stain_on_earth;

describe
select job_id, jpf.company_id,job_title from data_jobs.job_postings_fact as jpf 
left join data_jobs.company_dim as cd on jpf.company_id=cd.company_id limit 4;


create table staging.job_postings_flat as
select job_id, jpf.company_id,job_title from data_jobs.job_postings_fact as jpf 
left join data_jobs.company_dim as cd on jpf.company_id=cd.company_id limit 4;

select * from staging.job_postings_flat;




create temp table job_postings_flat as  --no need staging bcz doesnt go into schema
select job_id, jpf.company_id,job_title from data_jobs.job_postings_fact as jpf 
left join data_jobs.company_dim as cd on jpf.company_id=cd.company_id limit 4;


delete from staging.job_postings_flat where company_id>20000;

truncate removes all rows, keep columns 
truncate table staging.job_postings_flat

