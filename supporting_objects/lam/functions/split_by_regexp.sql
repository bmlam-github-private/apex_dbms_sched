CREATE OR REPLACE FUNCTION split_by_regexp
( pi_text VARCHAR2
 ,pi_re   VARCHAR2 DEFAULT '[^ ]+'
) RETURN sys.re$name_array
AS
  l_return  sys.re$name_array := sys.re$name_array();
BEGIN
	IF pi_re IS NULL 
	THEN 
		RAISE_APPLICATION_ERROR( -20001, 'regular expression pattern must not be empty!');
	END IF;
	FOR rec IN 
	(
		select regexp_substr( pi_text, pi_re, 1, level) tok, level 
		from dual  
		connect by regexp_substr( pi_text, pi_re, 1, level) is not null
	) LOOP
		l_return.extend();
		l_return( l_return.count) := rec.tok;
	END LOOP;
	RETURN l_return;
END;
/
show errors 
