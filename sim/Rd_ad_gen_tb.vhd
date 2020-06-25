library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rd_ad_gen_tb is
end Rd_ad_gen_tb;

architecture Behavioral of Rd_ad_gen_tb is

    signal clk_tb : STD_LOGIC := '0';
    signal rst_tb : STD_LOGIC := '0';
    signal rd_addr_full_tb : STD_LOGIC;
    signal request_tb : STD_LOGIC;
    signal rd_addr_wr_en_tb : STD_LOGIC;
    signal rd_addr_tb : STD_LOGIC_VECTOR ( 27 downto 0);

begin

    dut : entity work.Read_address_generator
        port map (
            clk => clk_tb,
            rst => rst_tb,
            rd_addr_full => rd_addr_full_tb,
            request => request_tb,
            rd_addr_wr_en => rd_addr_wr_en_tb,
            rd_addr => rd_addr_tb);

    clk_tb <= not clk_tb after 6.734 ns;
    rst_tb <= '1' after 30 ns, '0' after 50 ns;
    process begin
        request_tb <= '0';
        wait for 100 ns;
        request_tb <= '1';
        wait;
    end process;

    process begin
        rd_addr_full_tb <= '1';
        wait for 90 ns;
        rd_addr_full_tb <= '0';
        wait;
    end process;

end Behavioral;
