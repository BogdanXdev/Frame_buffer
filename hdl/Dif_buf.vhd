library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;
entity Dif_buf is
    Port ( diff_in     : in  STD_LOGIC_VECTOR (11 downto 0);
           diff_out    : out STD_LOGIC_VECTOR (23 downto 0));
end Dif_buf;

architecture Behavioral of Dif_buf is

--aliases declaration for various parts of diff_in signal 
alias CLK0AB: std_logic is diff_in (11);
alias LV0AB:  std_logic is diff_in (10);
alias LV1AB:  std_logic is diff_in (9);
alias LV2AB:  std_logic is diff_in (8);
alias LV3AB:  std_logic is diff_in (7);
alias LV4AB:  std_logic is diff_in (6);
alias LV5AB:  std_logic is diff_in (5);
alias LV6AB:  std_logic is diff_in (4);
alias LV7AB:  std_logic is diff_in (3);
alias LV8AB:  std_logic is diff_in (2);
alias LV9AB:  std_logic is diff_in (1);
alias CLK1AB: std_logic is diff_in (0);

--aliases declaration for various parts of diff_out signal 
alias CLK0A: std_logic is diff_out (23);
alias LV0A:  std_logic is diff_out (21);
alias LV1A:  std_logic is diff_out (19);
alias LV2A:  std_logic is diff_out (17);
alias LV3A:  std_logic is diff_out (15);
alias LV4A:  std_logic is diff_out (13);
alias LV5A:  std_logic is diff_out (11);
alias LV6A:  std_logic is diff_out (9);
alias LV7A:  std_logic is diff_out (7);
alias LV8A:  std_logic is diff_out (5);
alias LV9A:  std_logic is diff_out (3);
alias CLK1A: std_logic is diff_out (1);

--aliases declaration for various parts of diff_out signal 
alias CLK0B: std_logic is diff_out (22);
alias LV0B:  std_logic is diff_out (20);
alias LV1B:  std_logic is diff_out (18);
alias LV2B:  std_logic is diff_out (16);
alias LV3B:  std_logic is diff_out (14);
alias LV4B:  std_logic is diff_out (12);
alias LV5B:  std_logic is diff_out (10);
alias LV6B:  std_logic is diff_out (8);
alias LV7B:  std_logic is diff_out (6);
alias LV8B:  std_logic is diff_out (4);
alias LV9B:  std_logic is diff_out (2);
alias CLK1B: std_logic is diff_out (0);

begin

--differential buffers instantiation
OBUFDS_CLK0AB : OBUFDS
   port map (
      O  =>  CLK0A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  CLK0B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  CLK0AB    -- 1-bit input: Buffer input
   );
  
OBUFDS_LV0AB : OBUFDS
   port map (
      O  =>  LV0A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV0B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV0AB    -- 1-bit input: Buffer input
   );   

OBUFDS_LV1AB : OBUFDS
   port map (
      O  =>  LV1A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV1B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV1AB    -- 1-bit input: Buffer input
   );
   
OBUFDS_LV2AB : OBUFDS
   port map (
      O  =>  LV2A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV2B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV2AB    -- 1-bit input: Buffer input
   );
   
OBUFDS_LV3AB : OBUFDS
   port map (
      O  =>  LV3A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV3B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV3AB    -- 1-bit input: Buffer input
   );
   
OBUFDS_LV4AB : OBUFDS
   port map (
      O  =>  LV4A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV4B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV4AB    -- 1-bit input: Buffer input
   );

OBUFDS_LV5AB : OBUFDS
   port map (
      O  =>  LV5A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV5B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV5AB    -- 1-bit input: Buffer input
   );
   
OBUFDS_LV6AB : OBUFDS
   port map (
      O  =>  LV6A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV6B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV6AB    -- 1-bit input: Buffer input
   );       
   
OBUFDS_LV7AB : OBUFDS
   port map (
      O  =>  LV7A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV7B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV7AB    -- 1-bit input: Buffer input
   );       
   
OBUFDS_LV8AB : OBUFDS
   port map (
      O  =>  LV8A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV8B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV8AB    -- 1-bit input: Buffer input
   );       
   
OBUFDS_LV9AB : OBUFDS
   port map (
      O  =>  LV9A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  LV9B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  LV9AB    -- 1-bit input: Buffer input
   );   
   
OBUFDS_CLK1AB : OBUFDS
   port map (
      O  =>  CLK1A,   -- 1-bit output: Diff_p output (connect directly to top-level port)
      OB =>  CLK1B, -- 1-bit output: Diff_n output (connect directly to top-level port)
      I  =>  CLK1AB    -- 1-bit input: Buffer input
   );   
end Behavioral;
