LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY control_unit IS
	PORT (
		-- control signals
		clock		: IN std_logic;		-- clock
		reset		: IN std_logic;		-- reset

		-- inputs
		instr		: IN word;		-- instuction
		
		-- outputs
		stalled		: OUT std_logic;	-- pipeline stalled
		branch_zero	: OUT std_logic;	-- branch if zero
		reg_rw		: OUT std_logic;	-- registers read / write
		mem_res		: OUT std_logic;	-- write memory / result
		reg_imm_regs	: OUT std_logic;	-- 3-register instruction / 2-register & immediate (registers)
		reg_imm_alu	: OUT std_logic;	-- 3-register instruction / 2-register & immediate (alu)
		cntrl_op	: OUT basic_operation;	-- control operation
		mem_rw		: OUT std_logic		-- memory read / write
	);
END control_unit;

ARCHITECTURE behavioural OF control_unit IS
	
	-- fetch, [decode,] regs, alu (<-pc), memory, wb (<-regs)
	SIGNAL control, control_alu, control_mem, control_wb : std_logic_vector(0 TO 6);	-- control signals for stages
	SIGNAL regs, regs_alu, regs_mem, regs_wb : std_logic_vector(0 TO 31);			-- written registers for stages
	SIGNAL branch, branch_alu : std_logic;							-- branching behaviour for stages

BEGIN
	PROCESS (instr, regs_alu, regs_mem, regs_wb, branch_alu)

		VARIABLE opcode: std_logic_vector(5 DOWNTO 0);	-- opcode
		VARIABLE reg_1: reg_addr;			-- first register address
		VARIABLE reg_2: reg_addr;			-- second register address
		VARIABLE reg_3: reg_addr;			-- third reqister address
		VARIABLE writing: std_logic_vector(0 TO 31);	-- registers written to by stages
		VARIABLE branching: std_logic;			-- branch in progress by stages
		VARIABLE regs_cur: std_logic_vector(0 TO 31);	-- registers to be written
	BEGIN
		opcode := instr(31 DOWNTO 26);			-- opcode
		reg_1 := instr(25 DOWNTO 21);			-- first register address
		reg_2 := instr(20 DOWNTO 16);			-- second register address
		reg_3 := instr(15 DOWNTO 11);			-- third register address

		writing := regs_alu OR regs_mem OR regs_wb;	-- registers written to by stages
		branching := branch_alu;			-- branch in progress by stages

		-- stall if branch in progress or written registers should be read
		IF branching = '1' OR writing(to_integer(unsigned(reg_1))) = '1' OR (opcode(4 DOWNTO 0) /= "00011" AND writing(to_integer(unsigned(reg_2))) = '1') THEN
			control <= (OTHERS => '0');						-- do nothing
			regs	<= (OTHERS => '0');						-- no registers written
			branch	<= '0';								-- not branching
			stalled <= '1';								-- stall pipeline
		ELSE
			-- determine control signals
			-- opcode bit 0: ls, 1: ls, 2: branch, 3: store, 4: -, 5: mem
			CASE opcode IS
				WHEN "000000" => control <= "0110100";				-- arithmetic / logic
				WHEN "000011" => control <= "0111000";				-- load immediate
				WHEN "100011" => control <= "0101000";				-- load
				WHEN "101011" => control <= "0001001";				-- store
				WHEN "000100" => control <= "1000010";				-- branch equal
				WHEN OTHERS   => control <= (OTHERS => '0');			-- default
			END CASE;
			
			-- determine written registers
			regs_cur := (OTHERS => '0');
			CASE opcode IS
				WHEN "000000" => regs_cur(to_integer(unsigned(reg_3))) := '1';	-- arithmetic / logic (write to third register)
				WHEN "000011" => regs_cur(to_integer(unsigned(reg_2))) := '1';	-- load immediate (write to second register)
				WHEN "100011" => regs_cur(to_integer(unsigned(reg_2))) := '1';	-- load (write to second register)
				WHEN OTHERS   => NULL;						-- do not write to any register
			END CASE;
			regs_cur(0) := '0';							-- ignore write to r0 (hard-wired to 0)
			regs	    <= regs_cur;						-- written registers for stage

			-- determine branching behaviour
			branch <= '1' WHEN opcode = "000100" ELSE '0';				-- branch on branch equal instruction

			stalled <= '0';								-- pipeline is go
		END IF;
	END PROCESS;

	PROCESS (clock, reset)
	BEGIN
		IF reset = '1' THEN
			-- reset control signal
			control_wb	<= (OTHERS => '0');
			control_mem	<= (OTHERS => '0');
			control_alu	<= (OTHERS => '0');

			-- reset written registers
			regs_wb		<= (OTHERS => '0');
			regs_mem	<= (OTHERS => '0');
			regs_alu	<= (OTHERS => '0');

			-- reset branching behaviour
			branch_alu	<= '0';
		ELSIF clock'event AND clock = '1' THEN
			-- advance control signals through stages
			control_wb	<= control_mem;
			control_mem	<= control_alu;
			control_alu	<= control;

			-- advance written registers through stages
			regs_wb		<= regs_mem;
			regs_mem	<= regs_alu;
			regs_alu	<= regs;

			-- advance branching behaviour through stages
			branch_alu	<= branch;
		END IF;
	END PROCESS;

	branch_zero 	<= control_alu(0);	-- branch if zero
	reg_rw		<= control_wb(1);	-- registers read / write
	mem_res 	<= control_wb(2);	-- write memory / result
	reg_imm_regs 	<= control_wb(3);	-- 3-register instruction / 2-register & immediate (registers)
	reg_imm_alu	<= control_alu(3);	-- 3-register instruction / 2-register & immediate (alu)
	cntrl_op 	<= control_alu(4 TO 5);	-- control operation
	mem_rw	 	<= control_mem(6);	-- memory read / write
END behavioural;