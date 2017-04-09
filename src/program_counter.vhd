library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- program_counter.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=g_1HyxBzjl0

entity program_counter is

    port (
             -- Clock input
             clk_i       : in std_logic;

             -- Control inputs
             load_i      : in std_logic; -- called J
             enable_i    : in std_logic; -- called CO.
             count_i     : in std_logic; -- called CE.
             clr_i       : in std_logic;

             -- Data bus connection
             data_io     : inout std_logic_vector(7 downto 0);

             -- LED output
             led_o       : out std_logic_vector (3 downto 0)
         );


end program_counter;

architecture Structural of program_counter is

    signal data : std_logic_vector(3 downto 0);

begin
    -- pragma synthesis_off
    assert (load_i and enable_i) /= '1';
    -- pragma synthesis_on
    
    process(clk_i, clr_i)
    begin
        if clr_i = '1' then
            data <= (others => '0');
        elsif rising_edge(clk_i) then
            if load_i = '1' then
                data <= data_io(3 downto 0);
            elsif count_i = '1' then
                data <= data + "0001";
            end if;
        end if;
    end process;

    led_o <= data;
    data_io <= "0000" & data when (enable_i = '1') else "ZZZZZZZZ";

end Structural;

