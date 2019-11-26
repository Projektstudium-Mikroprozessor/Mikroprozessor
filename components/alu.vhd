library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is 
  Port(
     clk           : in std_logic;
     input_1 	   : in std_logic_vector(31 downto 0);
     input_2  	   : in std_logic_vector(31 downto 0);
     input_1_inv   : in std_logic;
     input_2_neg   : in std_logic;
     Op      	   : in std_logic_vector(1 downto 0);
     result  	   : out std_logic_vector(31 downto 0);
     zero          : out std_logic
  );
end alu;

architecture alu_behav of alu is
  Signal Erg_i 	   	: std_logic_vector(31 downto 0) := (others => '0');
  constant Null_Vector  : std_logic_vector(31 downto 0) := (others => '0');

  begin 
    process1: process (clk)
    begin
      if(rising_edge(clk)) then
        case(input_1_inv & input_2_neg & Op) is
          when "0000" => Erg_i <= input_1 and input_2;
          when "0001" => Erg_i <= input_1 or input_2;
          when "0010" => Erg_i <= input_1 + input_2;
          when "0110" => Erg_i <= input_1 - input_2;
          when "1100" => Erg_i <= not (input_1 or input_2);
          when others => Erg_i <= Null_Vector;
        end case;
      end if;
    end process;
    process2: result <= Erg_i;
    process3: process(Erg_i)
      begin
        if(Erg_i = Null_Vector) then
          zero <= '1';
        else
          zero <= '0';
        end if;
    end process;
end alu_behav;