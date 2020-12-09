library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity weight_ROM is

  port (
    layer_num     : in  unsigned(LAYER_ADDRESS_WIDTH-1 downto 0);
    layer_weights : out layer_weight_type;
    layer_biases  : out data_in_type
  );

end entity weight_ROM;

architecture constants of weight_ROM is

  --! Mimics a fake M*N*N storage
  type all_weights_type is array (0 to NUM_LAYERS-1) of layer_weight_type;
  type all_biases_type is array (0 to NUM_LAYERS-1) of data_in_type;

  signal all_weights : all_weights_type;
  signal all_biases  : all_biases_type;

begin  -- architecture constants

  -- Initialize all weights
  memory_layer:
  for l in 0 to NUM_LAYERS - 1 generate
    memory_neuron:
    for n in 0 to DATA_DEPTH - 1 generate
      -- Biases
      all_biases(l)(n) <= to_signed(0, DATA_WIDTH);
      -- Weights
      memory_connection:
      for c in 0 to DATA_DEPTH - 1 generate
        all_weights(l)(n)(c) <= to_signed(l, DATA_WIDTH);
      end generate;
    end generate;
  end generate;

  -- Select correcponding layer
  layer_weights <= all_weights(to_integer(layer_num));
  layer_biases  <= all_biases(to_integer(layer_num));

end architecture constants;
