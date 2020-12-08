library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity FSM is
  port (
    --! clock signal
    clk          : in  std_logic;
    --! asyncronous active low reset
    n_rst        : in  std_logic;
    --! new data flag
    new_data     : in  std_logic;
    --! neurons finished computing
    neurons_ready   : in  std_logic;
    --! layers' address
    read_addr : out unsigned (LAYERS_DEPTH - 1 downto 0);
    --! compute the neurons
    enable_neurons : out std_logic;
    --! save the neurons outputs
    enable_output_neurons : out std_logic;
    --! output ready flag
    output_ready : out std_logic
  );

end entity FSM;
architecture structure of FSM is
  -- States for FSM
  type state_type is (IDLE, INIT, FETCHING, COMPUTING);
  signal present_state, next_state : state_type;

  -- Count the num of the current layer
  signal counter, next_counter : unsigned(LAYERS_DEPTH - 1 downto 0);

begin  -- architecture structure


  -- Counter to know the current layer
  counter_pr : process(clk, n_rst)
  begin
    if n_rst = '0' then
      counter <= (others => '0');
    elsif rising_edge (clk) then
      if(present_state /= IDLE) then
        counter <= next_counter;
      end if;
    end if;
  end process counter_pr;
  -- Counter in two parts to control easily
  next_counter <= counter + 1;


  --! FSM logic
  process (present_state, next_counter, new_data) -- (all)
  begin
    next_state   <= present_state;
    case(present_state) is
      when IDLE =>
        if new_data = '1' then
          next_state <= INIT;
        end if;
      when INIT =>
        next_state <= COMPUTING;
      when FETCHING =>
        next_state <= COMPUTING;
      when COMPUTING =>
        if next_counter = to_unsigned(0, counter'length) then
          next_state <= IDLE;
        else
          next_state <= COMPUTING;
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

  -- Control signals
  enable_output_neurons <= '1' when (new_data = '1' or present_state = COMPUTING) else '0';
  enable_neurons <= '1' when (present_state = FETCHING) else '0';

  read_addr <= counter;

end architecture structure;
