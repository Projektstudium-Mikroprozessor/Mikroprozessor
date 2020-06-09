LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY stage_buffer_registers IS
	PORT (
		-- control signals
		clock		: IN std_logic;		-- clock

		-- inputs
		reg_1_in	: IN word;		-- first register data input
		reg_2_in	: IN word;		-- second register data input
		write_imm_in	: IN reg_addr;		-- second register address input
		write_reg_in	: IN reg_addr;		-- third register address input
		imm_off_in	: IN word;		-- immediate / offset input
		func_in 	: IN func_specifier;	-- function specifier input

		-- outputs
		reg_1		: OUT word;		-- first register data output
		reg_2		: OUT word;		-- second register data output
		write_imm	: OUT reg_addr;		-- second register address output
		write_reg	: OUT reg_addr;		-- third register address output
		imm_off		: OUT word;		-- immediate /offset output
		func		: OUT func_specifier	-- fuction specifier output
	);
END stage_buffer_registers;

ARCHITECTURE behavioural OF stage_buffer_registers IS
BEGIN
	PROCESS (clock)
	BEGIN
		IF clock'event AND clock = '1' THEN
			reg_1		<= reg_1_in;		-- first register data
			reg_2		<= reg_2_in;		-- second register data
			write_imm	<= write_imm_in;	-- second register address
			write_reg	<= write_reg_in;	-- third register address
			imm_off		<= imm_off_in;		-- immediate / offset
			func		<= func_in;		-- function specifier
		END IF;
	END PROCESS;
END behavioural;
