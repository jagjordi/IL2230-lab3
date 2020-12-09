library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity parallel_MLP is
  port (
    --! clock signal
    clk          : in  std_logic;
    --! asyncronous active low reset
    n_rst        : in  std_logic;
    --! new data flag
    new_data     : in  std_logic;
    --! Input data vector
    data_in      : in  data_in_type;
    --! output of the neurone
    output       : out data_in_type;
    --! output ready flag
    output_ready : out std_logic);

end entity parallel_MLP;

architecture structure of parallel_MLP is
  signal layer_weights : layer_weight_type;
  signal layer_biases  : data_in_type;
  signal last_layer    : std_logic;
  signal layer_num     : unsigned(LAYER_ADDRESS_WIDTH-1 downto 0);

  -- States for FSM
  type state_type is (IDLE, FETCHING);
  signal present_state, next_state : state_type;

begin  -- architecture structure

  weight_ROM_0 : entity work.weight_ROM
  port map (
    layer_num => layer_num,
    layer_weights => layer_weights,
    layer_biases => layer_biases
  );

  neuron_unit_0 : entity work.neuron_unit
  port map (
    clk => clk,
    n_rst => n_rst,
    data_input => data_in,
    data_output => output,
    layer_weights => layer_weights,
    layer_biases => layer_biases,
    first_layer => new_data,
    last_layer => last_layer
  );


  -- Counter to know the current layer
  layer_num_pr : process(clk, n_rst)
  begin
    if n_rst = '0' then
      layer_num <= (others => '0');
    elsif rising_edge (clk) then
      if(present_state /= IDLE) then
        layer_num <= layer_num + 1;
      end if;
    end if;
  end process layer_num_pr;

  --! FSM logic
  process (present_state, layer_num, new_data) -- (all)
  begin
    next_state <= present_state;
    case(present_state) is
      when IDLE =>
        if new_data = '1' then
          next_state <= FETCHING;
        end if;
      when FETCHING =>
        if layer_num = to_unsigned(NUM_LAYERS-1, layer_num'length) then
          next_state <= IDLE;
        end if;
    end case;
  end process;

  --! FSM state registers
  process (n_rst, clk)
  begin
    if n_rst = '0' then
      present_state <= IDLE;
    elsif rising_edge(clk) then
      present_state <= next_state;
    end if;
  end process;

  last_layer <= '1' when layer_num = to_unsigned(NUM_LAYERS-1, layer_num'length) else '0';
  output_ready <= last_layer;


end architecture structure;
