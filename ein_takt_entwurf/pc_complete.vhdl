library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc_complete is
    port (
        clk    : in std_logic;                     -- clk_signal
        Branch : in std_logic;                     -- Branch_signal from CTRL_Unit
        Zero   : in std_logic;                     -- Zero Flag from ALU
        offset : in std_logic_vector(15 downto 0); -- last 16 Instruction-Bits
        
        pc : out std_logic_vector(31 downto 0) -- outgoing machinecode
    );
end entity pc_complete;

architecture structure of pc_complete is 
    signal s_offset : std_logic_vector(31 downto 0);
    begin
	program_counter : entity work.program_counter port map (
	    clk    => clk,
	    Branch => Branch,
	    Zero   => Zero,
	    offset => s_offset,
	    pc     => pc
	);
	vz_erweiterer : entity work.vz_erweiterung port map (
	    offset	   => offset,
	    offset_shifted => s_offset
	);
end structure;