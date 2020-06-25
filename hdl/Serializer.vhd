library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity Serializer is
    Port ( parallel_in    : in  STD_LOGIC_VECTOR (83 downto 0);
           serial_outputs : out STD_LOGIC_VECTOR (11 downto 0);
           reset          : in  STD_LOGIC; 
           px_clk         : in  STD_LOGIC;
           tx_clkdiv4     : in  STD_LOGIC; 
           tx_clkdiv2     : in  STD_LOGIC;
           data_write_tabu_out : out STD_LOGIC);           
end Serializer;

architecture Behavioral of Serializer is

begin

Serializer_7to1_0: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (83 downto 77),
    serial_out => serial_outputs(11),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => data_write_tabu_out);

Serializer_7to1_1: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (76 downto 70),
    serial_out => serial_outputs(10),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);
    
Serializer_7to1_2: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (69 downto 63),
    serial_out => serial_outputs(9),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);
    
Serializer_7to1_3: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (62 downto 56),
    serial_out => serial_outputs(8),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);
    
Serializer_7to1_4: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (55 downto 49),
    serial_out => serial_outputs(7),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);
    
Serializer_7to1_5: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (48 downto 42),
    serial_out => serial_outputs(6),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);
    
Serializer_7to1_6: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (41 downto 35),
    serial_out => serial_outputs(5),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);
    
Serializer_7to1_7: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (34 downto 28),
    serial_out => serial_outputs(4),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);
    
Serializer_7to1_8: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (27 downto 21),
    serial_out => serial_outputs(3),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);                            
    
Serializer_7to1_9: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (20 downto 14),
    serial_out => serial_outputs(2),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);
    
Serializer_7to1_10: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (13 downto 7),
    serial_out => serial_outputs(1),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);        

Serializer_7to1_11: entity work.Serializer_7to1 port map (
    FIFO_in    => parallel_in (6 downto 0),
    serial_out => serial_outputs(0),
    reset      => reset,
    px_clk     => px_clk,
    tx_clkdiv4 => tx_clkdiv4,
    tx_clkdiv2 => tx_clkdiv2,
    data_write_tabu_out => open);    
    
end Behavioral;
