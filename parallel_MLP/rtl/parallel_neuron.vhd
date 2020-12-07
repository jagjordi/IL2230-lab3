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

  -- States for FSM
  type state_type is (IDLE, READY);
  signal present_state, next_state : state_type;
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

  --! FSM logic
  process (all)
  begin
    next_state   <= present_state;
    output_ready <= '0';
    case(present_state) is
      when IDLE =>
        if new_data = '1' then
          next_state <= READY;
        end if;
      when READY =>
        output_ready <= '1';
        next_state   <= IDLE;
      when others =>
        next_state <= IDLE;
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

  --! Output reg
  process (n_rst, clk)
  begin
    if n_rst = '0' then
      output <= to_signed(0, DATA_WIDTH);
    elsif rising_edge(clk) then
      if output_ready = '1' then
        output <= result_tmp(DATA_DEPTH + 1);
      else
        output <= to_signed(0, DATA_WIDTH);
      end if;
    end if;
  end process;

end architecture structure;
