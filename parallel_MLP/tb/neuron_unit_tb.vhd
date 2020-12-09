-------------------------------------------------------------------------------
-- Title       : Testbench for design "neuron_unit"
-- Project     : Parallel MLP
-------------------------------------------------------------------------------
--! @file      : neuron_unit_tb.vhd
--! @author    : DESKTOP-AO7QBKG  <jordi@DESKTOP-AO7QBKG>
--  Company    : KTH Royal Institute of Technology (kth.se)
--  Created    : 2020-12-08
--  Last update: 2020-12-08
--  Standard   : VHDL'08
------------------------------------------------------------------------------
--! @brief 
--! @details
-------------------------------------------------------------------------------
-- Copyright (c) 2020 KTH Royal Institute of Technology (kth.se)
-------------------------------------------------------------------------------
-- Revisions   :
-- Date        Version  Author  Description
-- 2020-12-08  1.0      jordi Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use work.types_and_constants.all;

------------------------------------------------------------------------------------------------------------------------

entity neuron_unit_tb is

end entity neuron_unit_tb;

------------------------------------------------------------------------------------------------------------------------

architecture neuron_unit_tb of neuron_unit_tb is

  -- Fixed types for testbench, not suported for synthesis
  type data_in_fx_type is array (0 to DATA_DEPTH-1) of sfixed (INTEGER_BITS-1 downto -FRACTIONAL_BITS);
  type layer_weight_fx_type is array (0 to DATA_DEPTH-1) of data_in_fx_type;
  -- Use this dummy to pass as argument of the to_sfixed function
  signal sfixed_dummy : sfixed(INTEGER_BITS-1 downto - FRACTIONAL_BITS);

  -- fixed point signals
  signal data_input_fx, data_output_fx, layer_biases_fx : data_in_fx_type;
  signal layer_weights_fx                               : layer_weight_fx_type;

  -- component ports
  signal n_rst         : std_logic;
  signal data_input    : data_in_type;
  signal data_output   : data_in_type;
  signal layer_weights : layer_weight_type;
  signal layer_biases  : data_in_type;
  signal first_layer   : std_logic;
  signal last_layer    : std_logic;

  -- clock
  signal clk : std_logic := '1';

begin  -- architecture neuron_unit_tb

  -- component instantiation
  DUT : entity work.neuron_unit
    port map (
      clk           => clk,
      n_rst         => n_rst,
      data_input    => data_input,
      data_output   => data_output,
      layer_weights => layer_weights,
      layer_biases  => layer_biases,
      first_layer   => first_layer,
      last_layer    => last_layer);

  -- clock generation
  clk <= not clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    n_rst            <= '0';
    first_layer      <= '0';
    last_layer       <= '1'; -- so we see the output
    data_input_fx    <= (others => (others => '0'));
    layer_biases_fx  <= (others => (others => '0'));
    layer_weights_fx <= (others => (others => (others => '0')));

    wait until clk = '1';
    n_rst <= '1';

    for i in 0 to DATA_DEPTH-1 loop
      layer_biases_fx(i) <= to_sfixed(i, sfixed_dummy);
      for j in 0 to DATA_DEPTH-1 loop
        layer_weights_fx(i)(j) <= to_sfixed(i+j, sfixed_dummy);
      end loop;
    end loop;
    wait;

  end process WaveGen_Proc;


  -- connect fixed point signals to tb signals (so we can input fixed point and display in modelsim)
  fxd_i_gen : for i in 0 to DATA_DEPTH-1 generate
    layer_biases(i)   <= signed(to_slv(layer_biases_fx(i)));
    data_output_fx(i) <= to_sfixed(data_output(i));
    data_input(i)     <= signed(to_slv(data_input_fx(i)));
    fxd_j_gen : for j in 0 to DATA_DEPTH-1 generate
      layer_weights(i)(j) <= signed(to_slv(layer_weights_fx(i)(j)));
    end generate;
  end generate;

end architecture neuron_unit_tb;

------------------------------------------------------------------------------------------------------------------------

configuration neuron_unit_tb_neuron_unit_tb_cfg of neuron_unit_tb is
  for neuron_unit_tb
  end for;
end neuron_unit_tb_neuron_unit_tb_cfg;

------------------------------------------------------------------------------------------------------------------------
