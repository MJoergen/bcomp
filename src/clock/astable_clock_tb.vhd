library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity astable_clock_tb is
end astable_clock_tb ;

architecture Structural of astable_clock_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Output from DUT
    signal clk_slow : std_logic;


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
    inst_astable_clock : entity work.astable_clock
    generic map (
                    SIMULATION => true -- Much shorter counter during simulation.
                )
    port map (
                 clk_i => clk      ,
                 clk_o => clk_slow 
             );

    -- Start the main test
    main_test : process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        assert clk_slow = '0'
            report "received " & std_logic'image(clk_slow);

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        assert clk_slow = '0'
            report "received " & std_logic'image(clk_slow);

        wait until rising_edge(clk);
        assert clk_slow = '1'
            report "received " & std_logic'image(clk_slow);

        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        assert clk_slow = '1'
            report "received " & std_logic'image(clk_slow);

        wait until rising_edge(clk);
        assert clk_slow = '0'
            report "received " & std_logic'image(clk_slow);

        test_running <= false;
        wait;
    end process main_test;

end Structural;

