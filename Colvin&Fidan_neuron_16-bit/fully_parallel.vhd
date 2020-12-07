LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.ALL;
USE WORK.MY_PACKAGE.ALL;

ENTITY FULLY_PARALLEL IS
	PORT
	(
		X:IN input_array;
		Y:IN weight_array;
		b:in input_type;
		CLK:IN STD_LOGIC;
		OUTPUT:OUT output_type
	);
END ENTITY;

ARCHITECTURE FULLY_1 OF FULLY_PARALLEL IS
	SIGNAL i:integer;
	signal zero: mid_output_type:=(others=>'0');
	signal one: weight_type:=(5 => '1',others => '0');
	signal mid_output_array_1: mid_output_array;
	signal mid_output_temp: mid_output_type;
	signal output_1,output_2: output_type;
	COMPONENT MAC
	PORT
	(
		a:in input_type;
		b:in weight_type;
		c:in mid_output_type;
		output:out mid_output_type
	);
	END COMPONENT;
	COMPONENT ReLU_fcn
	PORT
	(
		INPUT:IN output_type;
		OUTPUT:OUT output_type
	);
	end component;
	BEGIN
		MAC0:MAC
		PORT MAP
		(
			a=>b,
			b=>one,
			c=>zero,
			output=>mid_output_array_1(0)
		);
		MACX:
		FOR I IN 1 TO N GENERATE
		MACXX:MAC
		PORT MAP
		(
			a=>X(I),
			b=>Y(I),
			c=>mid_output_array_1(I-1),
			output=>mid_output_array_1(I)
		);
		end generate;
		PROCESS(CLK)
			BEGIN
			IF RISING_EDGE(CLK) THEN
				mid_output_temp<=mid_output_array_1(N);
			END IF;
		END PROCESS;
		OUTPUT_2(output_len-1) <=mid_output_temp(mid_output_len-1);
		OUTPUT_2(output_len-2 downto 0) <= mid_output_temp(11 downto 5);
		ReLU_fcn_1: ReLU_fcn
		port map
		(
			input=>output_2,
			output=>output_1
		);
		PROCESS(CLK)
			BEGIN
			IF RISING_EDGE(CLK) THEN
				output<=output_1;
			END IF;
		END PROCESS;
		
	
END ARCHITECTURE;
