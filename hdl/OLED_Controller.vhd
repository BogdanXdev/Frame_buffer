LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY OLED_Controller IS

    PORT (
        RGB_in : IN STD_LOGIC_VECTOR (95 DOWNTO 0);
        px_clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        diff_out : OUT STD_LOGIC_VECTOR (23 DOWNTO 0);
        data_write_tabu_out : OUT STD_LOGIC;
        four_px_clk_out : out STD_LOGIC;
        -- data_rd_rqst : OUT STD_LOGIC;
        -- rd_addr_generating_rqst : OUT STD_LOGIC;
        -- sel : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
        -- start : IN STD_LOGIC;
        Hsync_in : IN STD_LOGIC;
        Vsync_in : IN STD_LOGIC;
        dena_in  : IN STD_LOGIC
        );
END OLED_Controller;

ARCHITECTURE Behavioral OF OLED_Controller IS

    --PLL declaration
    COMPONENT clk_wiz_0
        PORT (
            clk_out1 : OUT std_logic;
            clk_out2 : OUT std_logic;
            reset : IN std_logic;
            locked : OUT std_logic;
            clk_in1 : IN std_logic);
    END COMPONENT;

    --signals declarations

    SIGNAL mapper_in_i : std_logic_vector (63 DOWNTO 0);
    SIGNAL control_signals_i : std_logic_vector (2 DOWNTO 0);
    SIGNAL serializer_in_i : std_logic_vector (83 DOWNTO 0);
    SIGNAL diff_in_i : std_logic_vector (11 DOWNTO 0);
    SIGNAL tx_clkdiv4 : std_logic;
    SIGNAL tx_clkdiv2 : std_logic;
    SIGNAL data_write_tabu_i : std_logic;
    SIGNAL locked_i : std_logic;
    SIGNAL data_write_tabu_ii : std_logic;

BEGIN

    control_signals_i (0) <= Hsync_in;
    control_signals_i (1) <= Vsync_in;
    control_signals_i (2) <= dena_in;

    --RGB_to_YCbCr declaration and instantiation
    RGB_to_YCbCr : ENTITY work.RGB_to_YCbCr
        PORT MAP(
            RGB_in => RGB_in,
            YCbCr_out => mapper_in_i,
            px_clk => px_clk,
            reset => reset,
            data_write_tabu_in => data_write_tabu_ii);

    --Px_counter declaration and instantiation
    -- Px_counter : ENTITY work.Px_counter
    --     GENERIC MAP(
    --         Ha => Ha,
    --         Hb => Hb,
    --         Hc => Hc,
    --         Hd => Hd,
    --         Va => Va,
    --         Vb => Vb,
    --         Vc => Vc,
    --         Vd => Vd,
    --         data_width => data_width
    --     )
    --     PORT MAP(
    --         start => start,
    --         rst => reset,
    --         data_rd_rqst => data_rd_rqst,
    --         rd_addr_generating_rqst => rd_addr_generating_rqst,
    --         sel => sel,
    --         px_clk => px_clk,
    --         Hsync_out => control_signals_i (0),
    --         Vsync_out => control_signals_i (1),
    --         dena_out => control_signals_i (2),
    --         data_write_tabu_in => data_write_tabu_ii);

    --Mapper declaration and instantiation
    Mapper : ENTITY work.Mapper
        PORT MAP(
            mapper_in => mapper_in_i,
            control_in => control_signals_i,
            mapper_out => serializer_in_i);

    --Serializer declaration and instantiation
    Serializer : ENTITY work.Serializer
        PORT MAP(
            parallel_in => serializer_in_i,
            serial_outputs => diff_in_i,
            reset => reset,
            px_clk => px_clk,
            tx_clkdiv4 => tx_clkdiv4,
            tx_clkdiv2 => tx_clkdiv2,
            data_write_tabu_out => data_write_tabu_i);

    --Dif_buf declaration and instantiation
    Dif_buf : ENTITY work.Dif_buf
        PORT MAP(
            diff_in => diff_in_i,
            diff_out => diff_out);

    --PLL  instantiation
    PLL : clk_wiz_0
    PORT MAP(
        clk_out1 => tx_clkdiv2,
        clk_out2 => four_px_clk_out,
        reset => reset,
        locked => locked_i,
        clk_in1 => px_clk);

    --BUFGCE_DIV instantiation
    BUFGCE_DIV_inst : BUFGCE_DIV
    GENERIC MAP(
        BUFGCE_DIVIDE => 2, -- 1-8
        -- Programmable Inversion Attributes: Specifies built-in programmable inversion on specific pins
        IS_CE_INVERTED => '0', -- Optional inversion for CE
        IS_CLR_INVERTED => '0', -- Optional inversion for CLR
        IS_I_INVERTED => '0' -- Optional inversion for I
    )
    PORT MAP(
        O => tx_clkdiv4, -- 1-bit output: Buffer
        CE => '1', -- 1-bit input: Buffer enable
        CLR => reset, -- 1-bit input: Asynchronous clear
        I => tx_clkdiv2 -- 1-bit input: Buffer
    );

    PROCESS (locked_i, data_write_tabu_i, px_clk) BEGIN

        IF locked_i = '0' OR data_write_tabu_i = '1' THEN
            data_write_tabu_ii <= '1';
        ELSE
            data_write_tabu_ii <= '0';
        END IF;

        data_write_tabu_out <= data_write_tabu_ii;

    END PROCESS;
END Behavioral;