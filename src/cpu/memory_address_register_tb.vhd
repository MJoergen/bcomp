library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity memory_address_register_tb is
end memory_address_register_tb ;

architecture Structural of memory_address_register_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal address_in  :  std_logic_vector (3 downto 0);
    signal sw          :  std_logic_vector (3 downto 0);
    signal runmode     :  std_logic;
    signal load        :  std_logic;

    -- Output from the DUT
    signal address_out : std_logic_vector (3 downto 0);

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
    inst_memory_address_register : entity work.memory_address_register
    port map (
                 clk_i       => clk,
                 load_i      => load,
                 address_i   => address_in,
                 address_o   => address_out,
                 runmode_i   => runmode,
                 sw_i        => sw
             );

    -- Start the main test
    main_test : process is
    begin
        -- Switch to programming mode.
        runmode <= '0';

        load <= '0';
        address_in <= "0000";
        sw <= "0000";
        wait for 80 ns;
        assert address_out = "0000";

        sw <= "0101";
        wait for 80 ns;
        assert address_out = "0101";

        -- Switch to programming mode.
        runmode <= '1';

        address_in <= "0000";
        load <= '1', '0' after 50 ns;
        wait for 80 ns;
        assert address_out = "0000";

        address_in <= "1010";
        wait for 80 ns;
        assert address_out = "0000";

        load <= '1', '0' after 50 ns;
        wait for 80 ns;
        assert address_out = "1010";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

