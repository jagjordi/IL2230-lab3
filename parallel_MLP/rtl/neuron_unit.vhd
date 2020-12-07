library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity neuron_unit.vhd is

  port (
    --! Input of data
    data_input    : in  data_in_type;
    --! Output of data
    data_output   : out data_in_type;
    --! All the weights for the current layer
    layer_weights : in  layer_weight_type;
    --! True if the current layer is first layer
    first_layer   : in  std_logic;
    --! True if current layer is last layer
    last_layer    : out std_logic);

end entity neuron_unit.vhd;
