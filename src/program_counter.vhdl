LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY program_counter IS
	PORT (
		-- control signals
		clock		: IN std_logic;		-- clock
		reset		: IN std_logic; 	-- reset
		enable		: IN std_logic; 	-- enable
		
		-- branch control
		branch_zero	: IN std_logic; 	-- branch if zero
		zero		: IN std_logic;		-- zero flag
		offset		: IN word;		-- branch offset

		-- outputs
		addr		: OUT word;		-- instruction address
		invalidate	: OUT std_logic		-- invalidate fetch pipline
	);
END program_counter;

ARCHITECTURE behavioural OF program_counter IS 
BEGIN
	PROCESS (clock, reset)
	BEGIN
		IF reset = '1' THEN
			addr			<= (OTHERS => '0');				-- reset address
			invalidate 		<= '0'; 					-- reset invalidation
		ELSIF clock'event AND clock = '1' THEN
			IF branch_zero = '1' AND zero = '1' THEN
				addr 		<= addr - 4 + to_integer(signed(offset) * 4);	-- branch with offset
				invalidate 	<= '1';						-- invalidate
			ELSIF enable = '1' THEN
				addr 		<= addr + 4;					-- advance
				invalidate	<= '0';						-- continue, no unexpected jump
			END IF;
		END IF;
	END PROCESS;
END behavioural;
