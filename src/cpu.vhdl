LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY cpu IS
	PORT (
		-- control signals
		clk, rst: IN std_logic;

		-- inputs
		instr, data: IN std_logic_vector(31 DOWNTO 0);

		-- outputs
		instr_addr, data_addr, data_out: OUT std_logic_vector(31 DOWNTO 0);
		data_rw: OUT std_logic
	);
END cpu;

ARCHITECTURE structural OF cpu IS

	SIGNAL branch_zero, zero, reg_rw, mem_res, reg_imm, a_inv, b_neg: std_logic;
	SIGNAL reg_1, reg_2, imm, res, offset: std_logic_vector(31 DOWNTO 0);
	SIGNAL cntrl_op: std_logic_vector(1 DOWNTO 0);
	SIGNAL op: std_logic_vector(2 DOWNTO 0);

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
		a_inv => a_inv,
		b_neg => b_neg,
		zero => zero
	);

	cu: ENTITY work.control_unit PORT MAP (
		opcode => instr(31 DOWNTO 26),
		branch_zero => branch_zero,
		reg_rw => reg_rw,
		mem_res => mem_res,
		reg_imm => reg_imm,
		op => cntrl_op,
		mem_rw => data_rw
	);

	alu_cntrl: ENTITY work.alu_control PORT MAP (
		cntrl_op => cntrl_op,
		func => instr(3 DOWNTO 0),
		op => op,
		a_inv => a_inv,
		b_neg => b_neg
	);

	imm <= std_logic_vector(resize(signed(instr(15 DOWNTO 0)), imm'length));
	offset <= std_logic_vector(resize(signed(instr(15 DOWNTO 0)), offset'length));
	data_addr <= res;
	data_out <= reg_2;
END structural;