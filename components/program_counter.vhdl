library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity program_counter is
    port (
        clk : in std_logic;                                 -- clk_signal
        Branch : in std_logic;                              -- Branch_signal from CTRL_Unit
        Zero : in std_logic;                                -- Zero Flag from ALU
        Offset : in std_logic_vector(15 downto 0);          -- last 16 Instruction-Bits
        
        pc : out std_logic_vector(31 downto 0)              -- next pc
	);
end entity program_counter;

architecture pc_behav of program_counter is
    signal pc_out : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk)
        variable Offset_internal : integer := 0;		-- Offset converted to int
        variable pc_internal : integer := 0;			-- outgoing pc as int
    begin
	if rising_edge(clk) then
            pc_out <= std_logic_vector(unsigned(pc_out) + 4);   -- next instruction

            if (Branch='1' and Zero='1') then
                Offset_internal := to_integer(signed(Offset)) * 4; 	-- convert offset to int and multiply by 4 for bitshift
 		
       	        pc_internal := to_integer(unsigned(pc_out)) + Offset_internal;	-- add offset to pc

    	        --assert pc_out > 0 report "Negative Programmcounter Value is not allowed" severity error;

                pc_out <= std_logic_vector(to_unsigned(pc_internal, pc_out'length));   -- reconvert to std_logic_vector
	    
	    end if;            
	end if;

	pc <= pc_out;
    end process;    
end pc_behav;
