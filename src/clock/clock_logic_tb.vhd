library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_logic_tb is
end clock_logic_tb ;

architecture Structural of clock_logic_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal sw         : std_logic;
    signal btn        : std_logic;
    signal hlt        : std_logic;

    -- Output from the DUT
    signal clk_deriv  : std_logic;

    signal counter    : std_logic_vector(7 downto 0);
    signal cnt_test   : std_logic_vector(7 downto 0);

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
    inst_clock_logic : entity work.clock_logic
    generic map (
                    SIMULATION => true
                )
    port map (
                 clk_i       => clk       ,
                 sw_i        => sw        ,
                 btn_i       => btn       ,
                 hlt_i       => hlt       ,
                 clk_deriv_o => clk_deriv 
             );

    process(clk_deriv)
    begin
        if hlt = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk_deriv) then
            counter <= counter + 1;
        end if;
    end process;


    -- Start the main test
    main_test : process is
    begin
        hlt <= '1';
        sw  <= '1'; -- Use crystal clock
        btn <= '0';
        wait for 1500 ns; -- Wait until halt debounces.

        cnt_test <= counter;
        wait for 1500 ns;
        assert cnt_test = counter;

        hlt <= '0';
        sw  <= '1'; -- Use crystal clock
        wait for 1500 ns; -- Wait until switch debounces.

        cnt_test <= counter; -- Verify clock is running.
        wait for 1500 ns; 
        assert counter > cnt_test + 1;

        sw  <= '0'; -- Use manual clock
        wait for 1500 ns; -- Wait until switch debounces.

        cnt_test <= counter; -- Verify clock is stopped.
        wait for 1500 ns;
        assert cnt_test = counter;

        cnt_test <= counter; -- Verify clock is ticked only once.
        btn <= '1';
        wait for 1500 ns; -- Wait until button debounces.
        assert counter = cnt_test + 1;

        cnt_test <= counter; -- Verify clock is stopped.
        wait for 1500 ns;
        assert cnt_test = counter;

        cnt_test <= counter; -- Verify clock is stopped.
        btn <= '0';
        wait for 1500 ns;
        assert cnt_test = counter;

        test_running <= false;
        wait;
    end process main_test;

end Structural;

