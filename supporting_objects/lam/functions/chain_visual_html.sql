set scan off
CREATE OR REPLACE FUNCTION chain_visual_html
( pi_chain_owner VARCHAR
 ,pi_chain_name VARCHAR
) RETURN CLOB
AS
	lc_table_beg VARCHAR2(10 CHAR) := '<table>';
	lc_table_end VARCHAR2(10 CHAR) := '</table>';

	lc_td_beg VARCHAR2(10 CHAR) := '<td>';
	lc_td_end VARCHAR2(10 CHAR) := '</td>';
	lc_td_empty VARCHAR2(10 CHAR) := '<td></td>';

	lc_tr_beg VARCHAR2(10 CHAR) := '<tr>';
	lc_tr_end VARCHAR2(10 CHAR) := '</tr>';

	lc_html_graph_arrow VARCHAR2(10) := '--&rarr;';
	lc_nl VARCHAR2(2) := chr(10);
	lc_html_style VARCHAR2(1000) := Q'{<style>
table, th, td {
  border: 1px solid black;
  border-collapse: collapse;
}
</style>}';

	l_padder_cnt PLS_INTEGER; 
	l_table_body VARCHAR2(32000) 	;
	l_row_data_all VARCHAR2(1000 CHAR);
	l_step_presenting_cells VARCHAR2(1000);

BEGIN 
	FOR lr IN (
		WITH inf AS (
			SELECT chain_name
			, rule_name
			, upper(source_step) source_step
			, upper(exec_status) exec_status
			, upper(action_type) action_type
			, upper(target_step) target_step
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
		l_step_presenting_cells := 
			-- condition 
			CASE 
				WHEN lr.exec_status = 'TRUE' AND lr.lev = 1 THEN lc_td_empty 
				ELSE lc_td_beg||lower( lr.exec_status)||lc_td_end
			END
			|| -- action 
			CASE 
				WHEN lr.action_type = 'START' AND lr.lev = 1 THEN lc_td_empty 
				WHEN lr.action_type = 'START' THEN lc_td_beg|| lc_html_graph_arrow ||lc_td_end 
				ELSE lc_td_beg||lower( lr.action_type)||lc_td_end
			END
			|| -- target step 
			lc_td_beg|| lr.target_step || lc_td_end  
			;
--  * the number of padding cells: 
--    level 1: 2 if condition is TRUE and action is START 
--    level 2: 2. 3rd cell is condition 4th is action 5th is target step
--    level 3: 4
--    etc 
		l_padder_cnt := (lr.lev - 1) * 2;  

		l_row_data_all := 
			lc_nl||'<!-- level '||lr.lev||' -->' -- comment to show level 
			||lc_nl
			|| rpad( ' ', 1 + l_padder_cnt * length( lc_td_empty), lc_td_empty )
			||l_step_presenting_cells
			;
		l_table_body := l_table_body 
			||'<tr>'
			||l_row_data_all
			||'</tr>'
			||lc_nl 
			;
	END LOOP;
	RETURN 
		'<html>'
		||lc_nl|| lc_html_style  
		||lc_nl|| '<body> ' 
		||lc_nl|| lc_table_beg
		||lc_nl||l_table_body
		||lc_nl||lc_table_end
		||lc_nl||'</body>' 
		||lc_nl||'</html>' 
		;
END;
/

/* example of HTML data 
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
	}'
	*/

show errors
