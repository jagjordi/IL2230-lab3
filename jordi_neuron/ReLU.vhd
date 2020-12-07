library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

--! Implementation of ReLU function.
--! output = input if (input > 0) else output = 0
entity ReLU is
  port (
    input  : in  signed(DATA_WIDTH-1 downto 0);
    output : out signed(DATA_WIDTH-1 downto 0));

end entity ReLU;

architecture behaviour of ReLU is

begin  -- architecture behaviour

  -- With CA2 signed numbers if MSB is 1 then number is > 0
  output <= input when (input(DATA_WIDTH-1) = '0') else to_signed(0, DATA_WIDTH);

end architecture behaviour;
