library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_complete_tb is
end alu_complete_tb;

architecture alu_complete_tb_behav of alu_complete_tb is

    Signal clk_external    : std_logic := '0';
    -- Signale fuer ALU_cntrl
    Signal func_external   : std_logic_vector(5 downto 0);
    Signal ALUOp           : std_logic_vector(1 downto 0);
    Signal alu_cntrl_out   : std_logic_vector(3 downto 0);
    -- Signale fuer alu
    Signal zero_out        : std_logic;
    Signal erg             : std_logic_vector(31 downto 0);
    Signal daten1          : std_logic_vector(31 downto 0);
    Signal mux_out         : std_logic_vector(31 downto 0);
    -- Signale fuer mux
    Signal ALUscr          : std_logic;
    Signal daten2          : std_logic_vector(31 downto 0);
    Signal vz_erweiterung  : std_logic_vector(31 downto 0);
    -- Konstanten
    constant half_period   : time := 4 ns /2;
    constant wait_time     : time := 10 ns;
  
  component alu is 
    port(
     clk           : in std_logic;
     input_1 	   : in std_logic_vector(31 downto 0);
     input_2  	   : in std_logic_vector(31 downto 0);
     input_1_inv   : in std_logic;
     input_2_neg   : in std_logic;
     Op      	   : in std_logic_vector(1 downto 0);
     result  	   : out std_logic_vector(31 downto 0);
     zero          : out std_logic
    );
  end component alu;

  component mux is
    port(
        clk        : in std_logic;
        e0,e1      : in std_logic_vector(31 downto 0);
        s          : in std_logic;
        a          : out std_logic_vector(31 downto 0)
    );
  end component mux;

  component ALU_cntrl is 
    port (
        func    : in std_logic_vector(5 downto 0);
        ALUOp1  : in std_logic;
        ALUOp0  : in std_logic;
        Op      : out std_logic_vector(3 downto 0)
    );
  end component ALU_cntrl;

begin
  alu_INST : alu port map (clk => clk_external, input_1 => daten1, input_2 => mux_out, input_1_inv => alu_cntrl_out(3), input_2_neg => alu_cntrl_out(2), Op => alu_cntrl_out(1 downto 0), result => erg, zero => zero_out);
  mux_INST : mux port map (clk => clk_external, e0 => daten2, e1 => vz_erweiterung, s => ALUscr, a => mux_out);
  ALU_cntrl_INST : ALU_cntrl port map (func => func_external, ALUOp1 => ALUOp(1), ALUOp0 => ALUOp(0), Op => alu_cntrl_out);
  
  process1: clk_external <= not clk_external after half_period;
  process2: process is
    begin
	-- Am Anfang kommt Quatsch raus, da Signal vom Mux undefiniert
	-- entweder Ausgangssignal initialisieren oder Mux ungetaktet machen

        -- ALU_cntrl
        func_external <= "000000";
        ALUOp <= "10";
        -- mux
        ALUscr <= '0';
        daten2 <= (0 => '1', others => '0');
        vz_erweiterung <= (0 => '1', others => '0');
        -- alu
        daten1 <= (0 => '1', others => '0');
        wait for wait_time;
    end process;
end alu_complete_tb_behav;
