library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcomp is

   generic (
       FREQ       : integer := 25000000 -- Input clock frequency
       );
   port (
      -- Clock
      clk_i       : in  std_logic;  -- 25 MHz

      -- Input switches
      sw_i        : in  std_logic_vector (7 downto 0);

      -- Input buttons
      btn_i       : in  std_logic_vector (3 downto 0);

      -- pragma synthesis_off
      data_i      : in  std_logic_vector (7 downto 0);
      -- pragma synthesis_on

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

    -- The main clock
    signal clk  : std_logic;

    -- The main data bus
    signal data : std_logic_vector(7 downto 0);

begin

    -- pragma synthesis_off
    data <= data_i;
    -- pragma synthesis_on

    -- Instantiate clock module
    inst_clock_logic : entity work.clock_logic
    port map (
                 clk_i       => clk_i     ,
                 sw_i        => sw_i(7)   ,
                 btn_i       => btn_i(0)  ,
                 hlt_i       => '0'       ,
                 clk_deriv_o => clk
             );

    -- Instantiate A-register
    inst_a_register : entity work.register_8bit
    port map (
                 clk_i       => clk    ,
                 clr_i       => sw_i(0),
                 data_io     => data   ,
                 reg_o       => open   ,
                 load_i      => sw_i(1),
                 enable_i    => sw_i(2)
             );

    -- Instantiate B-register
    inst_b_register : entity work.register_8bit
    port map (
                 clk_i       => clk    ,
                 clr_i       => sw_i(0),
                 data_io     => data   ,
                 reg_o       => open   ,
                 load_i      => sw_i(3),
                 enable_i    => sw_i(4)
             );

    -- Instantiate instruction register
    inst_instruction_register : entity work.register_8bit
    port map (
                 clk_i       => clk    ,
                 clr_i       => sw_i(0),
                 data_io     => data   ,
                 reg_o       => open   ,
                 load_i      => sw_i(5),
                 enable_i    => sw_i(6)
             );

    -- Just copy the data bus to the output LED's.
    led_o <= data;
    seg_ca_o <= "1111111";
    seg_dp_o <= '1';
    seg_an_o <= "1111";

end Structural;

