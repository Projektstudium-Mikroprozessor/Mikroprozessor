LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE testbench OF testbench IS

	SIGNAL clk	: std_logic := '0';	-- clock
	SIGNAL rst	: std_logic := '0';	-- reset

BEGIN
	clk <= NOT clk AFTER 200 ps;		-- generate clock signal

	uc: ENTITY work.ucontroller PORT MAP (
		clk => clk,
		rst => rst
	);

	PROCESS
	BEGIN
		WAIT FOR 150 ps;
		rst <= '1';			-- reset on first edge
		WAIT FOR 100 ps;		
		rst <='0';
		WAIT FOR 100 * 200 ps;		-- run for 200 cycles
		std.env.stop;			-- stop simulation
	END PROCESS;
END testbench;
