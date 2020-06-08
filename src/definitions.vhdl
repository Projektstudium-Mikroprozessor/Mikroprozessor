LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.ALL;

PACKAGE definitions IS

	-- 32 bit words
	SUBTYPE word IS std_logic_vector(31 DOWNTO 0);

	-- 32 registers
	SUBTYPE reg_addr IS std_logic_vector(4 DOWNTO 0);

	-- basic ops: 00 address calc, 01 compare, 10 alu ops
	SUBTYPE basic_operation IS std_logic_vector(1 DOWNTO 0);

	-- alu op (3 bits), invert first operand, negate second operand
	-- alu ops : 000 and, 001 or, 010 add, 100 shl, 110, slr, 111 sar
	SUBTYPE operation IS std_logic_vector(4 DOWNTO 0);

END PACKAGE definitions;