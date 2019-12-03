library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_tb is 
end entity reg_tb;

architecture reg_tb_behav of reg_tb is
	
    Signal mem_write   : std_logic :='0';
    signal data_in     : std_logic_vector(31 downto 0);
	-- aus welchem Register lesen (2**5 Register)
    signal read_addr1  : std_logic_vector(4 downto 0);
    signal read_addr2  : std_logic_vector(4 downto 0);
	-- in welches Register schreiben
    signal write_addr  : std_logic_vector(4 downto 0);
	-- Ausgang der gelesenen Daten, bei schreiben steht hier quatsch
    Signal data_out1   : std_logic_vector(31 downto 0);        
    Signal data_out2   : std_logic_vector(31 downto 0);
    	-- Konstanten
    constant half_period   : time := 4 ns /2;
    constant wait_time     : time := 10 ns;

    component reg is
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
    end component reg;

begin
    reg_INST : reg port map(
        mem_write=>mem_write,
        data_in=>data_in,
        read_addr1=>read_addr1,
        read_addr2=>read_addr2,
        write_addr=>write_addr,
        data_out1=>data_out1,
        data_out2=>data_out2
    );

    process is
        begin
            mem_write <= '1';
            data_in <= (1 =>'1', others=>'0');
            read_addr1 <= (others=>'0');
            read_addr2 <= (others=>'0');
            write_addr <= (0=>'1',others=>'0');
            wait for wait_time;
            
            mem_write <= '0';
            read_addr1 <= (0=>'1', others=>'0');
            read_addr2 <= (0=>'1', others=>'0');
            wait for wait_time;
    end process;
end reg_tb_behav;