LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Px_counter IS

    GENERIC (
        Ha : INTEGER := 16; --Hpulse
        Hb : INTEGER := 48; --Hpulse+HBP
        Hc : INTEGER := 1648; --Hpulse+HBP+Hactive
        Hd : INTEGER := 1800; --Hpulse+HBP+Hactive+HFP
        Va : INTEGER := 5; --Vpulse
        Vb : INTEGER := 41; --Vpulse+VBP
        Vc : INTEGER := 1241; --Vpulse+VBP+Vactive
        Vd : INTEGER := 1375; --Vpulse+VBP+Vactive+VFP
        data_width : NATURAL := 512);

    PORT (
        start : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        px_clk : IN STD_LOGIC;
        data_write_tabu_in : IN STD_LOGIC;
        Hsync_out : OUT STD_LOGIC;
        Vsync_out : OUT STD_LOGIC;
        dena_out : OUT STD_LOGIC;
        data_rd_rqst : OUT STD_LOGIC;
        rd_addr_generating_rqst : OUT STD_LOGIC;
        sel : OUT STD_LOGIC_VECTOR (4 DOWNTO 0));
END Px_counter;

ARCHITECTURE Behavioral OF Px_counter IS

    CONSTANT px_amount : NATURAL := data_width / 24; -- pxs amount in one data line
    TYPE state_type IS (idle, counting);
    SIGNAL state, state_next : state_type := idle;
    -- SIGNAL Hactive_i_next : std_logic;
    SIGNAL Hactive_i : std_logic;
    -- SIGNAL Vactive_i_next : std_logic;
    SIGNAL Vactive_i : std_logic;
    SIGNAL Hcount_i : INTEGER RANGE 0 TO Hd := 0;
    SIGNAL Vcount_i : INTEGER RANGE 0 TO Vd := 0;
    SIGNAL px_amount_cnt : STD_LOGIC_VECTOR (4 DOWNTO 0);
    SIGNAL dena_i : std_logic;
    -- SIGNAL Hsync_i_next : STD_LOGIC;
    SIGNAL Hsync_i : STD_LOGIC;
    -- SIGNAL Vsync_i_next : STD_LOGIC;
    SIGNAL Vsync_i : STD_LOGIC;
    SIGNAL y_en : std_logic;
    -- SIGNAL y_en_next : std_logic;

    ATTRIBUTE KEEP : STRING;
    ATTRIBUTE KEEP OF state_next : SIGNAL IS "TRUE";
    ATTRIBUTE KEEP OF Hcount_i : SIGNAL IS "TRUE";
    ATTRIBUTE KEEP OF Vcount_i : SIGNAL IS "TRUE";
    ATTRIBUTE KEEP OF px_amount_cnt : SIGNAL IS "TRUE";

    ATTRIBUTE keep_hierarchy : STRING;
    ATTRIBUTE keep_hierarchy OF Behavioral : ARCHITECTURE IS "yes";
BEGIN

    sel <= px_amount_cnt;
    dena_out <= dena_i;
    Hsync_out <= Hsync_i;
    Vsync_out <= Vsync_i;

    state_register : PROCESS (px_clk, rst) BEGIN
        IF rising_edge(px_clk) THEN
            IF rst = '1' THEN
                state <= idle;
            ELSE
                state <= state_next;
            END IF;
        END IF;
    END PROCESS;

    -- PROCESS (ALL) BEGIN
    --     IF Hcount_i < Hd - 1 AND Hcount_i > Ha - 1 THEN
    --         Hsync_i_next <= '1';
    --     ELSE
    --         Hsync_i_next <= '0';
    --     END IF;

    --     IF Hcount_i < Hc - 1 AND Hcount_i > Ha - 1 THEN
    --         Hactive_i_next <= '1';
    --     ELSE
    --         Hactive_i_next <= '0';
    --     END IF;

    --     IF Hcount_i = Hd - 2 THEN
    --         y_en_next <= '1';
    --     ELSE
    --         y_en_next <= '0';
    --     END IF;
    -- END PROCESS;

    -- process (all) begin

    -- end process;

    Counters_next_state_logic_and_output_logic : PROCESS (ALL) BEGIN
        IF rising_edge(px_clk) THEN
            IF state = counting THEN
                Hcount_i <= Hcount_i + 4; -- pixel counter
                y_en <= '0';
                IF Hcount_i = Ha - 4 THEN
                    Hsync_i <= '1';
                    Hactive_i <= '0';
                ELSIF Hcount_i = Hb - 4 THEN
                    Hsync_i <= '1';
                    Hactive_i <= '1';
                ELSIF Hcount_i = Hc - 4 THEN
                    Hsync_i <= '1';
                    Hactive_i <= '0';
                ELSIF Hcount_i = Hd - 8 THEN
                    y_en <= '1'; -- row is ended
                    Hsync_i <= '1';
                    Hactive_i <= '0';
                ELSIF Hcount_i = Hd - 4 THEN
                    Hsync_i <= '0';
                    Hcount_i <= 0;
                    Hactive_i <= '0';
                END IF;

                IF y_en = '1' THEN
                    Vcount_i <= Vcount_i + 1; -- row counter
                    IF Vcount_i = Va - 1 THEN
                        Vsync_i <= '1';
                        Vactive_i <= '0';
                    ELSIF Vcount_i = Vb - 1 THEN
                        Vsync_i <= '1';
                        Vactive_i <= '1';
                    ELSIF Vcount_i = Vc - 1 THEN
                        Vsync_i <= '1';
                        Vactive_i <= '0';
                    ELSIF Vcount_i = Vd - 1 THEN
                        Vsync_i <= '0';
                        Vcount_i <= 0;
                        Vactive_i <= '0';
                    END IF;
                END IF;

                IF to_integer(unsigned(px_amount_cnt)) = px_amount - 1 THEN
                    px_amount_cnt <= (OTHERS => '0');
                ELSIF dena_i = '1' THEN
                    px_amount_cnt <= std_logic_vector(unsigned(px_amount_cnt) + 4);
                ELSE
                    px_amount_cnt <= (OTHERS => '0');
                END IF;

            ELSE
                y_en <= '0';
                px_amount_cnt <= (OTHERS => '0');
                Vactive_i <= '0';
                Hactive_i <= '0';
                Hsync_i <= '0';
                Vsync_i <= '0';
                Vcount_i <= 0;
                Hcount_i <= 0;
            END IF;
        END IF;
    END PROCESS;

    FSM_next_state_logic : PROCESS (ALL) BEGIN
        CASE state IS
            WHEN idle =>
                IF start = '1' AND data_write_tabu_in = '0' THEN
                    state_next <= counting;
                ELSE
                    state_next <= idle;
                END IF;

            WHEN counting =>
                IF data_write_tabu_in = '1' THEN
                    state_next <= idle;
                ELSE
                    state_next <= counting;
                END IF;
        END CASE;
    END PROCESS;

    requests_signals_output_logic : PROCESS (ALL) BEGIN
        IF px_amount_cnt = "00000" AND dena_i = '1' THEN
            data_rd_rqst <= '1';
        ELSE
            data_rd_rqst <= '0';
        END IF;

        IF Hcount_i = 0 AND Vcount_i = 0 THEN
            rd_addr_generating_rqst <= '1';
        ELSE
            rd_addr_generating_rqst <= '0';
        END IF;

    END PROCESS;

    --Display enable (dena)
    dena_i <= Hactive_i AND Vactive_i;
END Behavioral;