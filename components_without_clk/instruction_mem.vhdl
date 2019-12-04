library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_mem is
    port (
        i_addr : in std_logic_vector(31 downto 0); -- incomming programmcounter

	instruction : out std_logic_vector(31 downto 0) -- outgoing machinecode
    );
end entity instruction_mem;

architecture instruction_behav of instruction_mem is
    -- subtype memory of length word/byte
    subtype mem_word is std_logic_vector(7 downto 0);
    -- type storage defined as array of Bytes
    type storage is array(0 to 1023) of mem_word;
    -- initialize mem of type storage
    signal mem : storage := (7 => (others => '1'),others => (others => '0'));
begin
    process(i_addr)
	variable idx : integer := 0;	-- index as integer
	variable ir : std_logic_vector(31 downto 0);	-- buffer for instruction
    begin
        idx := to_integer(unsigned(i_addr));	-- get index

	ir(31 downto 24) := mem(idx);		-- iterate through next 4 Bytes to get instruction
	ir(23 downto 16) := mem(idx+1);
	ir(15 downto 8) := mem(idx+2);
	ir(7 downto 0) := mem(idx+3);

	instruction <= ir;
    end process;    
end instruction_behav;