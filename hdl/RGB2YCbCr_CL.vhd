library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity RGB2YCbCr_CL is  --interface for 1 px input and output
    Port ( R_in  : in  STD_LOGIC_VECTOR (7 downto 0);
           G_in  : in  STD_LOGIC_VECTOR (7 downto 0);
           B_in  : in  STD_LOGIC_VECTOR (7 downto 0);
           Y_out : out STD_LOGIC_VECTOR (7 downto 0);
           Cb_out: out STD_LOGIC_VECTOR (7 downto 0);
           Cr_out: out STD_LOGIC_VECTOR (7 downto 0));
end RGB2YCbCr_CL;

architecture Behavioral of RGB2YCbCr_CL is
--16b signals declaration for making possible to apply shifting logic
signal R16_i : std_logic_vector (15 downto 0);
signal G16_i : std_logic_vector (15 downto 0);
signal B16_i : std_logic_vector (15 downto 0);
signal Y16_i : std_logic_vector (15 downto 0);
signal Cb16_i: std_logic_vector (15 downto 0);
signal Cr16_i: std_logic_vector (15 downto 0);

-- attribute KEEP : string;
-- attribute KEEP of R16_i  : signal is "TRUE";
-- attribute KEEP of G16_i  : signal is "TRUE";
-- attribute KEEP of B16_i  : signal is "TRUE";
-- attribute KEEP of Y16_i  : signal is "TRUE";
-- attribute KEEP of Cb16_i : signal is "TRUE";
-- attribute KEEP of Cr16_i : signal is "TRUE";

-- attribute keep_hierarchy : string;
-- attribute keep_hierarchy of Behavioral : architecture is "yes";

begin

-- 16b signals
R16_i <= x"00" & R_in;
G16_i <= x"00" & G_in;
B16_i <= x"00" & B_in;

-- combinational logic for RGB2Y converting
Y16_i <= std_logic_vector(
    16  + shift_right(((shift_left(unsigned(R16_i),6) + shift_left(unsigned(R16_i),1)) +
    (shift_left(unsigned(G16_i),7) + unsigned(G16_i)) +
    (shift_left(unsigned(B16_i),4) + shift_left(unsigned(B16_i),3) + unsigned(B16_i))),8)
);
--output signal Y
Y_out <= Y16_i (7 downto 0);

-- combinational logic for RGB2Cb converting
Cb16_i <= std_logic_vector(
     128 + shift_right(((shift_left(unsigned(B16_i),7) - shift_left(unsigned(B16_i),4)) -
    (shift_left(unsigned(G16_i),6) + shift_left(unsigned(G16_i),3) + shift_left(unsigned(G16_i),1)) -
    (shift_left(unsigned(R16_i),5) + shift_left(unsigned(R16_i),2) + shift_left(unsigned(R16_i),1))),8)
);
--output signal Cb
Cb_out <= Cb16_i (7 downto 0);

-- combinational logic for RGB2Cr converting
Cr16_i <= std_logic_vector(
    128 + shift_right(((shift_left(unsigned(R16_i),7) - shift_left(unsigned(R16_i),4)) -
    (shift_left(unsigned(G16_i),6) + shift_left(unsigned(G16_i),5) - shift_left(unsigned(G16_i),1)) -
    (shift_left(unsigned(B16_i),4) + shift_left(unsigned(B16_i),1))),8)
);
--output signal Cr
Cr_out <= Cr16_i (7 downto 0);

end Behavioral;