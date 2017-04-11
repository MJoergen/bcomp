library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- astable_clock.vhd

entity astable_clock is

    generic (
                SIMULATION : boolean := false
            );

    port (
             -- Clock input from crystal (for delay)
             clk_i       : in  std_logic;

             -- Clock output (slower)
             clk_o       : out std_logic);

end astable_clock;

architecture Structural of astable_clock is

    function get_counter_size (simulation : boolean) return integer
    is
    begin
        if simulation then
            return 2;
        else
            return 23; -- 40 ns * 2^23 = 0.4 s (half a period)
        end if;
            
    end function;

    constant COUNTER_SIZE : integer := get_counter_size(SIMULATION);

    signal counter   : std_logic_vector(COUNTER_SIZE-1 downto 0) :=
                       (others => '0');

    signal clk : std_logic := '1';

begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if counter = 0 then
                clk <= not clk;
            end if;
            counter <= counter + 1;
        end if;
    end process;

    clk_o <= clk;

end Structural;

