LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.general_package.ALL;

ENTITY MAC IS
    PORT (
        a, b, c : IN STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0);
        mout : OUT STD_LOGIC_VECTOR(N_BITS - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behavior OF MAC IS
    SIGNAL sa, sb, sc, scont : signed(N_BITS - 1 DOWNTO 0);
    SIGNAL smul : signed((2 * N_BITS) - 1 DOWNTO 0);

BEGIN
    sa <= signed(a);
    sb <= signed(b);
    sc <= signed(c);
    smul <= (sa * sb);
    scont(N_FLOAT - 1 DOWNTO 0) <= smul((N_FLOAT * 2) - 1 DOWNTO N_FLOAT);
    scont(N_BITS - 1 DOWNTO N_FLOAT) <= smul((N_FLOAT * 2) + (N_BITS - N_FLOAT) - 1 DOWNTO (N_FLOAT * 2));
    mout <= STD_LOGIC_VECTOR(scont + sc);
END behavior;