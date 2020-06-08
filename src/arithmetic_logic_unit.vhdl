LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;
USE work.definitions.ALL;

ENTITY arithmetic_logic_unit IS
	PORT (
		-- inputs
		reg_1	: IN word; 		-- first register input
		reg_2	: IN word; 		-- second register input
		imm	: IN word; 		-- immediate input

		-- outputs
		res	: OUT word;		-- result

		-- flags
		zero	: OUT std_logic;	-- zero flag (res == 0)

		-- control signals
		op	: IN operation;		-- operation
		reg_imm	: IN std_logic		-- second operand (reg_2 / imm)
	);
END arithmetic_logic_unit;

ARCHITECTURE behavioural OF arithmetic_logic_unit IS

	SIGNAL ret : word;			-- internal result

BEGIN
	PROCESS (reg_1, reg_2, imm, reg_imm, op)

		VARIABLE a : word;		-- first operand
		VARIABLE b : word;		-- first operand

	BEGIN
		a := reg_1;					-- first operand
		b := imm WHEN reg_imm = '1' ELSE reg_2; 	-- second operand

		CASE op IS
			-- logic
			WHEN "00000" => ret <= a AND b; 	-- and
			WHEN "00100" => ret <= a OR b; 		-- or
			WHEN "00011" => ret <= NOT (a OR b); 	-- nor
			WHEN "00111" => ret <= NOT (a AND b);	-- nand
			
			-- arithmetic
			WHEN "01000" => ret <= a + b; 		-- add
			WHEN "01001" => ret <= a - b; 		-- sub

			-- shifts
			WHEN "10000" => ret <= std_logic_vector(to_unsigned(to_integer(unsigned(a)) * 2**to_integer(unsigned(b)), ret'length));	-- shl
			WHEN "11000" => ret <= std_logic_vector(to_unsigned(to_integer(unsigned(a)) / 2**to_integer(unsigned(b)), ret'length));	-- slr
			WHEN "11100" => ret <= std_logic_vector(to_signed(to_integer(signed(a)) / 2**to_integer(unsigned(b)), ret'length));	-- sar

			-- default
			WHEN OTHERS  => ret <= (OTHERS => '0'); -- nothing
		END CASE;
	END PROCESS;

	res <= ret;				-- result
	zero <= '1' WHEN ret = 0 ELSE '0';	-- zero flag
END behavioural;