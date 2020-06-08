LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY ucontroller IS
	PORT (
		-- control signals
		clk	: IN std_logic;	-- clock
		rst	: IN std_logic -- reset
	);
END ucontroller;

ARCHITECTURE structural OF ucontroller IS

	SIGNAL instr_addr	: word;		-- instuction address
	SIGNAL data_addr	: word;		-- data address
	SIGNAL data_write	: word;		-- data to write
	SIGNAL data_rw		: std_logic;	-- data read / write

	SIGNAL data		: word;		-- data

	SIGNAL instr		: word;		-- instruction

BEGIN
	cpu: ENTITY work.cpu PORT MAP (
		clk => clk,
		rst => rst,
		instr => instr,
		data => data,
		instr_addr => instr_addr,
		data_addr => data_addr,
		data_out => data_write,
		data_rw => data_rw
	);

	memory: ENTITY work.memory PORT MAP (
		clk => clk,
		rw => data_rw,
		addr => data_addr,
		data_in => data_write,
		data => data
	);

	rom: ENTITY work.rom_fib PORT MAP (
		addr => instr_addr,
		data => instr
	);
END structural;