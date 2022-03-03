DROP TYPE chaining_info_tab
/
CREATE OR REPLACE TYPE chaining_info_rec AS OBJECT (
	  chain_name     VARCHAR2(50) 
	, rule_name     VARCHAR2(50) 
	, source_step    VARCHAR2(50) 
	, exec_status    VARCHAR2(50)
	, target_step    VARCHAR2(50)
	, action_type    VARCHAR2(50)
);
/
show errors 

CREATE OR REPLACE TYPE chaining_info_tab IS TABLE OF chaining_info_rec;
/
show errors 

