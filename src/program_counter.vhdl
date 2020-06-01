LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY program_counter IS
	PORT (
		-- control signals
		clk, rst: IN std_logic;
		
		-- branch control
		branch_zero, zero: IN std_logic;
		offset: IN std_logic_vector(31 DOWNTO 0);

		-- outputs
		addr: OUT std_logic_vector(31 DOWNTO 0)
	);
END program_counter;

ARCHITECTURE behavioural OF program_counter IS 
BEGIN
	PROCESS (clk)

		VARIABLE val: integer;

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
