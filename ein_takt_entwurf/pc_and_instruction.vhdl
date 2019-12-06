library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc_and_instruction is
    port (
        clk    : in std_logic;                     -- clk_signal
        Branch : in std_logic;                     -- Branch_signal from CTRL_Unit
        Zero   : in std_logic;                     -- Zero Flag from ALU
        Offset : in std_logic_vector(15 downto 0); -- last 16 Instruction-Bits
        
        instruction : out std_logic_vector(31 downto 0) -- outgoing machinecode
    );
end entity pc_and_instruction;

architecture structure of pc_and_instruction is 
    signal s_pc : std_logic_vector(31 downto 0);
    begin
	program_counter_complete : entity work.pc_complete port map (
	    clk => clk,
	    Branch => Branch,
	    Zero => Zero,
	    offset => Offset,
	    pc => s_pc
	);
	instruction_mem : entity work.instruction_mem port map (
	    i_addr => s_pc,
	    instruction => instruction
	);
end structure;