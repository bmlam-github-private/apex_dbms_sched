CREATE OR REPLACE VIEW v_scheduler_job_chaining AS 
SELECT       
	 'xx' AS chain_name 
	,'xx' AS source_step         
	,'xx' AS exec_status         
	,'xx' AS target_step   
	,'start' AS action_type  -- obviously we can only deal with action start 
FROM dual 
WHERE 1=0
UNION ALL 
SELECT       
     'xx' AS chain_name 
	, NULL  AS source_step         
	, NULL  AS exec_status         
	,'step1' AS target_step   
	,'start' AS action_type 
FROM dual 
UNION ALL 
SELECT       
	 'xx' AS chain_name 
	,'step1' AS source_step         
	,'OK' AS exec_status         
	,'step2' AS target_step   
	,'start' AS action_type 
FROM dual 
UNION ALL 
SELECT       
	 'xx' AS chain_name 
	,'step2' AS source_step         
	,'OK' AS exec_status         
	,'step3' AS target_step   
	,'start' AS action_type 
FROM dual 
UNION ALL 
SELECT       
	 'xx' AS chain_name 
	,'step2' AS source_step         
	,'ERROR' AS exec_status         
	,'step4' AS target_step   
	,'start' AS action_type 
FROM dual 
;
