library IEEE;
use IEEE.STD_LOGIC_1164.all;
--use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity Frame_Buffer is
    generic (
        Ha                : integer := 16;   --Hpulse
        Hb                : integer := 48;   --Hpulse+HBP
        Hc                : integer := 1648; --Hpulse+HBP+Hactive
        Hd                : integer := 1800; --Hpulse+HBP+Hactive+HFP
        Va                : integer := 5;    --Vpulse
        Vb                : integer := 41;   --Vpulse+VBP
        Vc                : integer := 1241; --Vpulse+VBP+Vactive
        Vd                : integer := 1375;--Vpulse+VBP+Vactive+VFP
        data_width        : natural := 128;
        pxl_order_in_data : string  := "high_to_low";
        addr_width        : natural := 28;
        px_amount         : natural := 21
        -- ordered in which pixels were packed into data,
        -- "low_to_high" or "high_to_low"

    );

    port (
        RGB_in   : in STD_LOGIC_VECTOR (95 downto 0);
        px_clk   : in STD_LOGIC;
        reset    : in STD_LOGIC;
        diff_out : out STD_LOGIC_VECTOR (23 downto 0);
        start    : in STD_LOGIC
    );

end Frame_Buffer;

architecture Behavioral of Frame_Buffer is

    signal data_write_tabu_i : STD_LOGIC;
    signal Hsync_i : STD_LOGIC;
    signal Vsync_i : STD_LOGIC;
    signal dena_i : STD_LOGIC;
    signal RGB_i : STD_LOGIC_VECTOR (95 downto 0);
    signal data_valid_i : STD_LOGIC; -- from MC read data FIFO
    signal data_i : std_logic_vector (data_width - 1 downto 0); --from MC read data FIFO
    signal sel_i : STD_LOGIC_VECTOR (4 downto 0); --from Px_counter. Mux' select
    signal four_px_clk_i : STD_LOGIC; -- data_unpacker output reg clk
    signal rd_addr_full_i : STD_LOGIC;
    signal request_i : STD_LOGIC;
    signal rd_addr_wr_en_i : STD_LOGIC;
    signal rd_addr_i : std_logic_vector(addr_width - 1 downto 0);
    signal data_rd_rqst_i : STD_LOGIC;

begin
    OLED_Controller : entity work.OLED_Controller
        port map(
            RGB_in              => RGB_i,
            px_clk              => px_clk,
            reset               => reset,
            diff_out            => diff_out,
            data_write_tabu_out => data_write_tabu_i,
            Hsync_in            => Hsync_i,
            Vsync_in            => Vsync_i,
            dena_in             => dena_i,
            four_px_clk_out     => four_px_clk_i
        );

    Data_unpacker : entity work.Data_unpacker
        generic map(
            data_width        => data_width,
            pxl_order_in_data => pxl_order_in_data
        )
        port map(
            four_px_clk => four_px_clk_i,
            px_clk      => px_clk,
            rst         => reset,
            sel         => sel_i,        --from Px_counter. Mux' select
            data_in     => data_i,       --from MC read data FIFO
            data_valid  => data_valid_i, -- from MC read data FIFO
            four_px_out => RGB_i
        );

    Read_address_generator : entity work.Read_address_generator
        generic map(
            h_res      => Hd,
            v_res      => Vd,
            addr_width => addr_width,
            px_amount  => px_amount)

        port map(
            px_clk        => px_clk,
            rst           => reset,
            rd_addr_full  => rd_addr_full_i,
            request       => request_i,

            rd_addr_wr_en => rd_addr_wr_en_i,
            rd_addr       => rd_addr_i);

    Px_counter : entity work.Px_counter
        generic map(
            Ha         => Ha,
            Hb         => Hb,
            Hc         => Hc,
            Hd         => Hd,
            Va         => Va,
            Vb         => Vb,
            Vc         => Vc,
            Vd         => Vd,
            data_width => data_width
        )

        port map(
            start                   => start,
            rst                     => reset,
            px_clk                  => px_clk,
            data_write_tabu_in      => data_write_tabu_i,
            Hsync_out               => Hsync_i,
            Vsync_out               => Vsync_i,
            dena_out                => dena_i,
            data_rd_rqst            => data_rd_rqst_i,
            rd_addr_generating_rqst => request_i,
            sel                     => sel_i
        );
end Behavioral;