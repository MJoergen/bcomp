library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- bistable_clock.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=WCwJNnx36Rk
-- The implementation is quite different from the video because of the
-- way the switches are hooked up on the Basys2 board. In the video,
-- he uses a double throw switch, but the Basys2 board only has 
-- single throw switches. So instead we implement debouncing
-- uses a regular timer, based on the crystal clock.

entity register_8bit is

    port (
             -- Clock input from crystal (for delay)
             clk_i       : in  std_logic;

             -- Data input
             data_i      : in  std_logic_vector(7 downto 0);

             -- Data output
             data_o      : out std_logic_vector(7 downto 0);

             -- Register output
             reg_o       : out std_logic_vector(7 downto 0);

             -- Control inputs
             load_i      : in  std_logic;
             enable_i    : in  std_logic);

end register_8bit;

architecture Structural of register_8bit is

    signal data : std_logic_vector(7 downto 0);

begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if load_i = '1' then
                data <= data_i;
            end if;
        end if;
    end process;

    reg_o <= data;
    data_o <= data when (enable_i = '1') else "ZZZZZZZZ";

end Structural;

