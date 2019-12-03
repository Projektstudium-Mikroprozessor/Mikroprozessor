library IEEE;
use IEEE.std_logic_1164.all;

entity mux is
    port (
        e0,e1 : in std_logic_vector(31 downto 0);   -- input
        s : in std_logic;                           -- steuerungs vector
        a : out std_logic_vector(31 downto 0)       -- output
    );
end mux;

architecture mux_behav of mux is
begin
    process(e0,e1,s)
    begin
            case s is                                   -- output mapping
                when '0' => a <= e0;
                when others => a <= e1;
            end case;
    end process;
end mux_behav;