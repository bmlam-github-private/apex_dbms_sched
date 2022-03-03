set scan off
CREATE OR REPLACE FUNCTION chain_visual_html
( pi_chain_owner VARCHAR
 ,pi_chain_name VARCHAR
) RETURN CLOB
AS
	l_table_body VARCHAR2(32000) := 
	q'{
	<tr>
		<td>step1
		</td>
	</tr>
	<tr>
		<td>		</td>
		<td>OK
		</td>
		<td>Step2
		</td>
	</tr>
	<tr>
		<td>		</td>
		<td>		</td>
		<td>		</td>
		<td>OK --&rarr;
		</td>
		<td>Step3
		</td>
	</tr>
	<tr>
		<td>		</td>
		<td>		</td>
		<td>		</td>
		<td>ERROR --&rarr;
		</td>
		<td>Step4
		</td>
	</tr>
	}';
	l_row_data_all VARCHAR2(1000 CHAR);
	lc_row_cell_empty VARCHAR2(10 CHAR) := '<td></td>';
	lc_html_graph_arrow VARCHAR2(10) := '--&rarr;';
	lc_nl VARCHAR2(2) := chr(10);
BEGIN 
	FOR lr IN (
		WITH inf AS (
			SELECT chain_name, source_step, exec_status, action_type, target_step
			FROM TABLE ( extract_chaining_info ( pi_chain_owner=> pi_chain_owner, pi_chain_name=> pi_chain_name ) )
		), hiera AS (
			SELECT level lev, inf.*
			FROM inf
			CONNECT BY source_step = PRIOR target_step
			START WITH source_step IS NULL
		)
		SELECT h.*
			, max( lev ) OVER ( PARTITION BY NULL ) max_level 
		FROM hiera h
	) LOOP
		-- for each step but fhe first, we present
		-- 1. the exec_status
		-- 1. the target_step 
		-- RPAD() appends the pattern as many times as required until the given target length is reached, possibly truncating the pattern
		l_row_data_all := 
			CASE 
			WHEN lr.lev > 1 THEN rpad( lc_row_cell_empty, length(lc_row_cell_empty) * (lr.lev-1) * 2 , lc_row_cell_empty)
			END
			||'<td>'
			|| lr.exec_status||lc_html_graph_arrow
			|| lr.target_step
			||'</td>';
		l_table_body := l_table_body 
			||'<tr>'
			||l_row_data_all
			||'</tr>'
			||lc_nl 
			;
	END LOOP;
	RETURN 
		'<table> ' 
		|| l_table_body
		|| '</table> ' 
		;
END;
/

show errors
