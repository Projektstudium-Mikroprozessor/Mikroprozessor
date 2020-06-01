LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY rom_fib IS
	PORT (
		-- inputs
		addr: IN std_logic_vector(31 DOWNTO 0);

		-- outputs
		data: OUT std_logic_vector(31 DOWNTO 0)
	);
END rom_fib;

ARCHITECTURE behavioural OF rom_fib IS
BEGIN
	PROCESS (addr)
		
		SUBTYPE word IS std_logic_vector(31 DOWNTO 0);
		TYPE word_array IS ARRAY(0 TO 6) OF word; -- max length 2**30 (4 * 1GB)
		VARIABLE values: word_array := (
			0 => "00001100000000010000000000000000",
			1 => "00001100000000100000000000000001",
			2 => "00000000001000100001100000000000",
			3 => "10101100000000110000000000000000",
			4 => "00000000000000100000100000000000",
			5 => "00000000000000110001000000000000",
			6 => "00010000000000001111111111111011"
		);

	BEGIN
		data <= values(to_integer(unsigned(addr) mod (4 * values'length) / 4));
	END PROCESS;
END behavioural;