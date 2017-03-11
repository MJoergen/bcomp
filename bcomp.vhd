library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcomp is

   generic (
       FREQ       : integer := 25000000 -- Input clock frequency
       );
   port (
      -- Clock
      vga_clk_i   : in  std_logic;  -- 25 MHz

      -- Input switches
      sw_i        : in  std_logic_vector (7 downto 0);

      -- Input buttons
      btn_i       : in  std_logic_vector (3 downto 0);

      -- Output LEDs
      led_o       : out std_logic_vector (7 downto 0);

      -- Output segment display
      seg_ca_o    : out std_logic_vector (6 downto 0);
      seg_dp_o    : out std_logic;
      seg_an_o    : out std_logic_vector (3 downto 0)

      -- VGA port
      --vga_hs_o    : out std_logic; 
      --vga_vs_o    : out std_logic;
      --vga_red_o   : out std_logic_vector (2 downto 0); 
      --vga_green_o : out std_logic_vector (2 downto 0); 
      --vga_blue_o  : out std_logic_vector (2 downto 1)
      );

end bcomp;

architecture Structural of bcomp is

begin

    -- Just copy the input switches to the output LED's.
    led_o(7 downto 0) <= sw_i(7 downto 0);
    seg_ca_o <= "1111111";
    seg_dp_o <= '1';
    seg_an_o <= "1111";

end Structural;

