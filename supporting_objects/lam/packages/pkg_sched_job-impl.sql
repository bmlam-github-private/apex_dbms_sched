CREATE OR REPLACE PACKAGE  BODY  pkg_sched_job AS

PROCEDURE create_job_using_stp 
( job_name VARCHAR2 DEFAULT NULL -- system can generated job name
 ,job_description VARCHAR2 DEFAULT NULL 
 ,proc_owner VARCHAR2
 ,package_name VARCHAR2 DEFAULT NULL 
 ,procedure_name VARCHAR2 
 ,subprogram_id NUMBER DEFAULT 1
 ,start_at DATE DEFAULT SYSDATE 
 ,procedure_args_json VARCHAR2 DEFAULT NULL
)
AS
BEGIN 
NULL;
END create_job_using_stp;

PROCEDURE gen_plsql_call
( owner VARCHAR2
 ,package_name VARCHAR2 DEFAULT NULL 
 ,procedure_name VARCHAR2 
 ,subprogram_id NUMBER DEFAULT 1
   ,call_code OUT VARCHAR2 
) 
AS
BEGIN 
NULL;
END gen_plsql_call;

END;
/

show errors
