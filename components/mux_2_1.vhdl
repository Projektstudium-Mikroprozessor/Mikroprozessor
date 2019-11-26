library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2_1 is
    port (
	    clk : in std_logic;			                -- clk_signal
        e0,e1 : in std_logic_vector(31 downto 0);   -- input
        s : in std_logic;                           -- steuerungs vector
        a : out std_logic_vector(31 downto 0)       -- output
    );
end mux_2_1;

architecture mux_2_1_behav of mux_2_1 is
begin
    process(clk)
    begin
	if rising_edge(clk) then
            case s is                                   -- output mapping
                when '0' => a <= e0;
                when others => a <= e1;
            end case;
	end if;
    end process;
end mux_2_1_behav;