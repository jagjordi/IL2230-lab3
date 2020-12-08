library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

-- The MAC (Multipply ACcumulate) component performs a very simple
-- arithmetic operation:
-- output = mult1 * mult2 + accumulate
entity MAC is

  port (
    --! Input multiplication 1
    mult1      : in  signed(DATA_WIDTH-1 downto 0);
    --! Input multiplication 2
    mult2      : in  signed(DATA_WIDTH-1 downto 0);
    --! Accumulate input
    accumulate : in  signed(DATA_WIDTH-1 downto 0);
    --! Output result
    result     : out signed(DATA_WIDTH-1 downto 0));

end entity MAC;

architecture behaviour of MAC is
  signal temp_mult_result : signed(2*DATA_WIDTH - 1 downto 0);
  signal temp_add_result  : signed(DATA_WIDTH downto 0);
begin

  --! Multiply the inputs without the sign and store in temp
  
  --temp_mult_result <= mult1 * mult2;

  --! Assign output value, we want to keep the significand digits. In a number Qm.n we ignore the n LSB and m MSB, that
  --! is (2*DATA_WIDTH-m-1 downto n), since m=DATA_WIDTH-FRACTIONAL_BITS it gives:
  
  --result <= accumulate + temp_mult_result(DATA_WIDTH+FRACTIONAL_BITS-1 downto FRACTIONAL_BITS);

  result <= accumulate + mult1;
  

end behaviour;
