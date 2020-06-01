LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

ENTITY arithmetic_logic_unit IS
	PORT (
		-- inputs
		reg_1, reg_2, imm: IN std_logic_vector(31 DOWNTO 0);

		-- outputs
		res: OUT std_logic_vector(31 DOWNTO 0);

		-- control signals
		op: IN std_logic_vector(2 DOWNTO 0);
		reg_imm, a_inv, b_neg: IN std_logic;

		-- flags
		zero: OUT std_logic
	);
END arithmetic_logic_unit;

ARCHITECTURE behavioural OF arithmetic_logic_unit IS

	SIGNAL ret: std_logic_vector(31 DOWNTO 0); 

BEGIN
	PROCESS (reg_1, reg_2, imm, reg_imm, op, a_inv, b_neg)

		SUBTYPE operation IS std_logic_vector(4 DOWNTO 0);
		VARIABLE a, b: std_logic_vector(31 DOWNTO 0);

	BEGIN
		a := reg_1;
		b := imm WHEN reg_imm = '1' ELSE reg_2;

		CASE operation'(op & a_inv & b_neg) IS
			-- logic
			WHEN "00000" => ret <= a AND b; 	-- OP: 000 - AND
			WHEN "00011" => ret <= NOT (a OR b); 	-- Invert inputs - NOR
			WHEN "00100" => ret <= a OR b; 		-- OP: 001 - OR
			WHEN "00111" => ret <= NOT (a AND b);	-- Invert inputs - NAND
			
			-- arithmetic
			WHEN "01000" => ret <= a + b; 		-- OP: 010 - ADD
			WHEN "01001" => ret <= a - b; 		-- Negate B - SUB

			-- shifts
			WHEN "10000" => ret <= std_logic_vector(to_unsigned(to_integer(unsigned(a)) * 2**to_integer(unsigned(b)), ret'length));	-- OP: 100 - SHL
			WHEN "11000" => ret <= std_logic_vector(to_unsigned(to_integer(unsigned(a)) / 2**to_integer(unsigned(b)), ret'length));	-- OP: 110 - SLR 
			WHEN "11100" => ret <= std_logic_vector(to_signed(to_integer(signed(a)) / 2**to_integer(unsigned(b)), ret'length));	-- OP: 111 - SAR 

			-- default
			WHEN OTHERS => ret <= (OTHERS => '0'); 	-- Nothing
		END CASE;
	END PROCESS;

	res <= ret;
	zero <= '1' WHEN ret = 0 ELSE '0';
END behavioural;