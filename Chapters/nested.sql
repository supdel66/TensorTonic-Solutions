--NESTED DATA TYPES 

 array : [python, sql]
 struct : {
    skill:'python', level:'advanced'
 }

 select {
    skill:'python', level:'advanced'
 }
as skill;

array of structs : 
[{
    skill:'python', level:'advanced'
 }
,{
    skill:'js', level:'medium'
 }
]

map/object/dictionary   
select map(['prog','cloud'],[['py','js'],['gcd','aws']]) ;

json 
select to_json ({
    'skills':['py'],
    'salary':[20]
});



--ARRAY 
select [1,2,3];


with skills as (
        select 'python' as skill union all 
    select 'sql' union all select 'r'),
    skills_array as (
select array_agg(skill order by skill) as sk from skills)
select sk[1] from skills_array;

-- order by by order bcz agg is random no order is defined there


struct

select {skill:'py', type:'prpg'};

with skill_struct as (
select struct_pack(
    skill:='python',
    type:='prog'
) as s )
select s.skill from skill_struct;


with skill_table as(
select 'python' as skills, 'prorgamming' as types union all 
select 'sql','query' union all select 'r','back')

select struct_pack(
    skill:= skills,
    typed:= types
) as sk from skill_table;




--ARRAY OF STRUCTS 

with skill_table as(
select 'python' as skills, 'prorgamming' as types union all 
select 'sql','query' union all select 'r','back'),
skills_array_struct as(
select 
array_agg(
    struct_pack(
    skill:= skills,
    typed:= types 
) order by types) as sk from skill_table)
select *,sk[1] from skills_array_struct
;


--MAP Intro 

with skill_map as (
    select map{'skill':'python', 'type':'programming'} as mm
)
select mm.skill from skill_map;


--JSON 
-- its text based 

with raw_json as(
select 
'[{"skill":"python", "type":"programing"},
{"skill":"q", "type":"programing"}]'::json as skill_json) 
select 
array_agg(
        struct_pack(
            skill:=json_extract_string(e.value,'$.skill'),
            type:=json_extract_string(e.value,'$.type')
            )) 
            from raw_json, json_each(skill_json) as e
;
 
create or replace temp table job_skills_array as 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(sd.skills) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
GROUP BY 
    jpf.job_id, 
    jpf.job_title_short, 
    jpf.salary_year_avg;



--median per skill 

-- with skills as (
--         select 'python' as skill union all 
--     select 'sql' union all select 'r'),
--     skills_array as (
-- select array_agg(skill order by skill) as sk from skills)
-- select unnest(sk) from skills_array;
┌────────────┐
│ unnest(sk) │
│  varchar   │
├────────────┤
│ python     │
│ r          │
│ sql        │
└────────────┘

with flat_skills as (
    select 
        job_id, job_title_short, salary_year_avg, unnest(skills_array) as skill 
        from job_skills_array
)
select skill, median(salary_year_avg) as mediann 
from flat_skills group by skill order by mediann desc;


---array struct exmaple 
create or replace temp table skill_type_struct as 
SELECT
    jpf.job_id,
    jpf.job_title_short,
    jpf.salary_year_avg,
    ARRAY_AGG(
            struct_pack(
                skill:=sd.skills,
                type:=sd.type 
            )

    ) AS skills_array
FROM job_postings_fact AS jpf
LEFT JOIN skills_job_dim AS sjd
    ON jpf.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd
    ON sd.skill_id = sjd.skill_id
    where salary_year_avg is not null and sd.skills is not null 
GROUP BY 
    jpf.job_id, 
    jpf.job_title_short, 
    jpf.salary_year_avg;

with flat as (
select job_id, job_title_short, salary_year_avg, 
unnest(skills_array).skill as skill,unnest(skills_array).type as type from skill_type_struct)
select skill, type, median(salary_year_avg) from flat group by skill, type order by median(salary_year_avg);