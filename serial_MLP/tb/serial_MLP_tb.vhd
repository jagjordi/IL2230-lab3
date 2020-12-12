-------------------------------------------------------------------------------
-- Title       : Testbench for design "serial_MLP"
-- Project     : Parallel neuron
-------------------------------------------------------------------------------
--! @file      : serial_MLP_tb.vhd
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

entity serial_MLP_tb is

end entity serial_MLP_tb;

------------------------------------------------------------------------------------------------------------------------

architecture serial_MLP_tb_arch of serial_MLP_tb is

  -- component ports
  signal n_rst        : std_logic;
  signal data_input      : data_in_type;
  signal weights_input      : data_in_type;
  signal bias         : signed(DATA_WIDTH-1 downto 0);
  signal data_output  : data_in_type;
  signal start_signal : std_logic;

  -- clock
  signal clk : std_logic := '1';

begin  -- architecture serial_MLP_tb

  -- component instantiation
  DUT : entity work.serial_MLP
    port map (
      clk          => clk,
      n_rst        => n_rst,
      data_input   => data_input,
      weights_input      => weights_input,
      bias         => bias,
      data_output  => data_output,
      start_signal => start_signal);

  -- clock generation
  clk <= not clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    n_rst    <= '0';
    data_input  <= (others => (others => '0'));
    weights_input  <= (others => (others => '0'));
    bias     <= (others => '0');
    start_signal <= '0';
    wait for 5 ns;
    start_signal <= '1';
    n_rst    <= '1';
    bias     <= shift_left(to_signed(1, DATA_WIDTH), FRACTIONAL_BITS);
    data_input <= (shift_left(to_signed(4, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS),
                shift_left(to_signed(0, DATA_WIDTH), FRACTIONAL_BITS));
    weights_input <= (shift_left(to_signed(4, DATA_WIDTH), FRACTIONAL_BITS),
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

  -- calculate_results: process (all)
  -- begin
  --   temp_mac <= 
  --   for i in 0 to DATA_DEPTH-1 loop
  --     temp_mac <= 
  -- end process;

end architecture serial_MLP_tb_arch;

------------------------------------------------------------------------------------------------------------------------

configuration serial_MLP_cfg of serial_MLP_tb is
  for serial_MLP_tb_arch
  end for;
end serial_MLP_cfg;

------------------------------------------------------------------------------------------------------------------------
