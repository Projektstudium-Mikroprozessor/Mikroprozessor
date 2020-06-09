LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY memory IS
	PORT (
		-- control signals
		clk	: IN std_logic;	-- clock
		rw	: IN std_logic; -- read / write

		-- inputs
		addr	: IN word;	-- address
		data_in	: IN word;	-- data input

		-- outputs
		data	: OUT word	-- data output
	);
END memory;

ARCHITECTURE behavioural OF memory IS
BEGIN
	PROCESS (clk, addr)

		TYPE memory_bank IS ARRAY(0 TO 2**20-1) OF word;	-- memory bank, max length 2**30 (4 * 1GB)
		VARIABLE values	: memory_bank; 				-- memory values

	BEGIN
		IF clk'event AND clk = '1' THEN
			IF rw = '1' THEN
				values(to_integer(unsigned(addr) mod (4 * values'length) / 4)) := data_in;	-- write data input to address
			END IF;
		END IF;
		
		data <= values(to_integer(unsigned(addr) mod (4 * values'length) / 4));				-- read from address to data output
	END PROCESS;
END behavioural;