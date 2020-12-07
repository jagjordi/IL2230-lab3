-------------------------------------------------------------------------------
-- Title       : Testbench for design "parallel_neuron"
-- Project     : Parallel neuron
-------------------------------------------------------------------------------
--! @file      : parallel_neuron_tb.vhd
--! @author    : DESKTOP-AO7QBKG  <jordi@DESKTOP-AO7QBKG>
--  Company    : KTH Royal Institute of Technology (kth.se)
--  Created    : 2020-12-01
--  Last update: 2020-12-01
--  Standard   : VHDL'08
------------------------------------------------------------------------------
--! @brief 
--! @details
-------------------------------------------------------------------------------
-- Copyright (c) 2020 KTH Royal Institute of Technology (kth.se)
-------------------------------------------------------------------------------
-- Revisions   :
-- Date        Version  Author  Description
-- 2020-12-01  1.0      jordi Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;
use work.types_and_constants.all;

------------------------------------------------------------------------------------------------------------------------

entity parallel_neuron_tb is

end entity parallel_neuron_tb;

------------------------------------------------------------------------------------------------------------------------

architecture parallel_neuron_tb of parallel_neuron_tb is

  -- component ports
  signal n_rst        : std_logic;
  signal new_data     : std_logic;
  signal data_in      : data_in_type;
  signal weights      : data_in_type;
  signal bias         : signed(DATA_WIDTH-1 downto 0);
  signal output       : signed(DATA_WIDTH-1 downto 0);
  signal output_ready : std_logic;
  signal output_fx    : sfixed(INTEGER_BITS-1 downto -FRACTIONAL_BITS);

  -- clock
  signal clk : std_logic := '1';

begin  -- architecture parallel_neuron_tb

  -- component instantiation
  DUT : entity work.parallel_neuron
    port map (
      clk          => clk,
      n_rst        => n_rst,
      new_data     => new_data,
      data_in      => data_in,
      weights      => weights,
      bias         => bias,
      output       => output,
      output_ready => output_ready);

  -- clock generation
  clk <= not clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    n_rst    <= '0';
    new_data <= '0';
    data_in  <= (others => (others => '0'));
    weights  <= (others => (others => '0'));
    bias     <= (others => '0');
    wait for 5 ns;
    n_rst    <= '1';
    bias     <= shift_left(to_signed(3, DATA_WIDTH), FRACTIONAL_BITS);
    new_data <= '1';
    data_in <= (shift_left(to_signed(4, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS));
    weights <= (shift_left(to_signed(4, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(5, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(6, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(7, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(8, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(9, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(1, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(2, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(3, DATA_WIDTH), FRACTIONAL_BITS));

    wait until clk = '1';
    wait;
  end process WaveGen_Proc;

  output_fx <= to_sfixed(output);
  -- calculate_results: process (all)
  -- begin
  --   temp_mac <= 
  --   for i in 0 to DATA_DEPTH-1 loop
  --     temp_mac <= 
  -- end process;

end architecture parallel_neuron_tb;

------------------------------------------------------------------------------------------------------------------------

configuration parallel_neuron_tb_parallel_neuron_tb_cfg of parallel_neuron_tb is
  for parallel_neuron_tb
  end for;
end parallel_neuron_tb_parallel_neuron_tb_cfg;

------------------------------------------------------------------------------------------------------------------------
