LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY stage_buffer_instruction IS
	PORT (
		-- control signals
		clock		: IN std_logic;	-- clock
		reset		: IN std_logic;	-- reset
		invalidate	: IN std_logic; -- invalidate
		enable		: IN std_logic;	-- enable

		-- inputs
		instr_in	: IN word;	-- instruction input

		-- outputs
		instr		: OUT word	-- instruction output
	);
END stage_buffer_instruction;

ARCHITECTURE behavioural OF stage_buffer_instruction IS
BEGIN
	PROCESS (clock, reset, invalidate)
	BEGIN
		IF reset = '1' THEN
			instr <= (OTHERS => '0');	-- reset instruction
		ELSIF invalidate'event AND invalidate = '1' THEN
			instr <= (OTHERS => '0');	-- reset instruction
		ELSIF clock'event AND clock = '1' THEN
			IF enable = '1' THEN
				instr <= instr_in;	-- instruction
			END IF;
		END IF;
	END PROCESS;
END behavioural;
