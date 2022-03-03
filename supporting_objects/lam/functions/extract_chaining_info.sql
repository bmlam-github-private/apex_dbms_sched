CREATE OR REPLACE FUNCTION extract_chaining_info 
( pi_chain_owner VARCHAR2
 ,pi_chain_name  VARCHAR2 
) RETURN chaining_info_tab
AS
	lt_return chaining_info_tab := chaining_info_tab();
	lt_tok_action sys.re$name_array;
	lt_tok_cond   sys.re$name_array;
	lr_chaining_info  chaining_info_rec ;
	l_add_row BOOLEAN;
BEGIN 
	FOR rec IN 
	(
		SELECT chain_name, owner, rule_name, condition, action
		FROM all_scheduler_chain_rules
		WHERE owner = pi_chain_owner
		  AND chain_name = pi_chain_name
		-- Oracle is not aware of order of steps or rules!
	) LOOP
		l_add_row := FALSE;
		lr_chaining_info := chaining_info_rec( null, null, null, null , null, null );

		lt_tok_action := split_by_regexp( rec.action );
		IF lt_tok_action.count >= 1 THEN 
			lr_chaining_info.action_type := norm_identifier (lt_tok_action(1));
			l_add_row := TRUE;
		END IF;
		IF lt_tok_action.count >= 2 THEN 
			lr_chaining_info.target_step := norm_identifier( lt_tok_action(2) );
		END IF;

		lt_tok_cond := split_by_regexp( rec.condition );
		IF lt_tok_cond.count > 1 THEN 
			lr_chaining_info.source_step := norm_identifier( lt_tok_cond(1) );
			l_add_row := TRUE;
		END IF;
		IF lt_tok_cond.count = 1 THEN 
			lr_chaining_info.exec_status := norm_identifier( lt_tok_cond(1) );
			l_add_row := TRUE;
		ELSIF lt_tok_cond.count >= 2 THEN 
			lr_chaining_info.exec_status := norm_identifier( lt_tok_cond(2) );
		END IF;

		IF l_add_row THEN
			lt_return.extend;
			lr_chaining_info.chain_name := rec.chain_name;
			lr_chaining_info.rule_name := rec.rule_name;
			--
			lt_return ( lt_return.count ) := lr_chaining_info;
		END IF;
	END LOOP;

	RETURN lt_return;
END;
/

show errors 