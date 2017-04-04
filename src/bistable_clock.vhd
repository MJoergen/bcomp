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

entity bistable_clock is

    generic (
                COUNTER_SIZE : integer := 16 -- for delay
                -- 40 ns * 2^16 = 2.6 ms
            );

    port (
             -- Clock input from crystal (for delay)
             clk_i       : in  std_logic;

             -- Switch input
             sw_i        : in  std_logic;

             -- Registered switch output
             sw_reg_o    : out std_logic);

end bistable_clock;

architecture Structural of bistable_clock is
    signal counter : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                     (others => '0');
    signal sw_reg  : std_logic;
    constant ZERO  : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                     (others => '0');
    constant ONES  : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                     (others => '1');

begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            counter <= counter + 1;
        end if;
    end process;

    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if counter = ZERO then
                sw_reg <= sw_i;
            end if;
        end if;
    end process;

    sw_reg_o <= sw_reg;

end Structural;

