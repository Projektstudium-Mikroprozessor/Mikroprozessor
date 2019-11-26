library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_complete is 
    port (
        clk_external    : in std_logic;
        ALUscr          : in std_logic;
        ALUOp           : in std_logic_vector(1 downto 0);
        daten1          : in std_logic_vector(31 downto 0);
        daten2          : in std_logic_vector(31 downto 0);
        vz_erweiterung  : in std_logic_vector(31 downto 0);
        func            : in std_logic_vector(5 downto 0);
        zero            : out std_logic;
        erg             : out std_logic_vector(31 downto 0)
    ); 
end ALU_complete;

architecture structure of ALU_complete is   
    signal mux_out          : std_logic_vector(31 downto 0);
    signal alu_cntrl_out    : std_logic_vector(3 downto 0);
    begin
        mux_alu :   entity work.mux_2_1 port map(clk => clk_external, e0 => daten1, e1 => daten2, s => ALUscr, a => mux_out);
end structure;