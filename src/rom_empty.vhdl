LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY rom_empty IS
	PORT (
		-- inputs
		addr	: IN word;	-- address

		-- outputs
		data	: OUT word	-- data output
	);
END rom_empty;

ARCHITECTURE behavioural OF rom_empty IS
BEGIN
	PROCESS (addr)
		
		TYPE memory_bank IS ARRAY(0 TO 0) OF word; 		-- memory bank, max length 2**30 (4 * 1GB)
		VARIABLE values	: memory_bank := (			-- memory values
			OTHERS => (OTHERS => '0')
		);

	BEGIN
		data <= values(to_integer(unsigned(addr) mod (4 * values'length) / 4));	-- read from address to data output
	END PROCESS;
END behavioural;