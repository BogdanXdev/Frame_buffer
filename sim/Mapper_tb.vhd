library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity Mapper_tb is
end Mapper_tb;

architecture Behavioral of Mapper_tb is

--testbench signals declarations
signal m_in_tb       : STD_LOGIC_VECTOR (63 downto 0);
signal control_in_tb : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal m_out_tb      : STD_LOGIC_VECTOR (83 downto 0);

constant in_pattern_6b : std_logic_vector (5 downto 0):= "000011";
constant in_pattern_8b : std_logic_vector (7 downto 0):= "00000111";
constant in_pattern_2b : std_logic_vector (1 downto 0):= "01";
   
begin

--dut instantiating
dut: entity work.Mapper 
    port map (
    m_in       => m_in_tb,
    control_in => control_in_tb,
    m_out      => m_out_tb);

--control signals generating
control_in_tb <=
    "001" after 20 ns,
    "010" after 40 ns,
    "011" after 60 ns,
    "100" after 80 ns,
    "101" after 100 ns,
    "110" after 120 ns,
    "111" after 140 ns,
    "000" after 160 ns;

-- input pattern generating                       
m_in_tb(63 downto 58) <= in_pattern_6b;
m_in_tb(55 downto 50) <= in_pattern_6b;           
m_in_tb(47 downto 42) <= in_pattern_6b;
m_in_tb(31 downto 26) <= in_pattern_6b; 
m_in_tb(23 downto 18) <= in_pattern_6b;
m_in_tb(15 downto 10) <= in_pattern_6b; 
 
m_in_tb(39 downto 32) <= in_pattern_8b;
m_in_tb(7 downto 0)   <= in_pattern_8b;

m_in_tb(57 downto 56)   <= in_pattern_2b; 
m_in_tb(49 downto 48)   <= in_pattern_2b;                  
m_in_tb(41 downto 40)   <= in_pattern_2b; 
m_in_tb(25 downto 24)   <= in_pattern_2b;
m_in_tb(17 downto 16)   <= in_pattern_2b;    
m_in_tb(9 downto 8)     <= in_pattern_2b;   
           
end Behavioral;
