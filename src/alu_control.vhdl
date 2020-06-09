LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY alu_control IS
	PORT (
		-- inputs
		cntrl_op	: IN basic_operation;			-- control operation
		func		: IN func_specifier;	-- function specifier
		
		-- outputs
		op 		: OUT operation				-- operation
	);
END alu_control;

ARCHITECTURE behavioural OF alu_control IS
BEGIN
	PROCESS (cntrl_op, func)
	BEGIN
		CASE cntrl_op IS
			WHEN "00" => op <= "01000";			-- address calculation
			WHEN "01" => op <= "01001";			-- compare
			WHEN "10" =>					-- arithmetic / logic
				CASE func IS 				-- bit 0+2: op, 1: b_neg, 3: a_inv, 2+3: shifts
					WHEN "0000" => op <= "01000";	-- add
					WHEN "0010" => op <= "01001";	-- sub
					WHEN "0100" => op <= "00000";	-- and
					WHEN "0101" => op <= "00100";	-- or
					WHEN "1011" => op <= "00111";	-- nand
					WHEN "1010" => op <= "00011";	-- nor
					WHEN "1100" => op <= "10000";	-- shl
					WHEN "1110" => op <= "11000";	-- shr
					WHEN "1111" => op <= "11100";	-- sar
					WHEN OTHERS => op <= (OTHERS => '1');
				END CASE;
			WHEN OTHERS => op <= (OTHERS => '1');
		END CASE;
	END PROCESS;
END behavioural;