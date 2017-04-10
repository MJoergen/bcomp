library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- monostable_clock.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=81BgFhm2vz8
-- The implementation is quite different from the video because of the
-- limitations of the FPGA, so we need access to the crystal clock
-- As soon as the button is pressed, the output is set high.
-- As soon as we release the button, a timer starts counting, and when it
-- reaches the maximum value, the output is reset again.

entity monostable_clock is

    generic (
                SIMULATION : boolean := false
            );

    port (
             -- Clock input from crystal (for delay)
             clk_i       : in  std_logic;

             -- Button input
             btn_i       : in  std_logic;

             -- Delayed (monostable) button output
             btn_delay_o : out std_logic);

end monostable_clock;

architecture Structural of monostable_clock is

    function get_counter_size (simulation : boolean) return integer
    is
    begin
        if simulation then
            return 2;
        else
            return 21; -- 40 ns * 2^21 = 0.1 s
        end if;
            
    end function;

    constant COUNTER_SIZE : integer := get_counter_size(SIMULATION);

    signal counter   : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                       (others => '0');
    signal btn_delay : std_logic;
    constant ZERO    : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                       (others => '0');
    constant ONES    : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                       (others => '1');

begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if btn_i = '1' then
                btn_delay <= '1';
                counter <= ZERO;
            elsif counter = ONES then
                btn_delay <= '0';
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    btn_delay_o <= btn_delay;

end Structural;

