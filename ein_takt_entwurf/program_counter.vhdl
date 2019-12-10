library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity program_counter is
    port (
        clk    : in std_logic;  -- clk_signal
        Branch : in std_logic;  -- Branch_signal from CTRL_Unit
        Zero   : in std_logic;  -- Zero Flag from ALU
        offset : in std_logic_vector(31 downto 0);
        
        pc     : out std_logic_vector(31 downto 0) -- next pc
	);
end entity program_counter;

architecture pc_behav of program_counter is
begin
    process(clk)
	variable pc_internal     : integer := -4; -- outgoing pc as int
    begin
	if (clk'event and clk='1') then
            pc_internal := pc_internal + 4;	-- next instruction

            if (Branch='1' and Zero='1') then

       	        pc_internal := pc_internal + (to_integer(signed(offset)*4)); -- add offset to pc
	    
	    end if;

	    pc <= std_logic_vector(to_unsigned(pc_internal, pc'length)); -- reconvert to std_logic_vector
	end if;
    end process;    
end pc_behav;
