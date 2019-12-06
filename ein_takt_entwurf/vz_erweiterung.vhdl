library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity vz_erweiterung is
    port (
        offset : in std_logic_vector(15 downto 0);

        offset_shifted : out std_logic_vector(31 downto 0)
    );
end entity vz_erweiterung;

architecture behav_vz_erweiterung of vz_erweiterung is
    
begin
    process(offset)
        variable offset_internal : integer := 0;
    begin
        offset_internal := to_integer(signed(offset));
        offset_shifted <= std_logic_vector(to_signed(offset_internal, offset_shifted'length));
    end process;
end architecture behav_vz_erweiterung;