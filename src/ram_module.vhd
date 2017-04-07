library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- ram_module.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=Vw3uDOUJRGw

entity ram_module is

    port (
             -- System clock
             clk_i          : in std_logic;

             -- Control inputs
             address_load_i : in std_logic;
             wr_i           : in std_logic;
             enable_i       : in std_logic;

             -- Data input and output
             data_io        : inout std_logic_vector(7 downto 0);

             -- Switches and buttons
             runmode_i      : in  std_logic;
             sw_address_i   : in  std_logic_vector(3 downto 0);
             sw_data_i      : in  std_logic_vector(7 downto 0);
             wr_button_i    : in  std_logic;

             -- LED's
             address_led_o  : out std_logic_vector(3 downto 0);
             data_led_o     : out std_logic_vector(7 downto 0)
         );

end ram_module;

architecture Structural of ram_module is

    signal address  : std_logic_vector(3 downto 0);
    signal data_in  : std_logic_vector(7 downto 0);
    signal data_out : std_logic_vector(7 downto 0);
    signal wr       : std_logic;

begin

    -- Instantiate address register
    inst_address_register : entity work.address_register
    port map (
                 clk_i       => clk_i               ,
                 address_i   => data_io(3 downto 0) ,
                 sw_i        => sw_address_i        ,
                 address_o   => address             ,
                 runmode_i   => runmode_i           ,
                 load_i      => address_load_i
             );

    address_led_o <= address;

    data_in <= data_io when runmode_i = '1' else sw_data_i;
    wr <= wr_i when runmode_i = '1' else wr_button_i;
    data_io <= data_out;

    -- Instantiate RAM
    inst_ram : entity work.ram
    port map (
                 address_i    => address    ,
                 data_in_i    => data_in    ,
                 data_out_o   => data_out   ,
                 led_o        => data_led_o ,
                 wr_i         => wr         ,
                 enable_i     => enable_i
             );

end Structural;

