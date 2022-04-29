CREATE OR REPLACE PACKAGE pkg_demo AS

PROCEDURE keep_sess_alive 
( time_in_secs NUMBER DEFAULT 3 
);
PROCEDURE give_heart_beat 
( life_time_in_secs NUMBER DEFAULT 9
 ,pause_for_seconds NUMBER DEFAULT 3 
 ,msg     VARCHAR2 DEFAULT 'still here!'
);
PROCEDURE give_heart_beat 
( start_from date DEFAULT NULL 
 ,stop_at     date 
 ,msg     VARCHAR2 DEFAULT 'still here!'
 ,pause_for_seconds NUMBER DEFAULT 3 
);
END;
/

show errors

GRANT EXECUTE ON pkg_demo TO LAM
/
