LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY registers IS
	PORT (
		-- control signals
		clk, rw, mem_res, reg_imm: IN std_logic;

		-- inputs
		read_1, read_2, write_reg, write_imm: IN std_logic_vector(4 DOWNTO 0);
		data_mem, data_res: IN std_logic_vector(31 DOWNTO 0);

		-- outputs
		data_1, data_2: OUT std_logic_vector(31 DOWNTO 0)
	);
END registers;

ARCHITECTURE behavioural OF registers IS
BEGIN
	PROCESS (clk, read_1, read_2)

		SUBTYPE writecntrl IS std_logic_vector(1 DOWNTO 0);

		SUBTYPE reg IS std_logic_vector(31 DOWNTO 0);
		TYPE reg_array IS ARRAY(0 TO 31) OF reg;
		VARIABLE values: reg_array;

	BEGIN
		IF (clk'event AND rw = '1') THEN
			CASE writecntrl'(reg_imm & mem_res) IS
				WHEN "00" => values(to_integer(unsigned(write_reg))) := data_mem; -- 3-register-instruction, data from memory
				WHEN "01" => values(to_integer(unsigned(write_reg))) := data_res; -- 3-register-instruction, data from result
				WHEN "10" => values(to_integer(unsigned(write_imm))) := data_mem; -- Immediate-instruction, data from memory
				WHEN "11" => values(to_integer(unsigned(write_imm))) := data_res; -- Immediate-instruction, data from result
				WHEN OTHERS => NULL;
			END CASE;
		END IF;

		data_1 <= (OTHERS => '0') WHEN read_1 = 0 ELSE values(to_integer(unsigned(read_1)));
		data_2 <= (OTHERS => '0') WHEN read_2 = 0 ELSE values(to_integer(unsigned(read_2)));
	END PROCESS;
END behavioural;