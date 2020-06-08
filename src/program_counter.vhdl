LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY program_counter IS
	PORT (
		-- control signals
		clk		: IN std_logic;	-- clock
		rst		: IN std_logic; -- reset
		
		-- branch control
		branch_zero	: IN std_logic; -- branch if zero
		zero		: IN std_logic;	-- zero flag
		offset		: IN word;	-- branch offset

		-- outputs
		addr		: OUT word	-- instruction address
	);
END program_counter;

ARCHITECTURE behavioural OF program_counter IS 
BEGIN
	PROCESS (clk)

		VARIABLE val: integer;						-- Internal value

	BEGIN
		IF (rst = '1') THEN						-- Reset to first instruction
			val := 0; 
		ELSE 								-- Advance to next instruction
			val := val + 4;
			IF (branch_zero = '1' AND zero = '1') THEN		-- Branch to new relative address
				val := val + to_integer(signed(offset) * 4); 
			END IF;
		END IF;
				
		addr <= std_logic_vector(to_signed(val, addr'length)); 		-- Output internal value
	END PROCESS;
END behavioural;
