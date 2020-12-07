LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;

PACKAGE MY_PACKAGE IS
	constant N:integer:=2;
	constant K:integer:=2;
	constant input_len:integer:=16;
	constant weight_len:integer:=16;
	constant output_len:integer:=16;
	constant mid_output_len:integer:=32;
	--constant input_len:integer:=32;
	-- constant input_len_int: integer := 12;
	-- constant input_len_fra: integer := 20;
	--constant output_len:integer:=8;
	--constant output_len_int: integer := 3;
	--constant output_len_fra: integer := 5;
	--constant weight_len:integer :=16;
	-- constant weight_len_int:integer := 6;
	--constant weight_len_fra:integer := 10;
	--constant mid_output_len:integer :=48;
	--constant mid_output_len_int:integer := 18;
	--constant mid_output_len_fra:integer := 30;
	subtype input_type is signed(input_len-1 downto 0);
	subtype weight_type is signed (weight_len-1 downto 0);
	subtype output_type is signed (output_len-1 downto 0);
	subtype mid_output_type is signed(mid_output_len-1 downto 0);
	type input_array is array(1 TO N) of input_type;
	type weight_array is array(1 TO N) of weight_type;
	type output_array is array(0 TO N) of output_type;
	type mid_output_array is array(0 TO N) of mid_output_type;
	
END PACKAGE;

LIBRARY IEEE;
USE WORK.MY_PACKAGE.all;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
package func is
	function data_generate_input(len:integer)
	return input_array;
	function data_generate_weight(len:integer)
	return weight_array;
end package;

package body func is
	function data_generate_input(len:integer)
	return input_array is
	variable i: integer;
	variable X:input_array;
	begin 
		for i in 1 to N loop
			X(i):=(18=>'1',others=>'0');
		end loop;
	return X;
	end function;
	
	function data_generate_weight(len:integer)
	return weight_array is
	variable i: integer;
	variable W:weight_array;
	begin 
		for i in 1 to N loop
			W(i):=(10=>'1',others=>'0');
		end loop;
	return W;
	end function;
end package body;
		









		
