library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity serial_MLP is

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
    weights_input : in  data_in_type;
    --extarnal start control
    start_signal  : in  std_logic;
    --! All biases for the current layer
    bias  : in  signed(DATA_WIDTH-1 downto 0)
   );

end entity serial_MLP;

architecture structure of serial_MLP is

  -- This ones connect the data output of neuron to mux and register
  signal last_set_reg, data_output_tmp, neuron_mux_input_tmp, neuron_input_tmp : data_in_type;
  signal neuron_output_tmp : signed(DATA_WIDTH-1 downto 0);
  -- Two sets of registers for capturing neuron outputs.
  signal set_1_enbale, set_2_enable : std_logic;
  signal in_sel, out_sel, new_data_tmp, neuron_ready, activate_registers, final_output, first_layer, last_layer : std_logic;
  signal set_1_reg, set_2_reg: data_in_type;
  signal count_neuron : integer := 0;
  signal count_layer : integer := 0;

    -- States for FSM
  type state_type is (IDLE, COMPUTING, NEURON_DONE, LAYER_DONE);
  signal present_state, next_state : state_type;
  
begin  -- architecture structure

  --! Input data MUX
  last_set_reg <= set_1_reg when in_sel = '1' else set_2_reg;
  neuron_mux_input_tmp <= data_input when first_layer = '1' else last_set_reg;
  neuron_input_tmp <= neuron_mux_input_tmp when count_neuron = 0 else neuron_input_tmp;
  
  --! Register to hold previous value
  data_reg : process (clk, n_rst)
  begin
    if n_rst = '0' then
      set_1_reg <= (others => (others => '0'));
      set_2_reg <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if set_1_enbale = '1' then
        set_1_reg(count_neuron) <= neuron_output_tmp;
      end if;
      if set_2_enable = '1' then
        set_2_reg(count_neuron) <= neuron_output_tmp;
      end if;
    end if;
  end process;

  set_1_enbale <= '1' when in_sel = '1' and activate_registers = '1' else '0';
  set_2_enable <= '1' when in_sel = '0' and activate_registers = '1' else '0';

  
  --! Output data MUX
  out_sel <= '0' when set_2_enable = '1' else '1';
  data_output_tmp <= set_1_reg when out_sel = '1' else set_2_reg;
  data_output <= data_output_tmp when last_layer = '1' else (others => (others => '0'));


       
  -- Neuron Connection
    parallel_neuron : entity work.parallel_neuron
      port map (
        clk          => clk,
        n_rst        => n_rst,
        new_data     => new_data_tmp,
        data_in      => neuron_input_tmp,
        weights      => weights_input,
        bias         => bias,
        output       => neuron_output_tmp,
        output_ready => neuron_ready);

  --! FSM logic
  process (all)
  begin
    next_state   <= present_state;
    last_layer <= '0';
    
    case(present_state) is

      when IDLE =>
        if start_signal = '1'then

          first_layer <= '1';
          next_state <= COMPUTING;
          in_sel <= '1';
         -- set_sel <= '0';
        end if;

      when COMPUTING =>
        
        new_data_tmp <= '1';
        
        if count_neuron = N - 1 then
          next_state <= NEURON_DONE;
        else
          next_state <= COMPUTING;
          if neuron_ready = '1' then
            count_neuron <= count_neuron + 1;
            activate_registers <= '1';
          else
            activate_registers <= '0';
          end if;
        end if;
        
        
      when NEURON_DONE =>

        first_layer <= '0';
        new_data_tmp <= '0';
        in_sel <= not(in_sel);
      --  set_sel <= not(set_sel);
        activate_registers <= '0';
        count_neuron <= 0;
        if count_layer = M - 2 then
          next_state   <= LAYER_DONE;
          last_layer <= '1';
        else
          count_layer <= count_layer + 1;
          next_state <= COMPUTING;
        end if;
      
    when LAYER_DONE =>
        first_layer <= '1';
        next_state <= IDLE;
        --in_sel <= '1';
        count_layer <= 0;
        
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

  
end architecture structure;
