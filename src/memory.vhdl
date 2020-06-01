LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY memory IS
	PORT (
		-- control signals
		clk, rw: IN std_logic;

		-- inputs
		addr, data_in: IN std_logic_vector(31 DOWNTO 0);

		-- outputs
		data: OUT std_logic_vector(31 DOWNTO 0)
	);
END memory;

ARCHITECTURE behavioural OF memory IS
BEGIN
	PROCESS (clk, addr)

		SUBTYPE word IS std_logic_vector(31 DOWNTO 0);
		TYPE word_array IS ARRAY(0 TO 2**20-1) OF word; -- max length 2**30 (4 * 1GB)
		VARIABLE values: word_array; 

	BEGIN
		IF (clk'event AND rw = '1') THEN
			values(to_integer(unsigned(addr) mod (4 * values'length) / 4)) := data_in;
		END IF;
		
		data <= values(to_integer(unsigned(addr) mod (4 * values'length) / 4));
	END PROCESS;
END behavioural;