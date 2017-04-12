library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- This is the top level
-- The video in https://www.youtube.com/watch?v=g_1HyxBzjl0 gives a 
-- high level view of the computer.

entity bcomp is

    generic (
                SIMULATION : boolean := false;
                FREQ       : integer := 25000000 -- Input clock frequency
            );
    port (
             -- Clock
             clk_i     : in  std_logic;  -- 25 MHz

             -- Input switches
             sw_i      : in  std_logic_vector (7 downto 0);

             -- Inputs from PMOD's
             pmod_i    : in  std_logic_vector (15 downto 0);

             -- Input buttons
             btn_i     : in  std_logic_vector (3 downto 0);

             -- Output LEDs
             led_o     : out std_logic_vector (7 downto 0);

             -- Output segment display
             seg_ca_o  : out std_logic_vector (6 downto 0);
             seg_dp_o  : out std_logic;
             seg_an_o  : out std_logic_vector (3 downto 0);

             -- VGA output
             vga_hs_o  : out std_logic;
             vga_vs_o  : out std_logic;
             vga_col_o : out std_logic_vector(7 downto 0)
         );

end bcomp;

architecture Structural of bcomp is

    -- The main internal clock
    signal clk  : std_logic;

    -- Interpretation of input buttons and switches.
    alias btn_clk        : std_logic is btn_i(0);
    alias btn_write      : std_logic is btn_i(1);
    alias btn_reset      : std_logic is btn_i(2);

    alias sw_clk_free    : std_logic is sw_i(0);
    alias sw_runmode     : std_logic is sw_i(1);

    alias led_select     : std_logic_vector (2 downto 0) is sw_i(4 downto 2);
    constant LED_SELECT_RAM  : std_logic_vector (2 downto 0) := "000";
    constant LED_SELECT_OUT  : std_logic_vector (2 downto 0) := "001";
    constant LED_SELECT_BUS  : std_logic_vector (2 downto 0) := "010";
    constant LED_SELECT_ALU  : std_logic_vector (2 downto 0) := "011";
    constant LED_SELECT_ADDR : std_logic_vector (2 downto 0) := "100";
    constant LED_SELECT_AREG : std_logic_vector (2 downto 0) := "101";
    constant LED_SELECT_BREG : std_logic_vector (2 downto 0) := "110";
    constant LED_SELECT_PC   : std_logic_vector (2 downto 0) := "111";

    alias sw_disp_two_comp : std_logic is sw_i(5); -- Display two's complement

    -- Used for programming the RAM.
    alias pmod_address     : std_logic_vector (3 downto 0) is pmod_i(11 downto 8);
    alias pmod_data        : std_logic_vector (7 downto 0) is pmod_i( 7 downto 0);

    -- The main data bus
    -- All the blocks connected to the data bus
    -- must have an enable_i pin telling the block,
    -- whether to output data to the bus or not.
    -- Additionally, all these blocks provide
    -- access to the data before the output buffer.
    -- These blocks are: 
    --   A-register
    --   B-register
    --   instruction register
    --   ALU
    --   RAM
    --   Program counter
    signal data     : std_logic_vector (7 downto 0);

    signal addr_cpu : std_logic_vector (3 downto 0);
    signal addr_ram : std_logic_vector (3 downto 0);
    signal out_cs   : std_logic;
    signal ram_cs   : std_logic;
    signal ram_wr   : std_logic;
    signal hlt      : std_logic;

    signal led_array_cpu : std_logic_vector (8*8-1 downto 0);
    signal led_array     : std_logic_vector (11*8-1 downto 0);
    signal ram_value     : std_logic_vector (7 downto 0);
    signal disp_value    : std_logic_vector (7 downto 0);

begin

    led_array <= led_array_cpu &
                 disp_value &                -- OUT
                 "0000" & addr_ram &         -- ADDR
                 ram_value;                  -- RAM

    led_o <= led_array(conv_integer(led_select)*8+7 downto conv_integer(led_select)*8);

    addr_ram <= pmod_address when sw_runmode = '0' else addr_cpu;

    -- Instantiate Clock module
    inst_clock_module : entity work.clock_module
    generic map (
                    SIMULATION => SIMULATION
                )
    port map (
                 clk_i       => clk_i       , -- External crystal
                 sw_i        => sw_clk_free ,
                 btn_i       => btn_clk     ,
                 hlt_i       => hlt         ,
                 clk_deriv_o => clk           -- Main internal clock
             );

    -- Instantiate CPU module
    inst_cpu_module : entity work.cpu_module
    port map (
                 clk_i       => clk           ,
                 rst_i       => btn_reset     ,
                 addr_o      => addr_cpu      ,
                 data_io     => data          ,
                 out_cs_o    => out_cs        ,
                 ram_cs_o    => ram_cs        ,
                 ram_wr_o    => ram_wr        ,
                 hlt_o       => hlt           ,
                 led_array_o => led_array_cpu
             );

    -- Instantiate RAM module
    inst_ram_module : entity work.ram_module
    generic map (
                    INITIAL_HIGH => (
                        "0111", "0100", "0111", "0101", "0010", "0100", "0001", "0100",
                        "0001", "0100", "0001", "1000", "0110", "0000", "0000", "0000"),
                    INITIAL_LOW => (
                        "0001", "1110", "0000", "0000", "1110", "1111", "1110", "1101",
                        "1111", "1110", "1101", "0000", "0011", "0000", "0000", "0000")
                )
    port map (
                 clk_i       => clk           ,
                 wr_i        => ram_wr        ,
                 enable_i    => ram_cs        ,
                 data_io     => data          ,
                 address_i   => addr_ram      ,
                 runmode_i   => sw_runmode    ,
                 sw_data_i   => pmod_data     ,
                 wr_button_i => btn_write     ,
                 data_led_o  => ram_value       -- Debug output
             );

    -- Instantiate VGA module
    inst_vga_module : entity work.vga_module
    port map (
                 clk_i       => clk_i      , -- 25 MHz crystal clock
                 led_array_i => led_array  ,
                 vga_HS_o    => vga_hs_o   ,
                 vga_VS_o    => vga_vs_o   ,
                 vga_col_o   => vga_col_o
             );

    -- Instantiate Peripheral module
    inst_peripheral_module : entity work.peripheral_module
    port map (
                 clk_i      => clk_i            , -- 25 MHz crystal clock
                 rst_i      => btn_reset        ,
                 data_i     => data             ,
                 cs_i       => out_cs           ,
                 mode_i     => sw_disp_two_comp ,
                 seg_ca_o   => seg_ca_o         ,
                 seg_dp_o   => seg_dp_o         ,
                 seg_an_o   => seg_an_o         ,
                 data_led_o => disp_value
             );

end Structural;

