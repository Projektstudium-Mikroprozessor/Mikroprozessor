LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY stage_buffer_alu IS
	PORT (
		-- control signals
		clock		: IN std_logic;		-- clock

		-- inputs
		reg_2_in	: IN word;		-- second register data input
		write_imm_in	: IN reg_addr;		-- second register address input
		write_reg_in	: IN reg_addr;		-- third register address input
		res_in		: IN word;		-- result input

		-- outputs
		reg_2		: OUT word;		-- second register data output
		write_imm	: OUT reg_addr;		-- second register address output
		write_reg	: OUT reg_addr;		-- third register address output
		res		: OUT word		-- result output
	);
END stage_buffer_alu;

ARCHITECTURE behavioural OF stage_buffer_alu IS
BEGIN
	PROCESS (clock)
	BEGIN
		IF clock'event AND clock = '1' THEN
			reg_2		<= reg_2_in;		-- second register data
			write_imm	<= write_imm_in;	-- second register address
			write_reg	<= write_reg_in;	-- third register address
			res		<= res_in;		-- result
		END IF;
	END PROCESS;
END behavioural;
