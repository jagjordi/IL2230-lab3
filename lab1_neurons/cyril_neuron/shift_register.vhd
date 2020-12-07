LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.general_package.ALL;

-- A LAYER OF K REGISTERS CONTAINING THE INPUT VALUES AND K MACS
ENTITY shift_register IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        n_rst : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
        datas_out : OUT K_BUS
    );

END ENTITY;

ARCHITECTURE rtl OF shift_register IS
    SIGNAL content : K_BUS;
BEGIN

    PROCESS (clk, n_rst)
    BEGIN
        -- Reset registers
        IF (n_rst = '0') THEN
            content <= (OTHERS => STD_LOGIC_VECTOR(to_signed(0, N_BITS)));

        ELSIF (rising_edge(clk)) THEN
            -- Pass input data
            IF (enable = '1') THEN
                FOR k IN N_PARALL - 1 DOWNTO 1 LOOP
                    content(k) <= content(k - 1);
                END LOOP;
                content(0) <= data_in;
            END IF;
        END IF;
    END PROCESS;

    datas_out <= content;

END rtl;