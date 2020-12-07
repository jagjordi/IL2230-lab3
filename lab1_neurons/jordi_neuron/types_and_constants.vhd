library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

-- note: keep the file without indentation to change it with sed
package types_and_constants is

constant DATA_DEPTH : integer := 128;
constant DATA_WIDTH : integer := 32;
constant FRACTIONAL_BITS : integer := 20;

constant INTEGER_BITS : integer := DATA_WIDTH - FRACTIONAL_BITS;

type data_in_type is array (0 to DATA_DEPTH-1) of signed (DATA_WIDTH-1 downto 0);

end package;
