LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY rom_fib IS
	PORT (
		-- inputs
		addr	: IN word;	-- address

		-- outputs
		data	: OUT word	-- data output
	);
END rom_fib;

ARCHITECTURE behavioural OF rom_fib IS
BEGIN
	PROCESS (addr)
		
		TYPE memory_bank IS ARRAY(0 TO 6) OF word; 		-- memory bank, max length 2**30 (4 * 1GB)
		VARIABLE values	: memory_bank := (			-- memory values
			0 => "00001111110000010000000000000000",	-- li	r1, 0(r30)
			1 => "00001111110000100000000000000001",	-- li	r2, 1(r30)
			2 => "00000000001000100001100000000000",	-- add	r3, r2, r1
			3 => "10101111110000110000000000000000",	-- sw	r3, 0(r30)
			4 => "00000011110000100000100000000000",	-- add	r1, r2, r30
			5 => "00000011110000110001000000000000",	-- add	r2, r3, r30
			6 => "00010011110111101111111111111011"		-- beq	r30, r30, -5
		);

	BEGIN
		data <= values(to_integer(unsigned(addr) mod (4 * values'length) / 4));	-- read from address to data output
	END PROCESS;
END behavioural;