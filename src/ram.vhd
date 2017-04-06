library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- ram.vhd
-- This entity implements the feature described in the video

-- This is a single port RAM.


entity ram is

    port (
             -- Address input
             address_i   : in std_logic_vector(3 downto 0);

             -- Data input and output
             data_io     : inout std_logic_vector(7 downto 0);

             -- LED's
             led_o       : out std_logic_vector(7 downto 0);

             -- Control inputs
             wr_i        : in std_logic;
             enable_i    : in std_logic);

end ram;

architecture Structural of ram is

    signal data : std_logic_vector(7 downto 0);

begin

    -- Instantiate high nibble
    inst_ram74ls189_high : entity work.ram74ls189
    port map (
                 address_i   => address_i           ,
                 data_i      => data_io(7 downto 4) ,
                 we_i        => wr_i                ,
                 cs_i        => '1'                 ,
                 data_o      => data(7 downto 4)
             );

    -- Instantiate low nibble
    inst_ram74ls189_low : entity work.ram74ls189
    port map (
                 address_i   => address_i           ,
                 data_i      => data_io(3 downto 0) ,
                 we_i        => wr_i                ,
                 cs_i        => '1'                 ,
                 data_o      => data(3 downto 0)
             );

    led_o <= data;
    data_io <= data when enable_i = '1' else "ZZZZZZZZ";

end Structural;

