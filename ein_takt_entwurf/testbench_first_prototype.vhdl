library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity testbench_first_prototype is
end entity testbench_first_prototype;

architecture behav_testbench_first_prototype of testbench_first_prototype is

    component pc_and_instruction
        port (
            clk : in std_logic;
            Branch : in std_logic;
            Zero : in std_logic;
            offset : in std_logic_vector(15 downto 0);

            instruction : out std_logic_vector(31 downto 0)
        );
    end component;

    component reg is
        port (
            mem_write  : in std_logic;
            data_in    : in std_logic_vector(31 downto 0);
            read_addr1 : in std_logic_vector(4 downto 0);
            read_addr2 : in std_logic_vector(4 downto 0);
            addr3      : in std_logic_vector(4 downto 0);
            reg_dst    : in std_logic;
    
            data_out1  : out std_logic_vector(31 downto 0);        
            data_out2  : out std_logic_vector(31 downto 0)
        );
    end component;

    component cntrl_unit is
        port (
	    opCode  : in std_logic_vector(5 downto 0);

            RegDst  : out std_logic;
            RegRW   : out std_logic;
            ALUSrc  : out std_logic;
            ALUOp1  : out std_logic;
            ALUOp0  : out std_logic;
            MemRW   : out std_logic;
            Mem2Reg : out std_logic;
            Branch  : out std_logic
        );
    end component;

    component ALU_complete is
	port (        
	    ALUscr        : in std_logic;
            ALUOp         : in std_logic_vector(1 downto 0);
            daten1        : in std_logic_vector(31 downto 0);
            daten2        : in std_logic_vector(31 downto 0);
            offset        : in std_logic_vector(15 downto 0);
            func_external : in std_logic_vector(5 downto 0);
        
	    zero_out      : out std_logic;
            erg           : out std_logic_vector(31 downto 0)
	);
    end component;

    component data_mem is 
	port (
	    MemRW    : in std_logic;
	    Mem2Reg  : in std_logic;
	    addr     : in std_logic_vector(31 downto 0);
	    data_in  : in std_logic_vector(31 downto 0);

	    data_out : out std_logic_vector(31 downto 0)
	);
    end component;

    signal s_clk : std_logic := '0';

    -- pc_and_instruction
    signal s_instruction : std_logic_vector(31 downto 0);
    
    -- register
    signal s_reg_data_out1 : std_logic_vector(31 downto 0);
    signal s_reg_data_out2 : std_logic_vector(31 downto 0);

    -- alu
    signal s_zero_out : std_logic;
    signal s_erg      : std_logic_vector(31 downto 0);

    -- ctrl_unit
    signal s_RegDst  : std_logic;
    signal s_RegRW   : std_logic;
    signal s_ALUSrc  : std_logic;
    signal s_ALUOp   : std_logic_vector(1 downto 0);
    signal s_MemRW   : std_logic;
    signal s_Mem2Reg : std_logic;
    signal s_Branch  : std_logic;

    -- datamemory
    signal s_mem_data_out : std_logic_vector(31 downto 0);

begin
    pc_instruction_map: pc_and_instruction port map (
        clk   	    => s_clk,
        Branch 	    => s_Branch,
        Zero        => s_zero_out,
        offset 	    => s_instruction(15 downto 0),

	instruction => s_instruction
    );

    Control_unit: cntrl_unit port map (
	opCode  => s_instruction(31 downto 26),

	RegDst  => s_RegDst,
	RegRW   => s_RegRW,
	AluSrc  => s_AluSrc,
	ALUOp1  => s_ALUOp(1),
	ALUOp0  => s_ALUOp(0),
	MemRW   => s_MemRW,
	Mem2Reg => s_Mem2Reg,
	Branch  => s_Branch
    );

    Register_mapping: reg port map (
	mem_write  => s_RegRW,
	data_in    => s_mem_data_out,
	read_addr1 => s_instruction(25 downto 21),
	read_addr2 => s_instruction(20 downto 16),
	addr3      => s_instruction(15 downto 11),
	reg_dst    => s_RegDst,

	data_out1  => s_reg_data_out1,
	data_out2  => s_reg_data_out2
    );

    alu: ALU_complete port map (
	ALUscr        => s_AluSrc,
	ALUOp         => s_ALUOp, 
	daten1        => s_reg_data_out1,
	daten2	      => s_reg_data_out2,
	offset        => s_instruction(15 downto 0),
	func_external => s_instruction(5 downto 0),
	
	zero_out      => s_zero_out,
	erg 	      => s_erg
    );

    data_memory: data_mem port map (
	MemRW    => s_MemRW,
	Mem2Reg  => s_Mem2Reg,
	addr     => s_erg,
	data_in  => s_reg_data_out2,
	
	data_out => s_mem_data_out
    );    

    s_clk <= not s_clk after 10 ns;

    proc_pc: process
    begin
    
    wait for 1000 ns;
    end process proc_pc;
end;