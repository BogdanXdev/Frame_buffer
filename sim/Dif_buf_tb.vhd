library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity Dif_buf_tb is -- dif_buf functional manual testbench
end Dif_buf_tb;

architecture Behavioral of Dif_buf_tb is

--test signals declaration
signal d_in_tb     : std_logic_vector(11 downto 0) := x"000";
signal diff_out_tb : std_logic_vector(23 downto 0);

begin

-- DUT instantiating
dut: entity work.Dif_buf 
    port map (  
        d_in      => d_in_tb,
        diff_out  => diff_out_tb);

--stimuli generation
d_in_tb <= "101010101010",
           "010101010101" after 20 ns,
           "001100110011" after 40 ns,
           "110011001100" after 60 ns, 
           "000111000111" after 80 ns,
           "111000111000" after 100 ns,
           "000011110000" after 120 ns,
           "111100001111" after 140 ns,
           "000000000000" after 160 ns,
           "111111111111" after 180 ns,
           "000000000000" after 200 ns;

end Behavioral;
