library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity program_counter_tb is
end program_counter_tb ;

architecture Structural of program_counter_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal clr        : std_logic;
    signal load       : std_logic;
    signal enable     : std_logic;
    signal count      : std_logic;

    -- Output from the DUT
    signal led        : std_logic_vector(3 downto 0);

    -- Main data bus
    signal data       : std_logic_vector(3 downto 0);

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
    inst_program_counter : entity work.program_counter
    port map (
                 clk_i       => clk    ,
                 clr_i       => clr    ,
                 data_io     => data   ,
                 led_o       => led    ,
                 load_i      => load   ,
                 enable_i    => enable ,
                 count_i     => count
             );

    -- Start the main test
    main_test : process is
    begin
        -- Check reset state
        clr    <= '1';
        data   <= "ZZZZ";
        load   <= '0';
        enable <= '1';
        count  <= '0';
        wait for 80 ns;
        assert led     = "0000";
        assert data    = "0000";

        -- Check tristate buffer
        enable <= '0';
        wait for 80 ns;
        assert led     = "0000";
        assert data    = "ZZZZ";

        -- Check setting register
        clr    <= '0';
        data   <= "0101";
        load   <= '1';
        enable <= '0'; -- When setting load, remember to clear enable.
        wait for 80 ns;
        assert data    = "0101";
        assert led     = "0101";

        -- Check tristate buffer
        data   <= "ZZZZ";
        load   <= '0';
        enable <= '0';
        wait for 80 ns;
        assert data    = "ZZZZ";
        assert led     = "0101";

        -- Check counter
        count  <= '1';
        wait for 40 ns;
        assert led     = "0110";
        assert data    = "ZZZZ";

        wait for 40 ns;
        assert led     = "0111";
        assert data    = "ZZZZ";

        wait for 40 ns;
        assert led     = "1000";
        assert data    = "ZZZZ";

        enable <= '1';
        wait for 40 ns;
        assert led     = "1001";
        assert data    = "1001";

        -- Check reset state
        clr    <= '1';
        data   <= "ZZZZ";
        load   <= '0';
        enable <= '1';
        count  <= '0';
        wait for 80 ns;
        assert led     = "0000";
        assert data    = "0000";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

