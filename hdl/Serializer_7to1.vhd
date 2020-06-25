library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
library UNISIM;
use UNISIM.VComponents.all;

entity Serializer_7to1 is
    port (
        FIFO_in             : in STD_LOGIC_VECTOR (6 downto 0);
        serial_out          : out STD_LOGIC;
        reset               : in STD_LOGIC;
        px_clk              : in STD_LOGIC;
        tx_clkdiv4          : in STD_LOGIC;
        tx_clkdiv2          : in STD_LOGIC;
        data_write_tabu_out : out STD_LOGIC);
end Serializer_7to1;

architecture Behavioral of Serializer_7to1 is

    -- FIFO component declaration
    component fifo_generator_0
        port (
            rst         : in STD_LOGIC;
            wr_clk      : in STD_LOGIC;
            rd_clk      : in STD_LOGIC;
            din         : in STD_LOGIC_VECTOR(6 downto 0);
            wr_en       : in STD_LOGIC;
            rd_en       : in STD_LOGIC;
            dout        : out STD_LOGIC_VECTOR(6 downto 0);
            full        : out STD_LOGIC;
            wr_ack      : out STD_LOGIC;
            overflow    : out STD_LOGIC;
            empty       : out STD_LOGIC;
            valid       : out STD_LOGIC;
            underflow   : out STD_LOGIC;
            prog_full   : out STD_LOGIC;
            prog_empty  : out STD_LOGIC;
            wr_rst_busy : out STD_LOGIC;
            rd_rst_busy : out STD_LOGIC);
    end component;

    --enumeration type declaration for FSMD state register signals
    type statetype is (idle_short, idle_long, fill_FIFO, fill_d_reg,
        read1, read2, read3, read4, read5, read6, read7);
    signal state_next, state_reg : statetype;
    signal d_next, d_reg : std_logic_vector(13 downto 0) := (others => '0');
    signal OSERDESE3_in : std_logic_vector(7 downto 0);
    signal FIFO_out : std_logic_vector(6 downto 0);
    signal RE : std_logic;
    signal WE : std_logic;
    signal wr_ack : std_logic;
    signal valid : std_logic;
    signal overflow : std_logic;
    signal underflow : std_logic;
    signal empty : std_logic;
    signal full : std_logic;
    signal empty_2 : std_logic;
    signal full_29 : std_logic;
    signal wr_rst_busy, rd_rst_busy : std_logic;
    signal reset_idle : std_logic;
    signal cnt_long : std_logic_vector(5 downto 0) := "000000";
    signal cnt_short : std_logic_vector(2 downto 0) := "000";
    signal cnt_fill : std_logic_vector(3 downto 0) := "0000";

begin

    --state and data registers
    process (tx_clkdiv4, reset) begin
        if rising_edge(tx_clkdiv4) then
            if reset = '1' then
                state_reg <= idle_short;
                d_reg <= (others => '0');
            else
                state_reg <= state_next;
                d_reg <= d_next;
            end if;
        end if;
    end process;

    --counter for reset state long waiting (FIFO requirement)
    process (px_clk) begin
        if rising_edge(px_clk) then
            if state_reg = idle_long then
                cnt_long <= std_logic_vector(unsigned(cnt_long) + 1);
            else
                cnt_long <= (others => '0');
            end if;
        end if;
    end process;

    --counter for reset state short waiting (FIFO requirement)
    process (px_clk) begin
        if rising_edge(px_clk) then
            if state_reg = idle_short then
                cnt_short <= std_logic_vector(unsigned(cnt_short) + 1);
            else
                cnt_short <= (others => '0');
            end if;
        end if;
    end process;

    --counter for FIFO half fill
    process (px_clk) begin
        if rising_edge(px_clk) then
            if state_reg = fill_FIFO then
                cnt_fill <= std_logic_vector(unsigned(cnt_fill) + 1);
            else
                cnt_fill <= (others => '0');
            end if;
        end if;
    end process;

    --combinational circuit

    process (reset, empty, state_reg, cnt_short, cnt_long, cnt_fill, FIFO_out, d_reg)
    begin
        --default values
        OSERDESE3_in <= x"00";
        RE <= '0';
        d_next <= d_reg;
        --  d_next        <= (others => '0');
        reset_idle <= '0';
        data_write_tabu_out <= '0';

        case state_reg is

            when idle_short => --idle_short state
                if cnt_short = "111" then
                    state_next <= idle_long;
                else
                    state_next <= idle_short;
                end if;
                reset_idle <= '1';
                data_write_tabu_out <= '1';

            when idle_long => --idle_long state
                if cnt_long = "111111" then
                    state_next <= fill_FIFO;
                else
                    state_next <= idle_long;
                end if;
                reset_idle <= '0';
                data_write_tabu_out <= '1';

            when fill_FIFO => --fill_FIFO state
                if cnt_fill = x"F" then
                    state_next <= fill_d_reg;
                else
                    state_next <= fill_FIFO;
                end if;

            when fill_d_reg => --fill_d_reg state
                if empty = '1' then
                    state_next <= fill_d_reg;
                else
                    state_next <= read1;
                    RE <= '1';
                end if;
                d_next(13 downto 7) <= FIFO_out;

            when read1 => --read1 state
                state_next <= read2;
                OSERDESE3_in <= x"0" & d_reg(10) & d_reg(11) & d_reg(12) & d_reg(13);
                d_next(6 downto 0) <= FIFO_out;

            when read2 => --read2 state
                if empty = '1' then
                    state_next <= read2;
                else
                    state_next <= read3;
                    RE <= '1';
                end if;
                OSERDESE3_in <= x"0" & d_reg(6) & d_reg(7) & d_reg(8) & d_reg(9);

            when read3 => --read3 state
                state_next <= read4;
                OSERDESE3_in <= x"0" & d_reg(2) & d_reg(3) & d_reg(4) & d_reg(5);
                d_next(13 downto 7) <= FIFO_out;

            when read4 => --read4 state
                if empty = '1' then
                    state_next <= read4;
                else
                    state_next <= read5;
                    RE <= '1';
                end if;
                OSERDESE3_in <= x"0" & d_reg(12) & d_reg(13) & d_reg(0) & d_reg(1);

            when read5 => --read5 state
                state_next <= read6;
                OSERDESE3_in <= x"0" & d_reg(8) & d_reg(9) & d_reg(10) & d_reg(11);
                d_next(6 downto 0) <= FIFO_out;

            when read6 => --read6 state
                if empty = '1' then
                    state_next <= read6;
                else
                    state_next <= read7;
                    RE <= '1';
                end if;
                OSERDESE3_in <= x"0" & d_reg(4) & d_reg(5) & d_reg(6) & d_reg(7);

            when read7 => --read7 state
                if empty = '1' then
                    state_next <= read7;
                else
                    state_next <= read1;
                    RE <= '1';
                end if;
                OSERDESE3_in <= x"0" & d_reg(0) & d_reg(1) & d_reg(2) & d_reg(3);
                d_next(13 downto 7) <= FIFO_out;
        end case;
    end process;

    -- WE control
    process (all) begin
        if state_reg = idle_long or state_reg = idle_short then
            WE <= '0';
        elsif full_29 = '0' then
            WE <= '1';
        else
            WE <= '0';
        end if;
    end process;

    --FIFO instantiating
    FIFO : fifo_generator_0
    port map(
        rst         => reset_idle,
        wr_clk      => px_clk,
        rd_clk      => tx_clkdiv4,
        din         => FIFO_in,
        wr_en       => WE,
        rd_en       => RE,
        dout        => FIFO_out,
        full        => full,
        wr_ack      => wr_ack,
        overflow    => overflow,
        empty       => empty,
        valid       => valid,
        underflow   => underflow,
        prog_full   => full_29,
        prog_empty  => empty_2,
        wr_rst_busy => wr_rst_busy,
        rd_rst_busy => rd_rst_busy);

    --OSERDESE3 instantiating
    OSERDESE3_inst : OSERDESE3
    generic map(
        DATA_WIDTH         =>  4,           -- Parallel Data Width (4-8)
        INIT               => '0',         -- Initialization value of the OSERDES flip-flops
        IS_CLKDIV_INVERTED => '0',         -- Optional inversion for CLKDIV
        IS_CLK_INVERTED    => '0',         -- Optional inversion for CLK
        IS_RST_INVERTED    => '0',         -- Optional inversion for RST
        SIM_DEVICE         => "ULTRASCALE" -- Set the device version (ULTRASCALE)
    )
    port map(
        OQ     => serial_out,   -- 1-bit output: Serial Output Data
        T_OUT  => open,         -- 1-bit output: 3-state control output to IOB
        CLK    => tx_clkdiv2,   -- 1-bit input: High-speed clock
        CLKDIV => tx_clkdiv4,   -- 1-bit input: Divided Clock
        D      => OSERDESE3_in, -- 8-bit input: Parallel Data Input
        RST    => reset_idle,   -- 1-bit input: Asynchronous Reset  -- synchronous
        T      => '0'           -- 1-bit input: Tristate input from fabric
    );

end Behavioral;