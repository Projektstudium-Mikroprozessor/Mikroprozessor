LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY control_unit IS
	PORT (
		-- inputs
		opcode: IN std_logic_vector(5 DOWNTO 0);
		
		-- outputs
		branch_zero: OUT std_logic;			-- program counter
		reg_rw, mem_res: OUT std_logic;			-- registers
		reg_imm: OUT std_logic;				-- ALU
		op: OUT std_logic_vector(1 DOWNTO 0);		
		mem_rw: OUT std_logic				-- Memory
	);
END control_unit;

ARCHITECTURE behavioural OF control_unit IS
BEGIN
	PROCESS (opcode)
	BEGIN
		-- bit 0: ls, 1: ls, 2: branch, 3: store, 4: -, 5: mem
		IF (opcode = "000000") THEN		-- arithmetic / logic
			branch_zero <= '0';
			reg_rw <= '1';
			mem_res <= '1';
			reg_imm <= '0';
			op <= "10";
			mem_rw <= '0';
		ELSIF (opcode = "000011") THEN		-- load immediate
			branch_zero <= '0';
			reg_rw <= '1';
			mem_res <= '1';
			reg_imm <= '1';
			op <= "00";
			mem_rw <= '0';
		ELSIF (opcode = "100011") THEN		-- load
			branch_zero <= '0';
			reg_rw <= '1';
			mem_res <= '0';
			reg_imm <= '1';
			op <= "00";
			mem_rw <= '0';
		ELSIF (opcode = "101011") THEN		-- store
			branch_zero <= '0';
			reg_rw <= '0';
			mem_res <= '0';
			reg_imm <= '1';
			op <= "00";
			mem_rw <= '1';
		ELSIF (opcode = "000100") THEN		-- branch equal
			branch_zero <= '1';
			reg_rw <= '0';
			mem_res <= '0';
			reg_imm <= '0';
			op <= "01";
			mem_rw <= '0';
		ELSE					-- default
			branch_zero <= '0';
			reg_rw <= '0';
			mem_res <= '0';
			reg_imm <= '0';
			op <= "00";
			mem_rw <= '0';
		END IF;
	END PROCESS;
END behavioural;