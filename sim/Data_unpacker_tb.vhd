library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_unpacker_tb is
end Data_unpacker_tb;

architecture Behavioral of Data_unpacker_tb is

    signal px_clk_tb : std_logic := '0';
    signal four_px_clk_tb : std_logic := '0';
    signal rst_tb : std_logic := '0';
    signal data_in_tb : std_logic_vector (127 downto 0) := x"00000000000000000000000000000000";
    signal four_px_out_tb : std_logic_vector (95 downto 0);
    signal start_tb : std_logic := '0';
    signal data_rd_rqst_tb : std_logic;
    signal rd_addr_generating_rqst_tb : std_logic;
    signal x_px_tb : std_logic_vector (15 downto 0);
    signal y_px_tb : std_logic_vector (15 downto 0);
    signal sel_tb : std_logic_vector (4 downto 0);
    signal Hsync_out_tb : std_logic;
    signal Vsync_out_tb : std_logic;
    signal dena_out_tb : std_logic;
    signal data_valid_tb : std_logic := '1';
    signal data_write_tabu_in_tb : std_logic := '0';
begin

    dut0 : entity work.Data_unpacker
        port map(
            four_px_clk => four_px_clk_tb,
            px_clk      => px_clk_tb,
            rst         => rst_tb,
            sel         => sel_tb,
            data_in     => data_in_tb,
            data_valid  => data_valid_tb,

            four_px_out => four_px_out_tb

        );

    dut1 : entity work.On_screen_px_counter
        port map(
            px_clk                  => px_clk_tb,
            start                   => start_tb,
            Vsync                   => Vsync_out_tb,
            dena                    => dena_out_tb,
            rst                     => rst_tb,

            data_rd_rqst            => data_rd_rqst_tb,
            rd_addr_generating_rqst => rd_addr_generating_rqst_tb,
            x_px                    => x_px_tb,
            y_px                    => y_px_tb,
            sel                     => sel_tb
        );

    dut2 : entity work.Control_generator
        port map(
            start              => start_tb,
            rst                => rst_tb,
            px_clk             => px_clk_tb,
            data_write_tabu_in => data_write_tabu_in_tb,

            Hsync_out          => Hsync_out_tb,
            Vsync_out          => Vsync_out_tb,
            dena_out           => dena_out_tb
        );

    px_clk_tb <= not px_clk_tb after 1.6835 ns;
    four_px_clk_tb <= not four_px_clk_tb after 6.734 ns;
    rst_tb <= '1' after 30 ns, '0' after 50 ns;

    process begin
        start_tb <= '0';
        wait for 100 ns;
        start_tb <= '1';
        wait for 20 ns;
        start_tb <= '0';
        wait;
    end process;
end Behavioral;