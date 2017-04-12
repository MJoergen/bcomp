library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- vga_module.vhd

entity vga_module is

    port (
             -- Clock input from crystal.
             clk_i       : in  std_logic;

             -- These are the LED values to show
             led_array_i : in  std_logic_vector (63 downto 0);

             -- VGA output
             vga_hs_o    : out std_logic;
             vga_vs_o    : out std_logic;
             vga_col_o   : out std_logic_vector(7 downto 0)
         );

end vga_module;

architecture Structural of vga_module is

    -- VGA timing signals
    signal hcount     : std_logic_vector(10 downto 0); 
    signal vcount     : std_logic_vector(10 downto 0); 
    signal blank      : std_logic;                     

begin

    -- Instantiate VGA display
    inst_vga_disp : entity work.vga_disp
    generic map (
                    NAMES => (          -- @ is used for space.
                        "@@@@BUS",
                        "@@@@ALU",
                        "@@@@RAM",
                        "@@@ADDR",
                        "@@@AREG",
                        "@@@BREG",
                        "@@@@OUT",
                        "@@@@@PC")
                )
    port map (
                 hcount_i    => hcount      ,
                 vcount_i    => vcount      ,
                 blank_i     => blank       ,
                 led_array_i => led_array_i ,
                 vga_o       => vga_col_o
             );

    -- This generates the VGA timing signals
    inst_vga_controller_640_60 : entity work.vga_controller_640_60
    port map (
                 rst_i     => '0'      , -- Not used.
                 vga_clk_i => clk_i    , -- 25 MHz crystal clock
                 HS_o      => vga_hs_o ,
                 VS_o      => vga_vs_o ,
                 hcount_o  => hcount   ,
                 vcount_o  => vcount   ,
                 blank_o   => blank
             );

end Structural;

