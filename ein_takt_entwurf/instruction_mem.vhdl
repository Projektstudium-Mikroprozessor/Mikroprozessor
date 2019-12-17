library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;

entity instruction_mem is
    port (
        i_addr : in std_logic_vector(31 downto 0); -- incomming programmcounter

	instruction : out std_logic_vector(31 downto 0) -- outgoing machinecode
    );
end entity instruction_mem;

architecture instruction_behav of instruction_mem is
    -- subtype mem_word of length word/byte
    subtype mem_word is std_logic_vector(7 downto 0);
    -- type storage defined as array of Bytes
    type storage is array(0 to 2**20) of mem_word;

    impure function init_instruction_mem return storage is
	file text_file       : text;
	variable text_line   : line;
	variable machinecode : std_logic_vector(31 downto 0);
	variable mem_content : storage := (others => (others => '0'));
	variable i           : integer := 0;
    begin
	file_open(text_file, "C:\Massenspeicher\Studium\Semester 5\Projekt Chipdesign\Chipdesign\fibonacci_instructions.txt", read_mode);
	while not endfile(text_file) loop
	    readline(text_file, text_line);
	    read(text_line, machinecode);
	    mem_content(i)   := machinecode(31 downto 24);
	    mem_content(i+1) := machinecode(23 downto 16);
	    mem_content(i+2) := machinecode(15 downto 8);
	    mem_content(i+3) := machinecode(7 downto 0);
	    i := i+4;
	end loop;

	return mem_content;
    end function;

    -- initialize mem of type storage
    signal mem : storage := init_instruction_mem;
begin
    process(i_addr)	-- trigger on incomming pc
	variable idx : integer := 0;	-- index as integer
	variable i_buffer : std_logic_vector(31 downto 0);	-- buffer for instruction
    begin
        idx := to_integer(unsigned(i_addr));	-- get index

	i_buffer(31 downto 24) := mem(idx);		-- iterate through next 4 Bytes to get instruction
	i_buffer(23 downto 16) := mem(idx+1);
	i_buffer(15 downto 8) := mem(idx+2);
	i_buffer(7 downto 0) := mem(idx+3);

	instruction <= i_buffer;
    end process;    
end instruction_behav;