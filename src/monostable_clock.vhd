library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- monostable_clock.vhd
-- This entity implements the feature described in
-- the video https://www.youtube.com/watch?v=81BgFhm2vz8
-- The implementation is quite different from the video
-- because of the limitations of the FPGA, so we
-- need access to the crystal clock
-- Once every millisecond the push button is stored in a register,
-- and this provides the debouncing functionality.

entity bistable_clock is

    generic (
                COUNTER_SIZE : integer := 21 -- for delay
                -- 40 ns * 2^21 = 0.1 s
            );

    port (
             -- Clock input from crystal (for delay)
             clk_i       : in  std_logic;

             -- Button input
             btn_i       : in  std_logic;

             -- Registered button output
             btn_delay_o : out std_logic);

end bistable_clock;

architecture Structural of bistable_clock is
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

