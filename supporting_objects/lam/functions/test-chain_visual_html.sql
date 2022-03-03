col spool_file new_value spool_file 
SELECT  '/tmp/test_chain_visual.html' spool_file
FROM dual
;
PROMPT &spool_file

SET LINESIZE 1000 TRIMSPOOL ON LONG 10000 LONGCHUNKSIZE 10000 PAGESIZE 0 
SET ECHO ON HEAD OFF ECHO OFF FEEDBACK OFF 


spool &spool_file

SELECT chain_visual_html ( pi_chain_owner => 'LAM', pi_chain_name => 'TEST_CHAIN_ONE')
FROM dual
;
SPOOL OFF 
SET HEAD ON FEEDBACK ON TERMOUT ON 