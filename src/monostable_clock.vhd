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

entity monostable_clock is

    generic (
                COUNTER_SIZE : integer := 16 -- for debouncing.
                -- 25 MHZ / 2^16 = 381 Hz, corresponding
                -- to a period of 2.6 ms.
            );

    port (
             -- Clock input from crystal (for debouncing)
             clk_i     : in  std_logic;

             -- Button input
             btn_i     : in  std_logic;

             -- Registered button output
             btn_reg_o : out std_logic);

end monostable_clock;

architecture Structural of monostable_clock is
    signal counter : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                     (others => '0');
    signal btn_reg : std_logic;
    constant ZERO  : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                     (others => '0');

begin
    process(clk_i) -- Just a simple counter.
    begin
        if rising_edge(clk_i) then
            counter <= counter + 1;
        end if;
    end process;

    process(clk_i) -- Sample the button input at regular intervals.
    begin
        if rising_edge(clk_i) then
            if counter = ZERO then
                btn_reg <= btn_i;
            end if;
        end if;
    end process;

    btn_reg_o <= btn_reg;

end Structural;

