library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- memory_address_register.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=KNve2LCcSRc

entity memory_address_register is

    port (
             -- Clock input
             clk_i       : in  std_logic;

             -- Control inputs
             load_i      : in  std_logic; -- called MI

             -- Data bus connection
             address_i   : in  std_logic_vector (3 downto 0);

             -- To RAM module
             address_o   : out std_logic_vector (3 downto 0);

             -- Switches and buttons
             runmode_i   : in  std_logic;
             sw_i        : in  std_logic_vector (3 downto 0)
         );

end memory_address_register;

architecture Structural of memory_address_register is

    signal address : std_logic_vector(3 downto 0) := "0000";

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

