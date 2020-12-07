LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.MY_PACKAGE.ALL;
USE WORK.ALL;

ENTITY SEMI_PARALLEL IS
	PORT
	(
		X:IN input_array;
		W:IN weight_array;
		b:in input_type;
		CLK:IN STD_LOGIC;
		OUTPUT:OUT output_type
	);
END ENTITY;

ARCHITECTURE SEMI_1 OF SEMI_PARALLEL IS

	signal i:integer:=0;
	SIGNAL input_1,input_2: input_type;
	SIGNAL weight_1,weight_2: weight_type;
	SIGNAL mid_output_11,mid_output_12,mid_output_21,mid_output_22: mid_output_type;
	SIGNAL output_1: mid_output_type;
	SIGNAL output_2: output_type;
	
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
		OUTPUT_2(output_len-1) <= OUTPUT_1(mid_output_len-1);
		OUTPUT_2(output_len-2 downto 0) <= OUTPUT_1(24 downto 10);
		MAC_1:MAC
		PORT MAP
		(
			a => input_1,
			b => weight_1,
			c => mid_output_11,
			output => mid_output_12
		);
		MAC_2:MAC
		PORT MAP
		(
			a => input_2,
			b => weight_2,
			c => mid_output_21,
			output => mid_output_22
		);
		ReLU_fcn_1:ReLU_fcn
		PORT MAP
		(
			INPUT => OUTPUT_2,
			OUTPUT => OUTPUT
		);
		PROCESS(CLK)
			BEGIN
				if rising_edge(clk) then
					if i=0 then
						input_1 <= b;
						weight_1 <= (10 => '1',others => '0');
						mid_output_11 <= (others => '0');
						input_2 <= X(N/2+i);
						weight_2 <= w(N/2+i);
						mid_output_21 <= (others => '0');
						i <= i + 1;
					elsif (i>0 and i < N/2) then
						input_1 <= X(i);
						weight_1 <= w(i);
						input_2 <= X(N/2+i);
						weight_2 <= w(N/2+i);
						mid_output_11 <= mid_output_12;
						mid_output_21 <= mid_output_22;
						i <= i + 1;
					elsif i = N/2 then
						input_1 <= (others => '0');
						weight_1 <=(others => '0');
						input_2 <= X(N/2+i);
						weight_2 <= w(N/2+i);
						mid_output_11 <= mid_output_12;
						mid_output_21 <= mid_output_22;
						i <= i + 1;
					elsif i = N/2 + 1 then
						output_1 <= mid_output_12 + mid_output_22;
						i <= i + 1;
					else
					END IF;	
				END IF;	
		END PROCESS;			
		
	
END ARCHITECTURE;










