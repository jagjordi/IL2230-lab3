LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

ENTITY top IS
    PORT (
        SIGNAL clk, enable, n_rst : IN STD_LOGIC;
        SIGNAL result : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
        SIGNAL processing : OUT STD_LOGIC
    );
END top;

ARCHITECTURE rtl OF top IS
    SIGNAL pre_result : STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
BEGIN
    
    -- Instanciate the layer and its controller
    parallel : ENTITY work.parallel PORT MAP (clk, enable, n_rst, pre_result, processing);

    -- Instanciate a relu
    relu : ENTITY work.ReLU PORT MAP (pre_result, result);

END rtl;