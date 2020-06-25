library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
entity RGB2YCbCr_tb is
end RGB2YCbCr_tb;

architecture functional of RGB2YCbCr_tb is

-- testbench signals declaration
signal px_clk_tb, reset_tb: std_logic := '0';
signal RGB_in_tb          : std_logic_vector(95 downto 0) := x"000000000000000000000000";
signal YCbCr_out_reg_tb   : std_logic_vector(63 downto 0);

--aliases declaration for various parts of RGB_in signal 
alias R_px0: std_logic_vector(7 downto 0) is RGB_in_tb (95 downto 88);
alias G_px0: std_logic_vector(7 downto 0) is RGB_in_tb (87 downto 80);
alias B_px0: std_logic_vector(7 downto 0) is RGB_in_tb (79 downto 72);
alias R_px1: std_logic_vector(7 downto 0) is RGB_in_tb (71 downto 64);
alias G_px1: std_logic_vector(7 downto 0) is RGB_in_tb (63 downto 56);
alias B_px1: std_logic_vector(7 downto 0) is RGB_in_tb (55 downto 48);
alias R_px2: std_logic_vector(7 downto 0) is RGB_in_tb (47 downto 40);
alias G_px2: std_logic_vector(7 downto 0) is RGB_in_tb (39 downto 32);
alias B_px2: std_logic_vector(7 downto 0) is RGB_in_tb (31 downto 24);
alias R_px3: std_logic_vector(7 downto 0) is RGB_in_tb (23 downto 16);
alias G_px3: std_logic_vector(7 downto 0) is RGB_in_tb (15 downto 8);
alias B_px3: std_logic_vector(7 downto 0) is RGB_in_tb (7 downto 0);

begin

-- RGB_to_YCbCr - device under a test instantiation
dut: entity work.RGB_to_YCbCr 
    port map(
        RGB_in          => RGB_in_tb,
        YCbCr_out_reg   => YCbCr_out_reg_tb,
        px_clk          => px_clk_tb,
        reset           => reset_tb);
        
--px_clk = 74.25MHz generation, for RGB_to_YCbCr output register 
px_clk_tb <= not px_clk_tb after 6.734 ns;
--reset signal generation
reset_tb  <= '1' after 6.734 ns, '0' after 26.936 ns;

-- random RGB input with counter incrementing input signals value by 1 in 
-- each rising edge of clock
process(px_clk_tb)
    variable i : integer := 0;
begin
    if (px_clk_tb'event and px_clk_tb = '1') then       
        if ( i < 255 ) then 
            R_px0 <= std_logic_vector(to_unsigned(i + 2 , R_px0'length));
            G_px0 <= std_logic_vector(to_unsigned(i + 4 , R_px0'length));
            B_px0 <= std_logic_vector(to_unsigned(i + 8 , R_px0'length));
            
            R_px1 <= std_logic_vector(to_unsigned(i     , R_px0'length));
            G_px1 <= std_logic_vector(to_unsigned(i + 4 , R_px0'length));
            B_px1 <= std_logic_vector(to_unsigned(i + 16, R_px0'length));
            
            R_px2 <= std_logic_vector(to_unsigned(i + 16 , R_px0'length));
            G_px2 <= std_logic_vector(to_unsigned(i + 32 , R_px0'length));
            B_px2 <= std_logic_vector(to_unsigned(i +  4 , R_px0'length));
            
            R_px3 <= std_logic_vector(to_unsigned(i + 128, R_px0'length));
            G_px3 <= std_logic_vector(to_unsigned(i      , R_px0'length));
            B_px3 <= std_logic_vector(to_unsigned(i + 4  , R_px0'length)); 
               
        end if; 
        i := i+1;  
    end if;
end process;    
end functional;


--aliases declaration for various parts of YCbCr_out_next signal 
--alias Y_px0:  std_logic_vector(7 downto 0) is YCbCr_out_reg_tb (63 downto 56);
--alias Cb_px0: std_logic_vector(7 downto 0) is YCbCr_out_reg_tb (55 downto 48);
--alias Cr_px0: std_logic_vector(7 downto 0) is YCbCr_out_reg_tb (47 downto 40);
--alias Y_px1:  std_logic_vector(7 downto 0) is YCbCr_out_reg_tb (39 downto 32);
--alias Y_px2:  std_logic_vector(7 downto 0) is YCbCr_out_reg_tb (31 downto 24);
--alias Cb_px2: std_logic_vector(7 downto 0) is YCbCr_out_reg_tb (23 downto 16);
--alias Cr_px2: std_logic_vector(7 downto 0) is YCbCr_out_reg_tb (15 downto 8);
--alias Y_px3:  std_logic_vector(7 downto 0) is YCbCr_out_reg_tb (7 downto 0);

--theoretical aryhmetic results