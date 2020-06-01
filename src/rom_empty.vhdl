LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY rom_empty IS
	PORT (
		-- inputs
		addr: IN std_logic_vector(31 DOWNTO 0);

		-- outputs
		data: OUT std_logic_vector(31 DOWNTO 0)
	);
END rom_empty;

ARCHITECTURE behavioural OF rom_empty IS
BEGIN
	PROCESS (addr)
		
		SUBTYPE word IS std_logic_vector(31 DOWNTO 0);
		TYPE word_array IS ARRAY(0 TO 0) OF word; -- max length 2**30 (4 * 1GB)
		VARIABLE values: word_array := (
			OTHERS => "11111111111111111111111111111111"
		);

	BEGIN
		data <= values(to_integer(unsigned(addr) mod (4 * values'length) / 4));
	END PROCESS;
END behavioural;