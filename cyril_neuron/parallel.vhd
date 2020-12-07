LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

USE ieee.math_real.ceil;

-- Entity containing the layers of the perceptron
ENTITY parallel IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        n_rst : IN STD_LOGIC;
        loads_out : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0); -- Output calculation
        is_processing_out : OUT STD_LOGIC -- Telling that result are available
    );

END ENTITY;

ARCHITECTURE rtl OF parallel IS
    SIGNAL weights, values : K_BUS; -- K registers for the weights
    SIGNAL addr_counter, next_addr_counter : STD_LOGIC_VECTOR(ADDRESS_WIDTH - 1 DOWNTO 0); -- Counter for rom fetching
    SIGNAL rom_result, rom_result_2 : STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
    SIGNAL reset_sum : STD_LOGIC;

    TYPE State_type IS (FETCHING, PROCESSING, IDLE); -- Define the states for weights fetching and processing time
    SIGNAL state : State_Type;
    SIGNAL is_processing : STD_LOGIC;
BEGIN

    -- Instanciate ROM weights
    ROM : ENTITY work.rom PORT MAP (addr_counter, rom_result);

    -- Instanciate ROM values
    ROM_values : ENTITY work.rom PORT MAP (addr_counter, rom_result_2);

    -- Instanciate MACs layer
    LAYER : ENTITY work.layer PORT MAP (clk, is_processing, reset_sum, weights, values, loads_out);

    PROCESS (clk, n_rst)
    BEGIN
        -- Reset registers
        IF (n_rst = '0') THEN
            weights <= (OTHERS => STD_LOGIC_VECTOR(to_signed(0, N_BITS)));
            values <= (OTHERS => STD_LOGIC_VECTOR(to_signed(0, N_BITS)));
            addr_counter <= STD_LOGIC_VECTOR(to_unsigned(0, ADDRESS_WIDTH));
            state <= IDLE;
        ELSIF (rising_edge(clk)) THEN

            CASE state IS
                WHEN IDLE =>
                    IF (enable = '1') THEN
                        state <= FETCHING;
                    END IF;

                WHEN FETCHING =>
                    -- Update counter and save a new weight
                    addr_counter <= next_addr_counter;
                    -- Since we have K weight registers but N ROM contents we need to slice the addr_counter to keep PARALL_WIDTH (=K) bits
                    weights(to_integer(unsigned(addr_counter(PARALL_WIDTH - 1 DOWNTO 0)))) <= rom_result;
                    values(to_integer(unsigned(addr_counter(PARALL_WIDTH - 1 DOWNTO 0)))) <= rom_result_2;

                    -- If the next state is a multiple of K
                    IF (next_addr_counter(PARALL_WIDTH - 1 DOWNTO 0) = STD_LOGIC_VECTOR(to_unsigned(0, PARALL_WIDTH))) THEN
                        state <= PROCESSING;
                    END IF;

                WHEN PROCESSING =>
                    -- If we calculated all the values
                    IF (addr_counter = STD_LOGIC_VECTOR(to_unsigned(0, ADDRESS_WIDTH))) THEN
                        state <= IDLE;
                    ELSE
                        state <= FETCHING;
                    END IF;

            END CASE;
        END IF;
    END PROCESS;

    -- This signal is used to tell to the layer that it can save the mac results
    -- That is the reason why the 'processing' state exists
    is_processing <= '1' WHEN (state = PROCESSING) ELSE
        '0';

    -- Tell the top layer that results will be ready
    is_processing_out <= '1' WHEN (state = IDLE) ELSE
        '0';

    -- Adder for the addr_counter
    next_addr_counter <= STD_LOGIC_VECTOR(unsigned(addr_counter) + 1);

    -- Reset the temporary sum at the beginning of a new calculus
    reset_sum <= n_rst and (not enable);

END rtl;