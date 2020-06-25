LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Px_counter_tb IS
END Px_counter_tb;

ARCHITECTURE Behavioral OF Px_counter_tb IS
    SIGNAL start_tb : STD_LOGIC := '0';
    SIGNAL rst_tb : STD_LOGIC := '0';
    SIGNAL px_clk_tb : STD_LOGIC := '0';
    SIGNAL data_write_tabu_in_tb : STD_LOGIC := '0';
    SIGNAL Hsync_out_tb : STD_LOGIC;
    SIGNAL Vsync_out_tb : STD_LOGIC;
    SIGNAL dena_out_tb : STD_LOGIC;
    SIGNAL data_rd_rqst_tb : STD_LOGIC;
    SIGNAL rd_addr_generating_rqst_tb : STD_LOGIC;
    SIGNAL sel_tb : STD_LOGIC_VECTOR (4 DOWNTO 0);
BEGIN

    dut0 : ENTITY work.Px_counter
        PORT MAP(
            start => start_tb,
            rst => rst_tb,
            px_clk => px_clk_tb,
            data_write_tabu_in => data_write_tabu_in_tb,
            Hsync_out => Hsync_out_tb,
            Vsync_out => Vsync_out_tb,
            dena_out => dena_out_tb,
            data_rd_rqst => data_rd_rqst_tb,
            rd_addr_generating_rqst => rd_addr_generating_rqst_tb,
            sel => sel_tb);

    px_clk_tb <= NOT px_clk_tb AFTER 6.734 ns;
    rst_tb <= '1' AFTER 30 ns, '0' AFTER 50 ns;

    PROCESS BEGIN
        start_tb <= '0';
        WAIT FOR 100 ns;
        start_tb <= '1';
        WAIT FOR 20 ns;
        start_tb <= '0';
        WAIT;
    END PROCESS;
    
END Behavioral;