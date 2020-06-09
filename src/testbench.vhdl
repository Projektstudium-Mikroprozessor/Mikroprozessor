LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE testbench OF testbench IS

	CONSTANT speed	: time := 100 ps;	-- clock speed

	SIGNAL clock	: std_logic := '0';	-- clock
	SIGNAL reset	: std_logic := '1';	-- reset

BEGIN
	clock <= NOT clock AFTER speed;		-- generate clock signal
	reset <= '0' AFTER (1.5 * speed);	-- reset on startup

	uc: ENTITY work.ucontroller PORT MAP (
		clock => clock,
		reset => reset
	);

	PROCESS
	BEGIN
		WAIT FOR 200 * (2 * speed);	-- run for 200 cycles
		std.env.stop;			-- stop simulation
	END PROCESS;
END testbench;
