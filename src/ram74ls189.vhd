library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- ram74ls189.vhd
-- This entity emulates the RAM chip 74LS189 described in the video:
-- https://www.youtube.com/watch?v=FnxPIZR1ybs
-- Deviations from the chip:
-- * Data outputs are NOT inverted.
-- * Control inputs are active high.
-- * Writes are made synchronous (on rising edge of we_i).
--   This improves the clock routing in the FPGA.

-- This is a single port RAM.


entity ram74ls189 is

    port (
             -- Address input
             address_i   : in std_logic_vector(3 downto 0);

             -- Data input
             data_i      : in std_logic_vector(3 downto 0);

             -- Data output
             data_o      : out std_logic_vector(3 downto 0);

             -- Control inputs
             we_i        : in std_logic;
             cs_i        : in std_logic);

end ram74ls189;

architecture Structural of ram74ls189 is

    type ram_type is array (0 to 15) of std_logic_vector(3 downto 0);
    signal data : ram_type;

begin

    data_o <= data(conv_integer(address_i))
              when cs_i = '1' and we_i = '0' else "ZZZZ";

    process (we_i)
    begin
        if rising_edge(we_i) then
            data(conv_integer(address_i)) <= data_i;
        end if;
    end process;

end Structural;

