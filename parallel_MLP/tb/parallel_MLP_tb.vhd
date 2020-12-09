library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity parallel_MLP_tb is
end entity parallel_MLP_tb;

architecture behavior of parallel_MLP_tb is

  signal clk, n_rst, new_data : std_logic := '0';
  signal data_in : data_in_type := (others => to_signed(0, DATA_WIDTH));
  signal output : data_in_type;
  signal output_ready : std_logic;

  constant half_period : time := 10 ns;
  constant period : time := 2*half_period;
  shared variable simulation_ended : boolean := false;

begin

  parallel_MLP_0 : entity work.parallel_MLP
  port map (
    clk => clk,
    n_rst => n_rst,
    new_data => new_data,
    data_in => data_in,
    output => output,
    output_ready => output_ready
  );


  clk_process : process
  begin
    while simulation_ended = false loop
      clk <= not clk;
      wait for half_period;
    end loop;
    wait;
  end process clk_process;


  test_process : process
  begin
    n_rst <= '0';
    wait for half_period;
    n_rst <= '1';

    wait for period;

    for k in 0 to 5 loop

        data_in <= (others => to_signed(k, DATA_WIDTH));

        new_data <= '1';
        wait for period;
        new_data <= '0';

        while output_ready = '0' loop
            wait for period;
        end loop;

        wait for 2*period;

    end loop;

    simulation_ended := true;
    wait;
  end process test_process;


end architecture behavior;