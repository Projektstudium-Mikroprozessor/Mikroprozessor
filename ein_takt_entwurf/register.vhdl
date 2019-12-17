library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg is 
    port (
        -- inputs
	clk	    : in std_logic;
        mem_write   : in std_logic;
        data_in     : in std_logic_vector(31 downto 0);
        read_addr1  : in std_logic_vector(4 downto 0);
        read_addr2  : in std_logic_vector(4 downto 0);
        addr3       : in std_logic_vector(4 downto 0);
        reg_dst     : in std_logic;
        -- outputs
        data_out1   : out std_logic_vector(31 downto 0);        
        data_out2   : out std_logic_vector(31 downto 0)
    );
end entity reg;

architecture reg_behav of reg is
    -- subtype fuer einzelnes register
    subtype regi is std_logic_vector(31 downto 0);
    -- type fuer registersatz  
    type regi_collection is array(0 to 31) of regi;
    -- signal mit typ registersatz erstellen
    signal regis : regi_collection := (
	1 => (0 => '1', others => '0'),
	2 => (1 => '1', others => '0'),
	others=> (others =>'0'));

    begin
        process(clk) 
	variable idx : std_logic_vector(4 downto 0);
	begin
	    if (clk'event and clk = '0') then
                if reg_dst = '0' then
                    idx := read_addr2;
                else 
                    idx := addr3;
                end if;

            	if(mem_write = '1') then
                    -- in Register, mit Adresse == Index im Vektor, schreiben
                    regis(to_integer(unsigned(idx))) <= data_in;
                end if;
	    end if;
        end process;
        
        -- immer Daten rausschreiben
        process(mem_write, read_addr1, read_addr2) begin
            data_out1 <= regis(to_integer(unsigned(read_addr1)));
            data_out2 <= regis(to_integer(unsigned(read_addr2)));
        end process;
           
end reg_behav;
