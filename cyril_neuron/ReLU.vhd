LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

-- ReLU
ENTITY ReLU IS
    PORT (
        data_in : IN STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE rtl OF ReLu IS
BEGIN
    comb :
    PROCESS (data_in)
    BEGIN
        IF (data_in(N_BITS - 1) = '1') THEN
            data_out <= (OTHERS => '0');
        ELSE
            data_out <= data_in;
        END IF;
    END PROCESS;

END rtl;