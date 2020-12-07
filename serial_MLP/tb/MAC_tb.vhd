-------------------------------------------------------------------------------
-- Title       : Testbench for design "MAC"
-- Project     : Parallel neuron
-------------------------------------------------------------------------------
--! @file      : MAC_tb.vhd
--! @author    : DESKTOP-AO7QBKG  <jordi@DESKTOP-AO7QBKG>
--  Company    : KTH Royal Institute of Technology (kth.se)
--  Created    : 2020-11-30
--  Last update: 2020-11-30
--  Standard   : VHDL'08
------------------------------------------------------------------------------
--! @brief 
--! @details
-------------------------------------------------------------------------------
-- Copyright (c) 2020 KTH Royal Institute of Technology (kth.se)
-------------------------------------------------------------------------------
-- Revisions   :
-- Date        Version  Author  Description
-- 2020-11-30  1.0      jordi Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;
use ieee.fixed_pkg.all;
----------------------------------------------------------------------------------------------------------------------

entity MAC_tb is

end entity MAC_tb;

------------------------------------------------------------------------------------------------------------------------

architecture MAC_tb of MAC_tb is

  -- component ports
  signal mult1      : signed(DATA_WIDTH-1 downto 0);
  signal mult2      : signed(DATA_WIDTH-1 downto 0);
  signal accumulate : signed(DATA_WIDTH-1 downto 0);
  signal result     : signed(DATA_WIDTH-1 downto 0);
  signal result_fx  : sfixed(INTEGER_BITS-1 downto -FRACTIONAL_BITS);


  -- clock
  signal clk : std_logic := '1';

begin  -- architecture MAC_tb

  -- component instantiation
  DUT : entity work.MAC
    port map (
      mult1      => mult1,
      mult2      => mult2,
      accumulate => accumulate,
      result     => result);

  -- clock generation
  clk <= not clk after 10 ns;

  -- waveform generation
  WaveGen_Proc : process
  begin
    -- insert signal assignments here
    mult1      <= signed(to_sfixed(-1.5, result_fx));
    mult2      <= signed(to_sfixed(2.5, result_fx));
    accumulate <= signed(to_sfixed(2, result_fx));
    wait until clk = '1';
    mult1      <= signed(to_sfixed(0.5, result_fx));
    mult2      <= signed(to_sfixed(21, result_fx));
    accumulate <= signed(to_sfixed(-4, result_fx));
    wait until clk = '1';
  end process WaveGen_Proc;
  result_fx <= to_sfixed(result);
  verification : process
  begin
    if result = shift_left(to_signed(5, DATA_WIDTH), FRACTIONAL_BITS) then
      report "correct";
    else
      report "incorrect";
    end if;
    wait until clk = '1';
    if result = shift_left(to_signed(26, DATA_WIDTH), FRACTIONAL_BITS) then
      report "correct";
    else
      report "incorrect";
    end if;
    wait until clk = '1';
  end process;

end architecture MAC_tb;

------------------------------------------------------------------------------------------------------------------------

configuration MAC_tb_MAC_tb_cfg of MAC_tb is
  for MAC_tb
  end for;
end MAC_tb_MAC_tb_cfg;

------------------------------------------------------------------------------------------------------------------------
