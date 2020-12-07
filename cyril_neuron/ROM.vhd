LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.general_package.ALL;

ENTITY ROM IS
    PORT (
        address : IN STD_LOGIC_VECTOR(ADDRESS_WIDTH - 1 DOWNTO 0);
        result : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE behavior OF ROM IS
    SIGNAL content : N_BUS;
BEGIN

    -- Hardcode ROM with w(i) = i
    MEMORY :
    FOR w IN N_UNITS - 1 DOWNTO 0 GENERATE
        content(w) <= STD_LOGIC_VECTOR(shift_left(to_signed(w, N_BITS), N_FLOAT));
    END GENERATE;

    result <= content(to_integer(unsigned(address)));

END behavior;