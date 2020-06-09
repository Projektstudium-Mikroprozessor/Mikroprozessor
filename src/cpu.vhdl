LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY cpu IS
	PORT (
		-- control signals
		clock		: IN std_logic;		-- clock
		reset		: IN std_logic; 	-- reset

		-- inputs
		instr_mem	: IN word;		-- instruction input
		data_mem	: IN word;		-- data input

		-- outputs
		instr_addr	: OUT word;		-- instuction address
		data_addr	: OUT word;		-- data address
		data_out	: OUT word;		-- data output
		data_rw		: OUT std_logic		-- data read / write
	);
END cpu;

ARCHITECTURE structural OF cpu IS

	SIGNAL invalidate	: std_logic;		-- invalidate fetch pipeline

	SIGNAL instr		: word;			-- instruction

	SIGNAL reg_1		: word;			-- first register data (from registers)
	SIGNAL reg_2		: word;			-- second register data (from registers)

	SIGNAL reg_1_alu	: word;			-- first register data (for alu)
	SIGNAL reg_2_alu	: word;			-- second register data (for alu)
	SIGNAL write_imm_alu	: reg_addr;		-- second register address (for alu)
	SIGNAL write_reg_alu	: reg_addr;		-- third register address (for alu)
	SIGNAL imm_off		: word;			-- immediate value / branch offset
	SIGNAL func		: func_specifier;	-- function specifier

	SIGNAL res		: word;			-- result (from alu)
	SIGNAL zero		: std_logic;		-- zero flag (res == 0)

	SIGNAL reg_2_mem	: word;			-- second register data (for memory)
	SIGNAL write_imm_mem	: reg_addr;		-- second register address (for memory)
	SIGNAL write_reg_mem	: reg_addr;		-- third register address (for memory)
	SIGNAL res_mem		: word;			-- result (for memory)

	SIGNAL write_imm	: reg_addr;		-- second register address (for write-back)
	SIGNAL write_reg	: reg_addr;		-- third register address (for write-back)
	SIGNAL data		: word;			-- data
	SIGNAL res_wb		: word;			-- result (for write-back)

	SIGNAL stalled		: std_logic;		-- pipeline stalled
	SIGNAL branch_zero	: std_logic;		-- branch if zero
	SIGNAL reg_rw		: std_logic;		-- registers read / write
	SIGNAL mem_res		: std_logic;		-- write memory / result
	SIGNAL reg_imm_regs	: std_logic;		-- 3-register instruction / 2-register & immediate (registers)
	SIGNAL reg_imm_alu	: std_logic;		-- 3-register instruction / 2-register & immediate (alu)
	SIGNAL cntrl_op		: basic_operation;	-- control operation

	SIGNAL op 		: operation;		-- operation

BEGIN
	pc: ENTITY work.program_counter PORT MAP (
		clock		=> clock,
		reset		=> reset,
		enable		=> NOT stalled,
		branch_zero	=> branch_zero,
		zero		=> zero,
		offset		=> imm_off,
		addr		=> instr_addr,
		invalidate	=> invalidate
	);

	sb_instr: ENTITY work.stage_buffer_instruction PORT MAP (
		clock		=> clock,
		reset		=> reset,
		invalidate	=> invalidate,
		enable		=> NOT stalled,
		instr_in	=> instr_mem,
		instr		=> instr
	);

	registers: ENTITY work.registers PORT MAP (
		clock		=> clock,
		rw		=> reg_rw,
		mem_res		=> mem_res,
		reg_imm		=> reg_imm_regs,
		read_1		=> instr(25 DOWNTO 21),
		read_2		=> instr(20 DOWNTO 16),
		write_imm	=> write_imm,
		write_reg	=> write_reg,
		data_mem	=> data,
		data_res	=> res_wb,
		data_1		=> reg_1,
		data_2		=> reg_2
	);

	sb_regs: ENTITY work.stage_buffer_registers PORT MAP (
		clock		=> clock,
		reg_1_in	=> reg_1,
		reg_2_in	=> reg_2,
		write_imm_in	=> instr(20 DOWNTO 16),
		write_reg_in	=> instr(15 DOWNTO 11),
		imm_off_in	=> std_logic_vector(resize(signed(instr(15 DOWNTO 0)), imm_off'length)),
		func_in		=> instr(3 DOWNTO 0),
		reg_1		=> reg_1_alu,
		reg_2		=> reg_2_alu,
		write_imm	=> write_imm_alu,
		write_reg	=> write_reg_alu,
		imm_off		=> imm_off,
		func		=> func
	);

	alu: ENTITY work.arithmetic_logic_unit PORT MAP (
		reg_1		=> reg_1_alu,
		reg_2		=> reg_2_alu,
		imm		=> imm_off,
		res		=> res,
		op		=> op,
		reg_imm		=> reg_imm_alu,
		zero		=> zero
	);

	sb_alu: ENTITY work.stage_buffer_alu PORT MAP (
		clock		=> clock,
		reg_2_in	=> reg_2_alu,
		write_imm_in	=> write_imm_alu,
		write_reg_in	=> write_reg_alu,
		res_in		=> res,
		reg_2		=> reg_2_mem,
		write_imm	=> write_imm_mem,
		write_reg	=> write_reg_mem,
		res		=> res_mem
	);

	sb_mem: ENTITY work.stage_buffer_memory PORT MAP (
		clock		=> clock,
		write_imm_in	=> write_imm_mem,
		write_reg_in	=> write_reg_mem,
		data_in		=> data_mem,
		res_in		=> res_mem,
		write_imm	=> write_imm,
		write_reg	=> write_reg,
		data		=> data,
		res		=> res_wb
	);

	cu: ENTITY work.control_unit PORT MAP (
		clock		=> clock,
		reset		=> reset,
		instr		=> instr,
		stalled		=> stalled,
		branch_zero	=> branch_zero,
		reg_rw		=> reg_rw,
		mem_res		=> mem_res,
		reg_imm_regs	=> reg_imm_regs,
		reg_imm_alu	=> reg_imm_alu,
		cntrl_op	=> cntrl_op,
		mem_rw		=> data_rw
	);

	alu_cntrl: ENTITY work.alu_control PORT MAP (
		cntrl_op 	=> cntrl_op,
		func 		=> func,
		op 		=> op
	);

	data_addr	<= res_mem;	-- data address
	data_out 	<= reg_2_mem;	-- data output
END structural;