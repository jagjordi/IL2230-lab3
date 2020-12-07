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
    output       : out signed(DATA_WIDTH-1 downto 0);
    --! output ready flag
    output_ready : out std_logic);

end entity parallel_MLP;

architecture structure of parallel_MLP is

begin  -- architecture structure



end architecture structure;
