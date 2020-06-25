library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity Mapper is
    Port ( mapper_in         : in  STD_LOGIC_VECTOR (63 downto 0);
           control_in        : in  STD_LOGIC_VECTOR (2 downto 0 );
           mapper_out        : out STD_LOGIC_VECTOR (83 downto 0));
end Mapper;

architecture Behavioral of Mapper is
-- aliases declaration for various parts of mapper_out signal         
    alias data_clk0 : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (83 downto 77) ; 
    alias dataA     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (76 downto 70) ;
    alias dataB     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (69 downto 63) ;
    alias dataC     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (62 downto 56) ;
    alias dataD     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (55 downto 49) ;
    alias dataE     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (48 downto 42) ;
    alias dataF     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (41 downto 35) ;
    alias dataG     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (34 downto 28) ;
    alias dataH     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (27 downto 21) ;
    alias dataI     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (20 downto 14) ;
    alias dataJ     : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (13 downto 7) ;
    alias data_clk1 : STD_LOGIC_VECTOR (6 downto 0) is mapper_out (6 downto 0) ;

begin

-- data remapping
--data_clk0 <= "1100011";     -- CLK0AB generating
--dataA     <= mapper_in(58) & mapper_in(59) & mapper_in(60) & mapper_in(61) & mapper_in(62) & mapper_in(63) & mapper_in(50); 
--dataB     <= mapper_in(51) & mapper_in(52) & mapper_in(53) & mapper_in(54) & mapper_in(55) & mapper_in(42) & mapper_in(43); 
--dataC     <= mapper_in(44) & mapper_in(45) & mapper_in(46) & mapper_in(47) & control_in; --control signals integration
--dataD     <= mapper_in(56) & mapper_in(57) & mapper_in(48) & mapper_in(49) & mapper_in(40) & mapper_in(41) & mapper_in(32); 
--dataE     <= mapper_in(33) & mapper_in(34) & mapper_in(35) & mapper_in(36) & mapper_in(37) & mapper_in(38) & mapper_in(39); 
--dataF     <= mapper_in(26) & mapper_in(27) & mapper_in(28) & mapper_in(29) & mapper_in(30) & mapper_in(31) & mapper_in(18); 
--dataG     <= mapper_in(19) & mapper_in(20) & mapper_in(21) & mapper_in(22) & mapper_in(23) & mapper_in(10) & mapper_in(11); 
--dataH     <= mapper_in(12) & mapper_in(13) & mapper_in(14) & mapper_in(15) & control_in; --control signals integration
--dataI     <= mapper_in(24) & mapper_in(25) & mapper_in(16) & mapper_in(17) & mapper_in(8) & mapper_in(9) & mapper_in(0); 
--dataJ     <= mapper_in(1)  & mapper_in(2)  & mapper_in(3)  & mapper_in(4)  & mapper_in(5) & mapper_in(6) & mapper_in(7); 
--data_clk1 <= "1100011";     -- CLK1AB generating

data_clk0 <= "1100011";     -- CLK0AB generating
dataA     <= mapper_in(50) & mapper_in(63) & mapper_in(62) & mapper_in(61) & mapper_in(60) & mapper_in(59) & mapper_in(58); 
dataB     <= mapper_in(43) & mapper_in(42) & mapper_in(55) & mapper_in(54) & mapper_in(53) & mapper_in(52) & mapper_in(51); 
dataC     <= control_in & mapper_in(47) & mapper_in(46) & mapper_in(45) & mapper_in(44) ; --control signals integration
dataD     <= mapper_in(32) & mapper_in(41) & mapper_in(40) & mapper_in(49) & mapper_in(48) & mapper_in(57) & mapper_in(56); 
dataE     <= mapper_in(39) & mapper_in(38) & mapper_in(37) & mapper_in(36) & mapper_in(35) & mapper_in(34) & mapper_in(33); 
dataF     <= mapper_in(18) & mapper_in(31) & mapper_in(30) & mapper_in(29) & mapper_in(28) & mapper_in(27) & mapper_in(26); 
dataG     <= mapper_in(11) & mapper_in(10) & mapper_in(23) & mapper_in(22) & mapper_in(21) & mapper_in(20) & mapper_in(19); 
dataH     <= control_in & mapper_in(15) & mapper_in(14) & mapper_in(13) & mapper_in(12) ; --control signals integration
dataI     <= mapper_in(0) & mapper_in(9) & mapper_in(8) & mapper_in(17) & mapper_in(16) & mapper_in(25) & mapper_in(24); 
dataJ     <= mapper_in(7)  & mapper_in(6)  & mapper_in(5)  & mapper_in(4)  & mapper_in(3) & mapper_in(2) & mapper_in(1); 
data_clk1 <= "1100011"; 

end Behavioral;
