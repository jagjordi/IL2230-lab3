library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

-- note: keep the file without indentation to change it with sed
package types_and_constants is

constant DATA_DEPTH : integer := 4;

constant DATA_WIDTH : integer := 8;
constant FRACTIONAL_BITS : integer := 0;
constant INTEGER_BITS : integer := DATA_WIDTH - FRACTIONAL_BITS;

constant NUM_LAYERS : integer := 4;
constant LAYERS_DEPTH : integer := integer(ceil(log2(real(NUM_LAYERS))));

type data_in_type is array (0 to DATA_DEPTH-1) of signed (DATA_WIDTH-1 downto 0);

end package;
