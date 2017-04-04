library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- register_8bit.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=CiMaWbz_6E8
-- The signals data_i and data_o will both be connected in parallel
-- to the main data bus, so they could alternatively be implemented
-- as 'inout' signals. But for now, I'm following the video as
-- closely as possible.
-- The enable pin here is active high, whereas in the video it is
-- active low.

entity register_8bit is

    port (
             -- Clock input from crystal (for delay)
             clk_i       : in  std_logic;

             -- Clear input
             clr_i       : in  std_logic;

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
        if clr_i = '1' then
            data <= (others => '0');
        elsif rising_edge(clk_i) then
            if load_i = '1' then
                data <= data_i;
            end if;
        end if;
    end process;

    reg_o <= data;
    data_o <= data when (enable_i = '1') else "ZZZZZZZZ";

end Structural;

