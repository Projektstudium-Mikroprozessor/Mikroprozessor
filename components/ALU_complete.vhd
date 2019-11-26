library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_complete is 
    port (
        daten1          : in std_logic;
        daten2          : in std_logic;
        vz_erweiterung  : in std_logic_vector(31 downto 0);
        func            : in std_logic_vector(5 downto 0);
        zero            : out std_logic;
        erg             : out std_logic_vector(31 downto 0)
    ); 
end ALU_complete;