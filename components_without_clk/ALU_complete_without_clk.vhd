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
        func_external   : in std_logic_vector(5 downto 0);
        zero_out        : out std_logic;
        erg             : out std_logic_vector(31 downto 0)
    ); 
end ALU_complete;

architecture structure of ALU_complete is   
    signal mux_out          : std_logic_vector(31 downto 0);
    signal alu_cntrl_out    : std_logic_vector(3 downto 0);
    begin
        mux_alu     :   entity work.mux port map(clk => clk_external, e0 => daten2, e1 => vz_erweiterung, s => ALUscr, a => mux_out);
        ALU_cntrl   :   entity work.ALU_cntrl port map(func => func_external, ALUOp1 => ALUOp(1), ALUOp0 => ALUOp(0), Op => alu_cntrl_out);
        ALU         :   entity work.alu port map (clk => clk_external, input_1 => daten1, input_2 => mux_out, input_1_inv => alu_cntrl_out(3), input_2_neg => alu_cntrl_out(2), Op => alu_cntrl_out(1 downto 0), result => erg, zero => zero_out);    
end structure;