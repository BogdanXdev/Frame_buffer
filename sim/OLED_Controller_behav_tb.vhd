library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity OLED_Controller_behav_tb is
end OLED_Controller_behav_tb;

architecture Behavioral of OLED_Controller_behav_tb is

signal RGB_in_tb    : std_logic_vector (95 downto 0) := (others => '0');
signal diff_out_tb  : std_logic_vector (23 downto 0);
signal px_clk_tb    : std_logic := '0';
signal reset_tb     : std_logic := '0';
signal data_write_tabu_out_tb : std_logic;
signal Hsync_in_tb : std_logic;
signal Vsync_in_tb : std_logic;
signal dena_in_tb : std_logic;
signal start_tb : std_logic := '0';
signal data_rd_rqst_tb : std_logic;
signal rd_addr_generating_rqst_tb : std_logic;
signal sel_tb : std_logic_vector (4 downto 0); 
begin

dut: entity work.OLED_Controller 
    port map (
         RGB_in   => RGB_in_tb,
         px_clk   => px_clk_tb,
         reset    => reset_tb,
         diff_out => diff_out_tb,
         data_write_tabu_out => data_write_tabu_out_tb,
         Hsync_in => Hsync_in_tb,
         Vsync_in => Vsync_in_tb,
         dena_in => dena_in_tb);
         
 dut1: entity work.Px_counter
     generic map (
         Ha => 16,    --Hpulse
         Hb => 48,    --Hpulse+HBP
         Hc => 1648,  --Hpulse+HBP+Hactive
         Hd => 1800,  --Hpulse+HBP+Hactive+HFP
         Va => 5,     --Vpulse
         Vb => 41,    --Vpulse+VBP
         Vc => 1241,  --Vpulse+VBP+Vactive
         Vd => 1375,
         data_width => 512)
 
     port map (
          start   => start_tb,
          px_clk   => px_clk_tb,
          rst    => reset_tb,
          data_write_tabu_in => data_write_tabu_out_tb,
          Hsync_out => Hsync_in_tb,
          Vsync_out => Vsync_in_tb,
          dena_out => dena_in_tb, 
          data_rd_rqst =>  data_rd_rqst_tb,
          rd_addr_generating_rqst =>  rd_addr_generating_rqst_tb,
          sel => sel_tb );

px_clk_tb <= not px_clk_tb after 6.734 ns;
reset_tb  <= '1' after 100 ns, '0' after 400 ns;
start_tb  <= '1' after 2500 ns, '0' after 2700 ns;

process (data_write_tabu_out_tb) begin
    if data_write_tabu_out_tb = '0' then
        RGB_in_tb <= x"FFFFFFFFFFFFFFFFFFFFFFFF";
    else
        RGB_in_tb <= (others => '0');
    end if;
end process;

end Behavioral;
