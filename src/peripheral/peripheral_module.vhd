library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- peripheral_module.vhd

entity peripheral_module is

    port (
             -- Clock input from crystal.
             clk_i      : in  std_logic;

             -- Global reset.
             rst_i      : in  std_logic;

             -- Value to be shown on display
             data_i     : in  std_logic_vector (7 downto 0);

             -- Chip select
             cs_i       : in  std_logic;

             -- Display mode
             mode_i     : in  std_logic; -- '1' for two's complement.

             -- Output segment display
             seg_ca_o   : out std_logic_vector (6 downto 0);
             seg_dp_o   : out std_logic;
             seg_an_o   : out std_logic_vector (3 downto 0);

             -- LED's
             data_led_o : out std_logic_vector (7 downto 0)
         );

end peripheral_module;

architecture Structural of peripheral_module is

    signal value : std_logic_vector (7 downto 0);

begin

    data_led_o <= value;

    -- Instantiate Display
    inst_display : entity work.display
    port map (
                 clk_i       => clk_i    , -- Use crystal clock
                 two_comp_i  => mode_i   ,
                 value_i     => value    ,
                 seg_ca_o    => seg_ca_o ,
                 seg_dp_o    => seg_dp_o ,
                 seg_an_o    => seg_an_o 
             );

    -- Instantiate Output register
    inst_output_register : entity work.output_register
    port map (
                 clk_i       => clk_i  ,
                 clr_i       => rst_i  ,
                 data_i      => data_i ,
                 load_i      => cs_i   ,
                 reg_o       => value
             );

end Structural;

