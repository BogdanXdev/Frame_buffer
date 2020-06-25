library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--library UNISIM;
--use UNISIM.VComponents.all;

-- RGB_to_YCbCr circuit interface declaration
entity RGB_to_YCbCr is --circuit name
    port (
        RGB_in             : in std_logic_vector (95 downto 0); --circuit input signal (4 px, sRGB)
        YCbCr_out          : out std_logic_vector(63 downto 0); --circuit output signal(4 px, Y'CbCr)
        px_clk, reset      : in std_logic;
        data_write_tabu_in : in std_logic); --clock and reset for output register
end RGB_to_YCbCr;
architecture struct of RGB_to_YCbCr is

    --internal signal declaration. This signal is needed for register implementation
    signal YCbCr_next : std_logic_vector(63 downto 0);
    signal YCbCr_reg : std_logic_vector(63 downto 0);
    signal YCbCr : std_logic_vector(63 downto 0);
    -- SIGNAL four_cnt : std_logic_vector (1 DOWNTO 0);
    -- SIGNAL en : std_logic;
    -- SIGNAL enable : std_logic;

    attribute KEEP : string;
    -- ATTRIBUTE KEEP OF four_cnt : SIGNAL IS "TRUE";
    attribute KEEP of YCbCr_next : signal is "TRUE";

    attribute keep_hierarchy : string;
    attribute keep_hierarchy of struct : architecture is "yes";

begin

    -- 4 RGB2YCbCr_CL circuits instantiating for 4 pixels color model change
    px0_RGB2YCbCr : entity work.RGB2YCbCr_CL port map(
        R_in => RGB_in (95 downto 88),
        G_in => RGB_in (87 downto 80),
        B_in => RGB_in (79 downto 72),
        Y_out => YCbCr (63 downto 56),
        Cb_out => YCbCr (55 downto 48),
        Cr_out => YCbCr (47 downto 40));

    px1_RGB2YCbCr : entity work.RGB2YCbCr_CL port map(
        R_in => RGB_in (71 downto 64),
        G_in => RGB_in (63 downto 56),
        B_in => RGB_in (55 downto 48),
        Y_out => YCbCr (39 downto 32),
        Cb_out => open,
        Cr_out => open);

    px2_RGB2YCbCr : entity work.RGB2YCbCr_CL port map(
        R_in => RGB_in (47 downto 40),
        G_in => RGB_in (39 downto 32),
        B_in => RGB_in (31 downto 24),
        Y_out => YCbCr (31 downto 24),
        Cb_out => YCbCr (23 downto 16),
        Cr_out => YCbCr (15 downto 8));

    px3_RGB2YCbCr : entity work.RGB2YCbCr_CL port map(
        R_in => RGB_in (23 downto 16),
        G_in => RGB_in (15 downto 8),
        B_in => RGB_in (7 downto 0),
        Y_out => YCbCr (7 downto 0),
        Cb_out => open,
        Cr_out => open);

    --output register for pipelining
    process (px_clk)
    begin
        if (px_clk'event and px_clk = '1') then
            if reset = '1' or data_write_tabu_in = '1' then
                YCbCr_reg <= x"0000000000000000";
                -- four_cnt <= (OTHERS => '0');
            else
                YCbCr_reg <= YCbCr_next;
                -- four_cnt <= std_logic_vector(unsigned(four_cnt) + '1');
            end if;
        end if;
    end process;

    -- PROCESS (ALL)
    -- BEGIN -- STRANGE SYNTHESIS
    --     CASE four_cnt IS
    --         WHEN "00" =>
    --             enable <= '1';
    --         WHEN OTHERS =>
    --             enable <= '0';
    --     END CASE;

    --     IF en = '1' THEN
    --         YCbCr_next <= YCbCr;
    --     ELSE
    --         YCbCr_next <= YCbCr_reg;
    --     END IF;
    -- END PROCESS;

    -- en <= enable;
    YCbCr_out <= YCbCr_reg;
    YCbCr_next <= YCbCr;

end struct;