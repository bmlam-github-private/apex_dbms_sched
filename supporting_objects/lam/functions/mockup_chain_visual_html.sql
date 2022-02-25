set scan off
CREATE OR REPLACE FUNCTION mockup_chain_visual_html
( pi_chain_owner VARCHAR
 ,pi_chain_name VARCHAR
 ,pi_include_table_root_tag BOOLEAN DEFAULT TRUE
) RETURN CLOB
AS
	lc_table_body CONSTANT VARCHAR2(32000) := 
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
BEGIN 
	RETURN 
		CASE WHEN pi_include_table_root_tag THEN '<table> ' END
		|| lc_table_body
		|| CASE WHEN pi_include_table_root_tag THEN ' </table> ' END
		;
END;
/

show errors
