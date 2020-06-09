LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY stage_buffer_memory IS
	PORT (
		-- control signals
		clock		: IN std_logic;		-- clock

		-- inputs
		write_imm_in	: IN reg_addr;		-- second register address input
		write_reg_in	: IN reg_addr;		-- third register address input
		data_in		: IN word;		-- data input
		res_in		: IN word;		-- result input

		-- outputs
		write_imm	: OUT reg_addr;		-- second register address output
		write_reg	: OUT reg_addr;		-- third register address output
		data		: OUT word;		-- data output
		res		: OUT word		-- result output
	);
END stage_buffer_memory;

ARCHITECTURE behavioural OF stage_buffer_memory IS
BEGIN
	PROCESS (clock)
	BEGIN
		IF clock'event AND clock = '1' THEN
			write_imm	<= write_imm_in;	-- second register address
			write_reg	<= write_reg_in;	-- third register address
			data		<= data_in;		-- data
			res		<= res_in;		-- result
		END IF;
	END PROCESS;
END behavioural;
