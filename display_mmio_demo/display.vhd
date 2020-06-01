LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;


ENTITY display IS 
	PORT (	
		in_bits	  : IN  std_logic_vector(31 DOWNTO 0);
		out_hex    : OUT std_logic_vector(31 DOWNTO 0)
	);
END display;


ARCHITECTURE display_behav OF display IS      
BEGIN
   p1 : PROCESS (in_bits)
	variable num : integer :=0;
	variable d3 : integer :=0;
	variable d2 : integer :=0;
	variable d1 : integer :=0;
	variable d0 : integer :=0;	
	BEGIN
		
		num := to_integer(unsigned(in_bits));
		
		d0 := num mod 10;
		num := num / 10;
		d1 := num mod 10;
		num := num / 10;
		d2 := num mod 10;
		num := num / 10;
		d3 := num mod 10;
		
		CASE d0 IS
			WHEN 0 => out_hex(7 DOWNTO 0) <= "11000000";
			WHEN 1 => out_hex(7 DOWNTO 0) <= "11111001";
			WHEN 2 => out_hex(7 DOWNTO 0) <= "10100100";
			WHEN 3 => out_hex(7 DOWNTO 0) <= "10110000";
			WHEN 4 => out_hex(7 DOWNTO 0) <= "10011001";
			WHEN 5 => out_hex(7 DOWNTO 0) <= "10010010";
			WHEN 6 => out_hex(7 DOWNTO 0) <= "10000010";
			WHEN 7 => out_hex(7 DOWNTO 0) <= "11111000";
			WHEN 8 => out_hex(7 DOWNTO 0) <= "10000000";
			WHEN 9 => out_hex(7 DOWNTO 0) <= "10010000";
			WHEN OTHERS => out_hex(7 DOWNTO 0) <= "11111111";
		END CASE;
		
		CASE d1 IS
			WHEN 0 => out_hex(15 DOWNTO 8) <= "11000000";
			WHEN 1 => out_hex(15 DOWNTO 8) <= "11111001";
			WHEN 2 => out_hex(15 DOWNTO 8) <= "10100100";
			WHEN 3 => out_hex(15 DOWNTO 8) <= "10110000";
			WHEN 4 => out_hex(15 DOWNTO 8) <= "10011001";
			WHEN 5 => out_hex(15 DOWNTO 8) <= "10010010";
			WHEN 6 => out_hex(15 DOWNTO 8) <= "10000010";
			WHEN 7 => out_hex(15 DOWNTO 8) <= "11111000";
			WHEN 8 => out_hex(15 DOWNTO 8) <= "10000000";
			WHEN 9 => out_hex(15 DOWNTO 8) <= "10010000";
			WHEN OTHERS => out_hex(15 DOWNTO 8) <= "11111111";
		END CASE;
		
		CASE d2 IS
			WHEN 0 => out_hex(23 DOWNTO 16) <= "11000000";
			WHEN 1 => out_hex(23 DOWNTO 16) <= "11111001";
			WHEN 2 => out_hex(23 DOWNTO 16) <= "10100100";
			WHEN 3 => out_hex(23 DOWNTO 16) <= "10110000";
			WHEN 4 => out_hex(23 DOWNTO 16) <= "10011001";
			WHEN 5 => out_hex(23 DOWNTO 16) <= "10010010";
			WHEN 6 => out_hex(23 DOWNTO 16) <= "10000010";
			WHEN 7 => out_hex(23 DOWNTO 16) <= "11111000";
			WHEN 8 => out_hex(23 DOWNTO 16) <= "10000000";
			WHEN 9 => out_hex(23 DOWNTO 16) <= "10010000";
			WHEN OTHERS => out_hex(23 DOWNTO 16) <= "11111111";
		END CASE;
		
		CASE d3 IS
			WHEN 0 => out_hex(31 DOWNTO 24) <= "11000000";
			WHEN 1 => out_hex(31 DOWNTO 24) <= "11111001";
			WHEN 2 => out_hex(31 DOWNTO 24) <= "10100100";
			WHEN 3 => out_hex(31 DOWNTO 24) <= "10110000";
			WHEN 4 => out_hex(31 DOWNTO 24) <= "10011001";
			WHEN 5 => out_hex(31 DOWNTO 24) <= "10010010";
			WHEN 6 => out_hex(31 DOWNTO 24) <= "10000010";
			WHEN 7 => out_hex(31 DOWNTO 24) <= "11111000";
			WHEN 8 => out_hex(31 DOWNTO 24) <= "10000000";
			WHEN 9 => out_hex(31 DOWNTO 24) <= "10010000";
			WHEN OTHERS => out_hex(31 DOWNTO 24) <= "11111111";
		END CASE;
	END PROCESS p1;

END display_behav;