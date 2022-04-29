CREATE OR REPLACE PACKAGE BODY pkg_demo AS

PROCEDURE keep_sess_alive 
( time_in_secs NUMBER DEFAULT 3 
) AS
BEGIN 
	dbms_output.put_line ($$plsql_unit||':'||$$plsql_line||' procedure started at ' ||systimestamp );
	dbms_session.sleep( time_in_secs );
	dbms_output.put_line ($$plsql_unit||':'||$$plsql_line||' procedure finished at ' ||systimestamp );
END keep_sess_alive;

PROCEDURE give_heart_beat 
( life_time_in_secs NUMBER DEFAULT 9
 ,pause_for_seconds NUMBER DEFAULT 3 
 ,msg     VARCHAR2 DEFAULT 'still here!'
) AS
	l_secs_count_down NUMBER :=  LEAST( ABS( life_time_in_secs ), 999 ); --override insane input value 
	l_pause_secs pls_integer := LEAST( abs( pause_for_seconds ), l_secs_count_down - 1); --override insane input value
BEGIN
	dbms_output.put_line ($$plsql_unit||':'||$$plsql_line||' procedure started at ' ||systimestamp );
	WHILE l_secs_count_down > 0
	LOOP
		dbms_output.put_line ( to_char( systimestamp)||': '|| msg );
		dbms_session.sleep( l_pause_secs );
		l_secs_count_down := l_secs_count_down - l_pause_secs;
	END LOOP;
	dbms_output.put_line ($$plsql_unit||':'||$$plsql_line||' procedure finished at ' ||systimestamp );
END give_heart_beat;

PROCEDURE give_heart_beat 
( start_from date DEFAULT NULL 
 ,stop_at     date 
 ,msg     VARCHAR2 DEFAULT 'still here!'
 ,pause_for_seconds NUMBER DEFAULT 3 
) AS
	l_pause_secs pls_integer := LEAST( abs( pause_for_seconds ), 1 ); --override insane input value
	l_start_from DATE := CASE WHEN coalesce(start_from, sysdate) > sysdate + 1 THEN sysdate + 1 ELSE start_from END;
	l_stop_at    DATE := CASE WHEN stop_at > sysdate + 3 THEN sysdate + 3 ELSE start_from END;
BEGIN 
	dbms_output.put_line ($$plsql_unit||':'||$$plsql_line||' procedure started at ' ||systimestamp );
	
	WHILE sysdate < L_start_from
	LOOP
		dbms_session.sleep( l_pause_secs );
	END LOOP;
	
	WHILE sysdate < l_stop_at
	LOOP
		dbms_output.put_line ( to_char( systimestamp)||': '|| msg );
		dbms_session.sleep( l_pause_secs );
	END LOOP;

	dbms_output.put_line ($$plsql_unit||':'||$$plsql_line||' procedure finished at ' ||systimestamp );
END give_heart_beat;

END; -- package 
/

show errors
