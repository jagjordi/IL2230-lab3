library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity parallel_neuron is
  port (
    --! clock signal
    clk          : in  std_logic;
    --! asyncronous active low reset
    n_rst        : in  std_logic;
    --! new data flag
    new_data     : in  std_logic;
    --! Input data vector
    data_in      : in  data_in_type;
    --! Input weights
    weights      : in  data_in_type;
    --! Bias value
    bias         : in  signed(DATA_WIDTH-1 downto 0);
    --! output of the neurone
    output       : out signed(DATA_WIDTH-1 downto 0);
    --! output ready flag
    output_ready : out std_logic);

end entity parallel_neuron;
architecture structure of parallel_neuron is

  -- We use this to store data+bias in a single array
  type full_data_type is array (0 to DATA_DEPTH) of signed (DATA_WIDTH-1 downto 0);
  signal full_data_in, full_weights : full_data_type;

  -- We use this to hold intermediate resutsl in the MAC chain
  type result_tmp_type is array (0 to DATA_DEPTH+1) of signed (DATA_WIDTH-1 downto 0);
  signal result_tmp : result_tmp_type;

  -- ReLU temp signal
  signal ReLU_output : signed(DATA_WIDTH-1 downto 0);

begin  -- architecture structure

  -- Assign weight(0) and data(0) and bias and '1', and input to rest
  input_data_assignment : for i in 0 to DATA_DEPTH-1 generate
    full_data_in(i) <= data_in(i);
    full_weights(i) <= weights(i);
  end generate;
  full_data_in(DATA_DEPTH) <= bias;
  full_weights(DATA_DEPTH) <= shift_left(to_signed(1, DATA_WIDTH), FRACTIONAL_BITS);

  -- Generate MAC chain
  result_tmp(0) <= (others => '0');
  MAC_chain_gen : for i in 0 to DATA_DEPTH generate
  begin
    MAC_1 : entity work.MAC
      port map (
        mult1      => full_data_in(i),
        mult2      => full_weights(i),
        accumulate => result_tmp(i),
        result     => result_tmp(i+1));
  end generate;

  ReLU_1: entity work.ReLU
    port map (
      input  => result_tmp(DATA_DEPTH + 1),
      output => ReLU_output);
  
  output <= ReLU_output;

end architecture structure;
