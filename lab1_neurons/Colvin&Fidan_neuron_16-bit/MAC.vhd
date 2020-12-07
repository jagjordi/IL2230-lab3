LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.MY_PACKAGE.ALL;


ENTITY MAC IS 
	PORT
	(
		a:in input_type;
		b:in weight_type;
		c:in mid_output_type;
		output:out mid_output_type
	);
END ENTITY;

ARCHITECTURE MAC_1 OF MAC IS 
	BEGIN
		output<= a * b+ c;
END ARCHITECTURE;

