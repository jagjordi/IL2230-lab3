LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.ALL;
USE WORK.MY_PACKAGE.ALL;
USE WORK.func.all;

entity fake_ram is
	PORT
	(
		X:out input_array;
		Y:out weight_array;
		b:out input_type
	);
END ENTITY;

architecture fake_ram_1 of fake_ram is
	begin
		X<=data_generate_input(input_len);
		Y<=data_generate_weight(weight_len);
		b<=(5=>'1',others=>'0');
end architecture;
