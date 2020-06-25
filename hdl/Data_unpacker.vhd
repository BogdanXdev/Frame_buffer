library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_unpacker is
    generic (
        data_width        : natural := 128;
        -- ordered in which pixels were packed into data,
        -- "low_to_high" or "high_to_low"
        pxl_order_in_data : string  := "high_to_low"
    );

    port (
        four_px_clk : in std_logic;
        px_clk      : in std_logic;
        rst         : in std_logic;
        sel         : in std_logic_vector (4 downto 0);
        data_in     : in std_logic_vector (data_width - 1 downto 0);
        data_valid  : in std_logic;

        four_px_out : out std_logic_vector (95 downto 0)
    );
end Data_unpacker;

architecture Behavioral of Data_unpacker is

    constant px_amount : natural := data_width / 24; -- pxs amount in one data line

    signal one_px : std_logic_vector (23 downto 0);
    signal four_px, four_px_next : std_logic_vector (95 downto 0);
    signal cnt_sel : std_logic_vector (1 downto 0);
    signal enable : std_logic;
    -- signal four_px_next_i : std_logic_vector (95 downto 0);

    attribute KEEP : string;
    attribute KEEP of four_px_next : signal is "TRUE";
    attribute KEEP of cnt_sel : signal is "TRUE";
    attribute keep_hierarchy : string;
    attribute keep_hierarchy of Behavioral : architecture is "yes";

begin
    -- register
    process (four_px_clk, rst) begin
        if rising_edge(four_px_clk) then
            if rst = '1' then
                four_px <= (others => '0');
            else
                four_px <= four_px_next;
            end if;
        end if;
    end process;

    process (px_clk, rst) begin
        if rising_edge(px_clk) then
            if rst = '1' then
                cnt_sel <= (others => '0');
            else
                cnt_sel <= std_logic_vector(unsigned(cnt_sel) + '1');
            end if;
        end if;
    end process;

    process (all)
    begin
        if to_integer(unsigned(sel)) < px_amount and data_valid = '1' then
            if pxl_order_in_data = "low_to_high" then
                one_px <= data_in(24 * (to_integer(unsigned(sel)) + 1) - 1 downto 24 * to_integer(unsigned(sel)));
            elsif pxl_order_in_data = "high_to_low" then
                one_px <= data_in(24 * (px_amount - to_integer(unsigned(sel))) - 1 downto 24 * (px_amount - to_integer(unsigned(sel)) - 1));
            else
                one_px <= (others => '0');
            end if;
        else
            -- sel is out of range
            one_px <= (others => '0');
        end if;
    end process;

    process (all) begin

        case cnt_sel is
            when "00" =>
                -- enable <= '1';
                four_px_next (95 downto 72) <= one_px;
            when "01" =>
                -- enable <= '0';
                four_px_next (71 downto 48) <= one_px;
            when "10" =>
                -- enable <= '0';
                four_px_next (47 downto 24) <= one_px;
            when "11" =>
                -- enable <= '0';
                four_px_next (23 downto 00) <= one_px;
            when others =>
                -- enable <= '0';
                four_px_next <= (others => '0');
        end case;

        -- if enable = '1' then
        --     four_px_next <= four_px_next_i;
        -- else
        --     four_px_next <= four_px;
        -- end if;

    end process;

    four_px_out <= four_px;

end Behavioral;