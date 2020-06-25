library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity pll_tb is
end pll_tb;

architecture Behavioral of pll_tb is

component clk_wiz_0
    port (
    clk_out1  : out std_logic;
    reset     : in  std_logic;
    locked    : out std_logic;
    clk_in1   : in  std_logic);
 end component;

signal tx_clkdiv2  : std_logic;
signal reset_tb    : std_logic := '0';
signal locked_tb   : std_logic;
signal px_clk      : std_logic := '0';

begin

reset_tb <= '1' after 100 ns, '0' after 200 ns;
px_clk   <= not px_clk after 6.734 ns;

PLL : clk_wiz_0
    port map(
    clk_out1 => tx_clkdiv2,
    reset    => reset_tb,
    locked   => locked_tb, 
    clk_in1  => px_clk);
    
end Behavioral;
