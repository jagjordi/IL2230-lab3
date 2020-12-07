LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE WORK.MY_PACKAGE.ALL;
USE WORK.ALL;

ENTITY top IS
	PORT
	(
		CLK:IN STD_LOGIC;
		OUTPUT:OUT output_type
	);
END ENTITY;

ARCHITECTURE TOP_1 OF TOP IS
	COMPONENT SEMI_PARALLEL 
		PORT
		(
			X:IN input_array;
			W:IN weight_array;
			b:in input_type;
			CLK:IN STD_LOGIC;
			OUTPUT:OUT output_type
		);
	END COMPONENT;
	COMPONENT SERIAL_PARALLEL 
	PORT
	(
		X:IN input_array;
		Y:IN weight_array;
		b:in input_type;
		CLK:IN STD_LOGIC;
		OUTPUT:OUT output_type
	);
    END COMPONENT;
	COMPONENT FULLY_PARALLEL 
	PORT
	(
		X:IN input_array;
		Y:IN weight_array;
		b:in input_type;
		CLK:IN STD_LOGIC;
		OUTPUT:OUT output_type
	);
	END COMPONENT;
	COMPONENT fake_ram 
		PORT
		(
			X:out input_array;
			Y:out weight_array;
			b:out input_type
		);
	END COMPONENT;
	signal X_1: input_array;
	signal W_1: weight_array;
	SIGNAL b_1: input_type;
	--signal OUTPUT_1: output_type;
	BEGIN
		-- SEMI_PARALLEL_1: SEMI_PARALLEL
		-- PORT MAP
		-- (
			-- X=>X_1,
			-- W=>W_1,
			-- b=>b_1,
			-- CLK=>CLK,
			-- OUTPUT=>OUTPUT
		-- );
		 FULLY_PARALLEL_1: FULLY_PARALLEL 
		 PORT MAP
		 (
			 X=>X_1,
			 y=>W_1,
			 b=>b_1,
			 CLK=>CLK,
			 OUTPUT=>OUTPUT
		 );
		--SERIAL_PARALLEL_1:SERIAL_PARALLEL
		--PORT MAP
		--(
			--X => X_1,
			--Y => W_1,
			--b => b_1,
			--CLK => CLK,
			--OUTPUT => OUTPUT
		--);
		fake_ram_1: fake_ram
		PORT MAP
		(
			X=>X_1,
			Y=>W_1,
			b=>b_1
		);
end architecture;
		
		
		
		
