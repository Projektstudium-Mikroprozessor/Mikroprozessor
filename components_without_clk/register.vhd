library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg is 
    port (
        -- inputs
        mem_write   : in std_logic;
        data_in     : in std_logic_vector(31 downto 0);
        read_addr1  : in std_logic_vector(4 downto 0);
        read_addr2  : in std_logic_vector(4 downto 0);
        write_addr  : in std_logic_vector(4 downto 0);
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
    signal regis : regi_collection := (others=> (others =>'0'));

    begin
       
        process(mem_write, data_in, write_addr) begin
            if(mem_write = '1') then
                -- in Register, mit Adresse == Index im Vektor, schreiben
                regis(to_integer(unsigned(write_addr))) <= data_in;
            end if;
        end process;
        
        -- immer Daten rausschreiben
        process(mem_write, read_addr1, read_addr2) begin
            data_out1 <= regis(to_integer(unsigned(read_addr1)));
            data_out2 <= regis(to_integer(unsigned(read_addr2)));
        end process;
           
end reg_behav;
