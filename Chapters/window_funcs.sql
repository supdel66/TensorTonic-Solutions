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

