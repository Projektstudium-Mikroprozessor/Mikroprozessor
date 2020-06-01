LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu_control IS
	PORT (
		-- inputs
		cntrl_op: IN std_logic_vector(1 DOWNTO 0);
		func: IN std_logic_vector(3 DOWNTO 0);
		
		-- outputs
		op: OUT std_logic_vector(2 DOWNTO 0);
		a_inv, b_neg: OUT std_logic	
	);
END alu_control;

ARCHITECTURE behavioural OF alu_control IS
BEGIN
	PROCESS (cntrl_op, func)
	BEGIN
		IF (cntrl_op = "00") THEN		-- address calculation
			op <= "010";
			a_inv <= '0';
			b_neg <= '0';
		ELSIF (cntrl_op = "01") THEN		-- compare
			op <= "010";
			a_inv <= '0';
			b_neg <= '1';
		ELSIF (cntrl_op = "10") THEN		-- arithmetic / logic
			-- bit 0+2: op, 1: b_neg, 3: a_inv, 2+3: shifts
			IF (func = "0000") THEN			-- add
				op <= "010";
				a_inv <= '0';
				b_neg <= '0';
			ELSIF (func = "0010") THEN		-- sub
				op <= "010";
				a_inv <= '0';
				b_neg <= '1';

			ELSIF (func = "0100") THEN		-- and
				op <= "000";
				a_inv <= '0';
				b_neg <= '0';
			ELSIF (func = "0101") THEN		-- or
				op <= "001";
				a_inv <= '0';
				b_neg <= '0';
			ELSIF (func = "1011") THEN		-- nand
				op <= "001";
				a_inv <= '1';
				b_neg <= '1';
			ELSIF (func = "1010") THEN		-- nor
				op <= "000";
				a_inv <= '1';
				b_neg <= '1';

			ELSIF (func = "1100") THEN		-- shl
				op <= "100";
				a_inv <= '0';
				b_neg <= '0';
			ELSIF (func = "1110") THEN		-- slr
				op <= "110";
				a_inv <= '0';
				b_neg <= '0';
			ELSIF (func = "1111") THEN		-- sar
				op <= "111";
				a_inv <= '0';
				b_neg <= '0';
			END IF;
		END IF;
	END PROCESS;
END behavioural;