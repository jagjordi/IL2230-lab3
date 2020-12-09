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

-- BEGIN WEIGHTS
  all_weights(0)(0)(0) <= B"000000001100_11101001010110011001"; -- 12.955801
  all_weights(0)(0)(1) <= B"000000000110_01111001010000101100"; -- 6.496684
  all_weights(0)(0)(2) <= B"000000000101_11111101100101000100"; -- 5.1038660
  all_weights(0)(1)(0) <= B"000000000101_11101000101010010101"; -- 5.952981
  all_weights(0)(1)(1) <= B"000000010110_11100101110001100110"; -- 22.941158
  all_weights(0)(1)(2) <= B"000000000101_01000010110011010010"; -- 5.273618
  all_weights(0)(2)(0) <= B"000000000011_10010001001010011110"; -- 3.594590
  all_weights(0)(2)(1) <= B"000000001000_01011000101001000101"; -- 8.363077
  all_weights(0)(2)(2) <= B"000000001010_11010001000101000011"; -- 10.856387
  all_weights(1)(0)(0) <= B"000000010110_11111111110111100011"; -- 22.1048035
  all_weights(1)(0)(1) <= B"000000000001_00110010111001010010"; -- 1.208466
  all_weights(1)(0)(2) <= B"000000000101_01001001111101111000"; -- 5.302968
  all_weights(1)(1)(0) <= B"000000010101_10101100101010100001"; -- 21.707233
  all_weights(1)(1)(1) <= B"000000001111_01100101010101110001"; -- 15.415089
  all_weights(1)(1)(2) <= B"000000010000_11010010110110010001"; -- 16.863633
  all_weights(1)(2)(0) <= B"000000010100_11110101010010001100"; -- 20.1004684
  all_weights(1)(2)(1) <= B"000000000110_10101010001101011011"; -- 6.697179
  all_weights(1)(2)(2) <= B"000000000100_10010010101001011110"; -- 4.600670
  all_weights(2)(0)(0) <= B"000000010111_00100101100100001100"; -- 23.153868
  all_weights(2)(0)(1) <= B"000000000101_00001010000001101111"; -- 5.41071
  all_weights(2)(0)(2) <= B"000000010110_10011111110010111010"; -- 22.654522
  all_weights(2)(1)(0) <= B"000000000101_00011101001100000010"; -- 5.119554
  all_weights(2)(1)(1) <= B"000000010000_01010100011101001011"; -- 16.345931
  all_weights(2)(1)(2) <= B"000000010100_10101101000111011101"; -- 20.709085
  all_weights(2)(2)(0) <= B"000000001100_01000100011111000010"; -- 12.280514
  all_weights(2)(2)(1) <= B"000000001110_01110010000010010111"; -- 14.467095
  all_weights(2)(2)(2) <= B"000000001000_00101111111010110000"; -- 8.196272
-- END WEIGHTS

  -- Select correcponding layer
  layer_weights <= all_weights(to_integer(layer_num));

end architecture constants;