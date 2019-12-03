library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_cntrl is 
    port (
        func    : in std_logic_vector(5 downto 0);
        ALUOp1  : in std_logic;
        ALUOp0  : in std_logic;
        Op      : out std_logic_vector(3 downto 0)
    );
end ALU_cntrl;

architecture behavior of ALU_cntrl is 
    begin 
        process(ALUOp0, ALUOp1, func) begin 
            if (ALUOp1 = '0') then
                if (ALUOp0 = '0') then 
                    Op <= "0010";                       --Adressberechnung bei sw/lw
                else 
                    Op <= "0110";                       --zwei Zahlen auf Gleichheit prüfen bei beq
                end if;    
            else
                if (func(3 downto 0) = "0000") then 
                    Op <= "0010";                       --add 
                elsif(func(3 downto 0) = "0010") then 
					Op <= "0110";                       --sub
                elsif(func(3 downto 0) = "0100") then 
					Op <= "0000";                       --and
                elsif(func(3 downto 0) = "0101") then 
					Op <= "0001";                       --or
                elsif(func(3 downto 0) = "1010") then 
					Op <= "1100";                       --nor
                end if;
            end if;
        end process;
end behavior;




