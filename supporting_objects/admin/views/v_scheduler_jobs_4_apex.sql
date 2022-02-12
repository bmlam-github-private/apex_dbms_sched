CREATE OR REPLACE VIEW v_scheduler_jobs_4_apex
AS
SELECT owner, job_name, job_subname
  , CAST ( next_run_date AS DATE ) AS start_time
  , cast (NULL as DATE) end_time
  , cast (NULL as NUMBER) exec_secs
  , cast (NULL as NUMBER) delayed_secs
  , state exec_status
  , job_action action_to_perform
FROM dba_scheduler_jobs
UNION ALL
SELECT owner, job_name, job_subname
  ,CAST( actual_start_date AS DATE) -- start_time 
  ,CAST ( actual_start_date + run_duration AS DATE ) -- end_time 
  ,extract( second from run_duration ) -- exec_secs
  ,extract( second from (actual_start_date - req_start_date ) ) 
  ,status 
  ,NULL
FROM dba_scheduler_job_run_details
/

comment on TABLE v_scheduler_jobs_4_apex IS 'gather information of past, current or future schedule jobs for display in calendar chart'
/

GRANT SELECT ON v_scheduler_jobs_4_apex TO lam
/