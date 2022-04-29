CREATE OR REPLACE FUNCTION my_scheduler_job_name
RETURN VARCHAR2
AS
	l_inst NUMBER := sys_context( 'userenv', 'instance');
	l_sid  NUMBER := sys_context( 'userenv', 'sid');
	l_return user_scheduler_running_jobs.job_name%TYPE;
BEGIN 
	SELECT job_name
	INTO l_return
	FROM user_scheduler_running_jobs
	WHERE running_instance = l_inst
	  AND session_id = l_sid
	;
	RETURN l_return;
EXCEPTION
	WHEN no_data_found THEN
		RETURN NULL;
END;
/

show error 