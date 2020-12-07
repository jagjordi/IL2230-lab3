LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

USE work.general_package.ALL;

-- A LAYER OF K REGISTERS CONTAINING THE INPUT VALUES AND K MACS
ENTITY layer IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        n_rst : IN STD_LOGIC;
        weights : IN K_BUS; -- GIVEN BY ROM
        data_in : IN K_BUS;
        sums_out : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0) -- PARTIAL SUM
    );

END ENTITY;

ARCHITECTURE rtl OF layer IS
    SIGNAL mac_outputs : K_BUS;
    SIGNAL last_sum : STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
BEGIN

    -- Instanciatre MACs
    GEN_MACS :
    FOR k IN 0 TO N_PARALL - 1 GENERATE
        FIRST_MAC :
        IF k = 0 GENERATE
            MACX : ENTITY work.MAC PORT MAP
                (data_in(k), weights(k), last_sum, mac_outputs(k));
        END GENERATE;

        OTHER_MAC :
        IF k > 0 GENERATE
            MACX : ENTITY work.MAC PORT MAP
                (data_in(k), weights(k), mac_outputs(k - 1), mac_outputs(k));
        END GENERATE;
    END GENERATE;

    -- Instanciate K registers for input datas and K for partial sums
    PROCESS (clk, n_rst)
    BEGIN
        -- Reset registers
        IF (n_rst = '0') THEN
            last_sum <= (OTHERS => '0');

        ELSIF (rising_edge(clk)) THEN
            -- Pass input data
            IF (enable = '1') THEN
                last_sum <= mac_outputs(N_PARALL - 1);
            END IF;
        END IF;
    END PROCESS;

    sums_out <= last_sum;

END rtl;