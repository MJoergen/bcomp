library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.ram74ls189_datatypes.all;

-- ram_module.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=Vw3uDOUJRGw

entity ram_module is

    generic (
                INITIAL_HIGH : ram_type := (others => "0000");
                INITIAL_LOW  : ram_type := (others => "0000")
            );
    port (
             -- System clock
             clk_i          : in std_logic;

             -- Control inputs
             wr_i           : in std_logic; -- called RI
             enable_i       : in std_logic; -- called RO

             -- Data bus connection
             data_io        : inout std_logic_vector(7 downto 0);

             -- From memory_address_register
             address_i      : in  std_logic_vector(3 downto 0);

             -- Switches and buttons
             runmode_i      : in  std_logic;
             sw_data_i      : in  std_logic_vector(7 downto 0);
             wr_button_i    : in  std_logic;

             -- LED's
             data_led_o     : out std_logic_vector(7 downto 0)
         );

end ram_module;

architecture Structural of ram_module is

    signal data_in  : std_logic_vector(7 downto 0);
    signal data_out : std_logic_vector(7 downto 0);
    signal wr       : std_logic;

begin

    data_in <= data_io when runmode_i = '1' else sw_data_i;
    wr <= wr_i when runmode_i = '1' else wr_button_i;

    -- Instantiate high nibble
    inst_ram74ls189_high : entity work.ram74ls189
    generic map (
                    INITIAL => INITIAL_HIGH
                )
    port map (
                 clk_i       => clk_i               ,
                 address_i   => address_i           ,
                 data_i      => data_in(7 downto 4) ,
                 we_i        => wr                  ,
                 cs_i        => '1'                 ,
                 data_o      => data_out(7 downto 4)
             );

    -- Instantiate low nibble
    inst_ram74ls189_low : entity work.ram74ls189
    generic map (
                    INITIAL => INITIAL_LOW
                )
    port map (
                 clk_i       => clk_i               ,
                 address_i   => address_i           ,
                 data_i      => data_in(3 downto 0) ,
                 we_i        => wr                  ,
                 cs_i        => '1'                 ,
                 data_o      => data_out(3 downto 0)
             );

    data_led_o <= data_out;
    data_io <= data_out when enable_i = '1' else "ZZZZZZZZ";

end Structural;

