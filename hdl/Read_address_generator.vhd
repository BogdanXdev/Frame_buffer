library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Read_address_generator is
    generic (
        h_res      : natural := 1800;
        v_res      : natural := 1200;
        addr_width : natural := 28;
        px_amount  : natural := 21
    );

    port (
        px_clk           : in std_logic;
        rst           : in std_logic;
        rd_addr_full  : in std_logic;
        request       : in std_logic;

        rd_addr_wr_en : out std_logic;
        rd_addr       : out std_logic_vector(addr_width - 1 downto 0)
    );
end Read_address_generator;

architecture Behavioral of Read_address_generator is

    constant addr_qnty : natural := h_res * v_res / px_amount;

    type state_type is (idle, generating);
    signal state, state_next : state_type := idle;
    signal addr : std_logic_vector(addr_width - 1 downto 0);
    signal addr_count : natural := 0;

begin

    rd_addr <= addr;

    -- address and address quantity counters
    process (px_clk) begin
        if rising_edge(px_clk) then
            if state = generating then
                addr <= std_logic_vector(unsigned(addr) + 8);
                addr_count <= addr_count + 1;
            else
                addr <= (others => '0');
                addr_count <= 0;
            end if;
        end if;
    end process;

    -- state register
    process (px_clk, rst) begin
        if rising_edge(px_clk) then
            if rst = '1' then
                state <= idle;
            else
                state <= state_next;
            end if;
        end if;
    end process;

    -- FSM combinational part
    process (all) begin
        state_next <= state;
        rd_addr_wr_en <= '0';

        case state is
            when idle =>
                if request = '1' and rd_addr_full = '0' then
                    state_next <= generating;
                else
                    state_next <= idle;
                end if;

            when generating =>
                if rd_addr_full = '0' then
                    rd_addr_wr_en <= '1';

                    if addr_count = addr_qnty - 1 then
                        state_next <= idle;
                    else
                        state_next <= generating;
                    end if;

                else
                    state_next <= idle;
                end if;
        end case;
    end process;
end Behavioral;