library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_mem is
    port (
	clk 	 : in std_logic;
        MemRW    : in std_logic;
	Mem2Reg  : in std_logic;
	alu_out  : in std_logic_vector(31 downto 0);
	data_in  : in std_logic_vector(31 downto 0);
	
	data_out : out std_logic_vector(31 downto 0)
    );
end entity data_mem;

architecture data_mem_behav of data_mem is
    -- subtype mem_word of length word/byte
    subtype mem_word is std_logic_vector(7 downto 0);
    -- type storage defined as array of Bytes
    type storage is array(0 to 2**20) of mem_word;
    -- initialize mem of type storage
    signal mem : storage := (
	0 => (others => '1'),
	2 => (others => '1'),
	others => (others => '0'));
begin
    process(clk, Mem2Reg, MemRW, alu_out, data_in)
	variable idx  : integer := 0;	-- index as integer
	variable data : std_logic_vector(31 downto 0);	-- buffer for selected data
    begin
	idx := to_integer(unsigned(alu_out));	-- get index
	
	data := alu_out;
	
	if(Mem2Reg = '0') then	   
            data(31 downto 24) := mem(idx);	-- iterate through next 4 Bytes to get 32-Bit Data
	    data(23 downto 16) := mem(idx+1);
	    data(15 downto 8)  := mem(idx+2);
	    data(7 downto 0)   := mem(idx+3);
	end if;
	
	if (clk'event and clk='0') then
	    if (MemRW = '1') then	-- if memory set into write mode
	        mem(idx)   <= data_in(31 downto 24);	-- save data over next 4 Bytes
	        mem(idx+1) <= data_in(23 downto 16);
	        mem(idx+2) <= data_in(15 downto 8);
	        mem(idx+3) <= data_in(7 downto 0);
	    end if;
	end if;

	data_out <= data;
    end process;    
end data_mem_behav;