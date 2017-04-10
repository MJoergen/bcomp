library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity monostable_clock_tb is
end monostable_clock_tb ;

architecture Structural of monostable_clock_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Push button
    signal btn       : std_logic;
    signal btn_delay : std_logic;


begin
    -- Generate clock
    clk_gen : process
    begin
        if not test_running then
            wait;
        end if;

        clk <= '1', '0' after 20 ns;
        wait for 40 ns;
    end process clk_gen;

    -- Instantiate DUT
    inst_monostable_clock : entity work.monostable_clock
    generic map (
                    SIMULATION => true -- Much shorter counter during simulation.
                )
    port map (
                 clk_i       => clk    ,
                 btn_i       => btn    ,
                 btn_delay_o => btn_delay
             );

    -- Start the main test
    main_test : process is
    begin
        wait for 80 ns;

        -- Verify btn_delay goes high immediately.
        btn <= '1';
        wait for 40 ns;
        assert btn_delay = '1';

        -- Verify btn_delay stays high.
        wait for 160 ns;
        assert btn_delay = '1';

        -- Verify btn_delay goes low at the right time (after 4 clock cycles in simulation).
        btn <= '0';
        wait for 40 ns;
        assert btn_delay = '1';
        wait for 40 ns;
        assert btn_delay = '1';
        wait for 40 ns;
        assert btn_delay = '1';
        wait for 40 ns;
        assert btn_delay = '0';

        -- Verify btn_delay stays low.
        wait for 160 ns;
        assert btn_delay = '0';

        -- Verify btn_delay goes high immediately.
        btn <= '1';
        wait for 40 ns;
        assert btn_delay = '1';

        -- Verify bouncing is ignored.
        btn <= '0';
        wait for 120 ns;
        assert btn_delay = '1';

        btn <= '1';
        wait for 40 ns;
        assert btn_delay = '1';

        -- Verify bouncing restarts timer.
        btn <= '0';
        wait for 120 ns;
        assert btn_delay = '1';
        wait for 40 ns;
        assert btn_delay = '0';

        test_running <= false;
        wait;
    end process main_test;

end Structural;

