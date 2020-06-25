library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Serializer_tb is
end Serializer_tb;

architecture Behavioral of Serializer_tb is

    signal FIFO_in_tb : std_logic_vector(6 downto 0) := "1001011";
    signal serial_out_tb, data_write_tabu_out_tb : std_logic;
    signal reset_tb, px_clk_tb, tx_clkdiv4_tb, tx_clkdiv2_tb : std_logic := '0';

begin

    --clks
    px_clk_tb     <= not px_clk_tb after 6.734 ns;
    tx_clkdiv4_tb <= not tx_clkdiv4_tb after 3.848 ns;
    tx_clkdiv2_tb <= not tx_clkdiv2_tb after 1.924 ns;

    --reset
    reset_tb <= '1' after 2900 ns, '0' after 3800 ns;

    --start of serializer activity

    dut : entity work.Serializer_7to1 port map(
        FIFO_in => FIFO_in_tb,
        serial_out => serial_out_tb,
        reset => reset_tb,
        px_clk => px_clk_tb,
        tx_clkdiv4 => tx_clkdiv4_tb,
        tx_clkdiv2 => tx_clkdiv2_tb,
        data_write_tabu_out => data_write_tabu_out_tb);

    process (px_clk_tb) begin
        if rising_edge(px_clk_tb) then
            FIFO_in_tb <= std_logic_vector(rotate_left(unsigned(FIFO_in_tb), 1));
        end if;

        --   wait for 100 ns;
        --  -- FIFO_in_tb <= "1001001";
        --   FIFO_in_tb <= std_logic_vector(unsigned(FIFO_in_tb) + "1010011");
        --   wait for 200 ns;
        --   FIFO_in_tb <= std_logic_vector( rotate_left(unsigned(FIFO_in_tb), 5));
        --   wait for 200 ns;
        --   FIFO_in_tb <= std_logic_vector( shift_right(unsigned(FIFO_in_tb), 2));
    end process;
    --process begin
    --    wait on px_clk_tb;
    --    if (px_clk_tb' event and px_clk_tb = '1') then
    --        FIFO_in_tb <= std_logic_vector( rotate_left(unsigned(FIFO_in_tb), 1));
    --    end if;
    --end process;

end Behavioral;