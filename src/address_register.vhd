library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- address_register.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=KNve2LCcSRc

entity address_register is

    port (
             -- Clock input
             clk_i       : in  std_logic;

             -- Data bus connection
             address_i   : in  std_logic_vector (3 downto 0);

             -- Slide switches
             sw_i        : in  std_logic_vector (3 downto 0);

             -- Multiplexed address
             address_o   : out std_logic_vector (3 downto 0);

             -- Control inputs
             runmode_i   : in  std_logic;
             load_i      : in  std_logic);

end address_register;

architecture Structural of address_register is

    signal address : std_logic_vector(3 downto 0);

begin

    address_o <= sw_i when runmode_i = '0' else address;
    
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if load_i = '1' then
                address <= address_i;
            end if;
        end if;
    end process;

end Structural;

