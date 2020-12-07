LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY ReLU_fcn is
	PORT
	(
		INPUT:IN output_type;
		OUTPUT:OUT output_type
	);
end entity;

ARCHITECTURE ReLU_fcn_1 of ReLU_fcn is
	BEGIN
		OUTPUT <= INPUT WHEN INPUT > 0 ELSE (OTHERS => '0');
end architecture;
