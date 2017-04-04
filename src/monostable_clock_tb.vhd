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
    signal btn     : std_logic;
    signal btn_reg : std_logic;


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
                    COUNTER_SIZE => 4 -- Much shorter counter during simulation.
                    -- 40 ns * 2^4 = 640 ns.
                )
    port map (
                 clk_i     => clk    ,
                 btn_i     => btn    ,
                 btn_reg_o => btn_reg 
             );

    -- Start the main test
    main_test : process is
    begin
        wait for 80 ns;

        btn <= '0';
        wait for 640 ns;
        assert btn_reg = '0';

        btn <= '1';
        wait for 640 ns;
        assert btn_reg = '1';

        btn <= '0';
        wait for 640 ns;
        assert btn_reg = '0';

        btn <= '1';
        wait for 160 ns;
        assert btn_reg = '0';
        wait for 160 ns;
        assert btn_reg = '0';
        wait for 160 ns;
        assert btn_reg = '0';
        wait for 160 ns;
        assert btn_reg = '1';

        btn <= '0';
        wait for 160 ns;
        assert btn_reg = '1';
        wait for 160 ns;
        assert btn_reg = '1';
        wait for 160 ns;
        assert btn_reg = '1';
        wait for 160 ns;
        assert btn_reg = '0';

        test_running <= false;
        wait;
    end process main_test;

end Structural;

