library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity weight_ROM is

  port (
    layer_num     : in  unsigned(LAYER_ADDRESS_WIDTH-1 downto 0);
    layer_weights : out layer_weight_type);

end entity weight_ROM;

architecture constants of weight_ROM is

  --! Mimics a fake M*N*N storage
  type all_weights_type is array (0 to NUM_LAYERS-1) of layer_weight_type;
  signal all_weights : all_weights_type;

begin  -- architecture constants

  -- Initialize all weights


  -- Select correcponding layer
  layer_weights <= all_weights(to_integer(layer_num));

end architecture constants;
