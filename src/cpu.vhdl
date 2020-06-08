LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY cpu IS
	PORT (
		-- control signals
		clk		: IN std_logic;		-- clock
		rst		: IN std_logic; 	-- reset

		-- inputs
		instr		: IN word;		-- instruction
		data		: IN word;		-- data input

		-- outputs
		instr_addr	: OUT word;		-- instuction address
		data_addr	: OUT word;		-- data address
		data_out	: OUT word;		-- data output
		data_rw		: OUT std_logic		-- data read / write
	);
END cpu;

ARCHITECTURE structural OF cpu IS

	SIGNAL reg_1		: word;			-- first register data
	SIGNAL reg_2		: word;			-- second register data

	SIGNAL res		: word;			-- result
	SIGNAL zero		: std_logic;		-- zero flag (res == 0)


	SIGNAL branch_zero	: std_logic;		-- branch if zero
	SIGNAL reg_rw		: std_logic;		-- registers read / write
	SIGNAL mem_res		: std_logic;		-- write memory / result
	SIGNAL reg_imm		: std_logic;		-- 3-register instruction / 2-register & immediate
	SIGNAL cntrl_op		: basic_operation;	-- control operation
	SIGNAL mem_rw		: std_logic;		-- memory read / write

	SIGNAL op 		: operation;		-- operation

	SIGNAL imm		: word;			-- immediate value
	SIGNAL offset		: word;			-- branch offset

BEGIN
	pc: ENTITY work.program_counter PORT MAP (
		clk => clk,
		rst => rst,
		branch_zero => branch_zero,
		zero => zero,
		offset => offset,
		addr => instr_addr
	);

	registers: ENTITY work.registers PORT MAP (
		clk => clk,
		rw => reg_rw,
		mem_res => mem_res,
		reg_imm => reg_imm,
		read_1 => instr(25 DOWNTO 21),
		read_2 => instr(20 DOWNTO 16),
		write_imm => instr(20 DOWNTO 16),
		write_reg => instr(15 DOWNTO 11),
		data_mem => data,
		data_res => res,
		data_1 => reg_1,
		data_2 => reg_2
	);

	alu: ENTITY work.arithmetic_logic_unit PORT MAP (
		reg_1 => reg_1,
		reg_2 => reg_2,
		imm => imm,
		res => res,
		op => op,
		reg_imm => reg_imm,
		zero => zero
	);

	cu: ENTITY work.control_unit PORT MAP (
		opcode => instr(31 DOWNTO 26),
		branch_zero => branch_zero,
		reg_rw => reg_rw,
		mem_res => mem_res,
		reg_imm => reg_imm,
		cntrl_op => cntrl_op,
		mem_rw => data_rw
	);

	alu_cntrl: ENTITY work.alu_control PORT MAP (
		cntrl_op => cntrl_op,
		func => instr(3 DOWNTO 0),
		op => op
	);

	imm <= std_logic_vector(resize(signed(instr(15 DOWNTO 0)), imm'length));	-- immediate
	offset <= std_logic_vector(resize(signed(instr(15 DOWNTO 0)), offset'length));	-- branch offset

	data_addr <= res;								-- data address
	data_out <= reg_2;								-- data output
END structural;