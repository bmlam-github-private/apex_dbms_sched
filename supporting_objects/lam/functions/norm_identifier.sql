CREATE OR REPLACE FUNCTION norm_identifier 
( pi_ident VARCHAR)
RETURN VARCHAR2
AS
	l_return LONG := upper( pi_ident );
BEGIN 
	RETURN 
		CASE 
		WHEN substr( l_return, 1, 1) = '"' AND substr( l_return, -1) = '"'
			AND length( pi_ident ) >= 2 
		THEN substr( l_return, 2, length(l_return) - 2 )
		ELSE l_return
		END;
END;
/