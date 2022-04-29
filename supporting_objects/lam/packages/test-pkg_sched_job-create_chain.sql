declare
    l_json VARCHAR2(30000) := q'{
   { chain_name: "created_by_pkg_sched_job"
     ,steps: 
        [   { procedure_owner: "DEMO_SERVICE_USR"
            , procedure_pkg: "pkg_demo"
            , procedure_name: "give_heart_beat"
            }
            ,{ procedure_owner: "sys"
            , procedure_pkg: "dbms_session"
            , procedure_name: "reset_package"
            }
            ,{ procedure_owner: "DEMO_SERVICE_USR"
            , procedure_pkg: "pkg_demo"
            , procedure_name: "give_heart_beat"
            }
        ]
     }
     }';
BEGIN
     lam.pkg_sched_job.create_chain( chain_info_json => l_json );
END;
/

set linesize 200 pages 0 
column chain_name format a20
column step_name format a10
column program_owner format a20
column program_name format a30

select chain_name, step_name, program_owner, program_name, step_type
from user_scheduler_chain_steps
WHERE chain_name = 'CREATED_BY_PKG_SCHED_JOB'
;