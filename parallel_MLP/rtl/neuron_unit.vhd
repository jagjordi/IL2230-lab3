library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity neuron_unit is

  port (
    --! Clock signal
    clk           : in  std_logic;
    --! Active low asynchronous reset
    n_rst         : in  std_logic;
    --! Input of data
    data_input    : in  data_in_type;
    --! Output of data
    data_output   : out data_in_type;
    --! All the weights for the current layer
    layer_weights : in  layer_weight_type;
    --! All biases for the current layer
    layer_biases  : in  data_in_type;
    --! True if the current layer is first layer
    first_layer   : in  std_logic;
    --! True if current layer is last layer
    last_layer    : in  std_logic);

end entity neuron_unit;

architecture structure of neuron_unit is

  -- This ones connect the data output of neuron to mux and register
  signal reg_input_tmp, reg_output_tmp, neuron_output_tmp : data_in_type;
  -- This one is used to hold all inputs of all neurons (size N*N) so they can be connected in for loop
  signal layer_data_inputs                                : layer_weight_type;

begin  -- architecture structure

  --! Input data MUX
  reg_input_tmp <= data_input when first_layer = '1' else neuron_output_tmp;

  --! Register to hold previous value
  data_reg : process (clk, n_rst)
  begin
    if n_rst = '0' then
      reg_output_tmp <= (others => (others => '0'));
    elsif rising_edge(clk) then
      reg_output_tmp <= reg_input_tmp;
    end if;
  end process;

  --! Output data MUX
  data_output <= neuron_output_tmp when last_layer = '1' else (others => (others => '0'));

  --! Chain of neurons
  neuron_array : for i in 0 to DATA_DEPTH-1 generate
    parallel_neuron_1 : entity work.parallel_neuron
      port map (
        clk          => clk,
        n_rst        => n_rst,
        new_data     => '1',
        data_in      => layer_data_inputs(i),
        weights      => layer_weights(i),
        bias         => layer_biases(i),
        output       => neuron_output_tmp(i),
        output_ready => open
      );

    --! Connections of previous data
    neuron_input_connections : for j in 0 to DATA_DEPTH-1 generate
      layer_data_inputs(i)(j) <= reg_output_tmp(j);
    end generate;
  end generate;

end architecture structure;
