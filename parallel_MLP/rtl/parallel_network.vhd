library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity parallel_network is
  port (
    --! clock signal
    clk          : in  std_logic;
    --! asyncronous active low reset
    n_rst        : in  std_logic;
    --! new data flag
    new_data     : in  std_logic;
    --! Input data vector
    data_in      : in  data_in_type;
    --! output of the network
    output       : out signed(DATA_WIDTH-1 downto 0);
    --! output ready flag
    output_ready : out std_logic);

end entity parallel_network;

architecture structure of parallel_network is

  -- We use this to store data+bias in a single array
  type full_data_type is array (0 to DATA_DEPTH) of signed (DATA_WIDTH-1 downto 0); -- Weight + bias concatenated
  type data_bus_type is array (0 to DATA_DEPTH-1) of data_in_type; -- Every weights concatenated
  type full_data_bus_type is array (0 to DATA_DEPTH-1) of full_data_type; -- Memory output (weight + bias for each neuron)

  -- Memory signals
  signal memory_reading : full_data_bus_type;
  signal all_biases : data_in_type;
  signal all_weights : data_bus_type;

  -- Arithmetic signals
  signal neurons_outputs, neurons_outputs_tmp, neurons_inputs : data_in_type;

  -- Control signals
  signal enable_neurons, enable_output_neurons : std_logic;

begin

  -- Instanciate FSM
  FSM_0 : entity work.FSM
  port map (
    clk => clk,
    n_rst => n_rst,
    new_data => new_data,
    enable_neurons => enable_neurons,
    enable_output_neurons => enable_output_neurons,
    output_ready => output_ready
  );

  -- Instanciatre neurons
  GEN_NEURONS :
  for k in 0 to DATA_DEPTH - 1 generate
    NEURON : entity work.parallel_neuron
      port map (
        clk => clk,
        n_rst => n_rst,
        new_data => enable_neurons,
        data_in => neurons_inputs,
        weights => all_weights(k),
        bias => all_biases(k),
        output => neurons_outputs_tmp(k),
        output_ready => open
      );
  end generate;

  -- Route the memory 
  memory_routing:
  for k in 0 to DATA_DEPTH - 1 generate
    -- Weights are the first DATA_DEPTH signeds
    weights_routing:
    for i in 0 to DATA_DEPTH - 1 generate
      all_weights(k)(i) <= memory_reading(k)(i);
    end generate;

    -- Baises are the last signeds 
    biases_routing:
    all_biases(k) <= memory_reading(k)(DATA_DEPTH);
  end generate;

  -- Create a fake memory
  fake_memory:
  for k in 0 to DATA_DEPTH - 1 generate
    fake_weights:
    for i in 0 to DATA_DEPTH - 1 generate
      memory_reading(k)(i) <= to_signed(k, DATA_WIDTH);
    end generate;

    fake_biases:
    memory_reading(k)(DATA_DEPTH) <= to_signed(1, DATA_WIDTH);
  end generate;
  

  -- Synchronouse process for the neurons_outputs registers
  process(n_rst, clk)
  begin
    if n_rst = '0' then
      neurons_outputs <= (others => (to_signed(0, DATA_WIDTH)));
    elsif rising_edge(clk) then
      -- One register per neuron
      for k in 0 to DATA_DEPTH-1 loop
        -- Enable control signal
        if (enable_output_neurons = '1') then
          neurons_outputs(k) <= neurons_outputs_tmp(k);
        end if;
      end loop;
    end if;
  end process;

  data_multiplexers:
  for k in 0 to DATA_DEPTH-1 generate
    neurons_inputs(k) <= neurons_outputs(k) when new_data = '0' else data_in(k);
  end generate;

end architecture structure;
