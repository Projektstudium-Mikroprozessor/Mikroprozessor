LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY control_unit IS
	PORT (
		-- inputs
		opcode		: IN std_logic_vector(5 DOWNTO 0);	-- opcode
		
		-- outputs
		branch_zero	: OUT std_logic;			-- branch if zero
		reg_rw		: OUT std_logic;			-- registers read / write
		mem_res		: OUT std_logic;			-- write memory / result
		reg_imm		: OUT std_logic;			-- 3-register instruction / 2-register & immediate
		cntrl_op	: OUT basic_operation;			-- control operation
		mem_rw		: OUT std_logic				-- memory read / write
	);
END control_unit;

ARCHITECTURE behavioural OF control_unit IS

	SIGNAL control	: std_logic_vector(0 TO 6);

BEGIN
	PROCESS (opcode)
	BEGIN
		-- bit 0: ls, 1: ls, 2: branch, 3: store, 4: -, 5: mem
		CASE opcode IS
			WHEN "000000" => control <= "0110100";		-- arithmetic / logic
			WHEN "000011" => control <= "0111000";		-- load immediate
			WHEN "100011" => control <= "0101000";		-- load
			WHEN "101011" => control <= "0001001";		-- store
			WHEN "000100" => control <= "1000010";		-- branch equal
			WHEN OTHERS   => control <= (OTHERS => '0');	-- default
		END CASE;
	END PROCESS;

	branch_zero 	<= control(0);		-- branch if zero
	reg_rw		<= control(1);		-- registers read / write
	mem_res 	<= control(2);		-- write memory / result
	reg_imm 	<= control(3);		-- 3-register instruction / 2-register & immediate
	cntrl_op 	<= control(4 TO 5);	-- control operation
	mem_rw	 	<= control(6);		-- memory read / write
END behavioural;