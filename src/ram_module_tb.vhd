library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram_module_tb is
end ram_module_tb ;

architecture Structural of ram_module_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal wr           : std_logic;
    signal enable       : std_logic;

    -- From memory address register
    signal address      : std_logic_vector(3 downto 0);

    -- Data bus connection
    signal data         : std_logic_vector(7 downto 0);

    -- Used only in programming mode
    signal runmode      : std_logic;
    signal sw_data      : std_logic_vector(7 downto 0);
    signal wr_button    : std_logic;

    -- Output from the DUT
    signal data_led     : std_logic_vector(7 downto 0);

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
    inst_ram_module : entity work.ram_module
    generic map (
                    INITIAL_HIGH => (0 => "1100", others => "0000"),
                    INITIAL_LOW  => (0 => "1011", others => "0000")
                )
    port map (
             clk_i          => clk          ,
             wr_i           => wr           ,
             enable_i       => enable       ,

             data_io        => data         ,
             address_i      => address      ,

             runmode_i      => runmode      ,
             sw_data_i      => sw_data      ,
             wr_button_i    => wr_button    ,

             data_led_o     => data_led     
         );

    -- Start the main test
    main_test : process is
    begin
        -- Switch to programming mode.
        runmode <= '0';

        -- Check tristate buffer
        wr        <= '0';
        enable    <= '0';
        data      <= "ZZZZZZZZ";
        address   <= "0000";
        sw_data   <= "00000000";
        wr_button <= '0';
        wait until rising_edge(clk);
        assert data     = "ZZZZZZZZ";

        -- Check read from address 0
        address <= "0000";
        wr_button <= '0';
        wait until rising_edge(clk);
        assert data_led = "11001011";
        assert data     = "ZZZZZZZZ";

        enable <= '1';
        wait until rising_edge(clk);
        assert data_led = "11001011";
        assert data     = "11001011";

        -- Check write to address 0
        address <= "0000";
        sw_data <= "01010011";
        wr_button <= '1';
        enable <= '0';
        wait until rising_edge(clk);
        wr_button <= '0';
        wait for 10 ns;
        assert data_led = "01010011";
        assert data     = "ZZZZZZZZ";

        -- Check read from address 0
        address <= "0000";
        wr_button <= '0';
        wait until rising_edge(clk);
        assert data_led = "01010011";
        assert data     = "ZZZZZZZZ";

        enable <= '1';
        wait until rising_edge(clk);
        assert data_led = "01010011";
        assert data     = "01010011";

        -- Check write to address 1
        address <= "0001";
        sw_data <= "10100110";
        wr_button <= '1';
        enable <= '0';
        wait until rising_edge(clk);
        wr_button <= '0';
        wait for 10 ns;
        assert data_led = "10100110";
        assert data     = "ZZZZZZZZ";

        -- Check read from address 0
        address <= "0000";
        wait until rising_edge(clk);
        assert data_led = "01010011";
        assert data     = "ZZZZZZZZ";

        enable <= '1';
        wait until rising_edge(clk);
        assert data_led = "01010011";
        assert data     = "01010011";

        -- Check read from address 1
        address <= "0001";
        enable <= '0';
        wait until rising_edge(clk);
        assert data_led = "10100110";
        assert data     = "ZZZZZZZZ";

        enable <= '1';
        wait until rising_edge(clk);
        assert data_led = "10100110";
        assert data     = "10100110";

        -- Check tristate buffer
        address <= "0000";
        sw_data <= "ZZZZZZZZ";
        wr_button <= '0';
        enable <= '0';
        wait until rising_edge(clk);
        assert data_led = "01010011";
        assert data     = "ZZZZZZZZ";

        -- Switch to run mode.
        runmode <= '1';

        -- Write to address 0
        wr <= '1';
        enable <= '0';
        data <= "11001100";
        address <= "0000";
        wait until rising_edge(clk);
        wr <= '0';
        wait for 10 ns;
        assert data_led = "11001100";
        assert data     = "11001100";

        -- Check tristate buffer
        data <= "ZZZZZZZZ";
        wait until rising_edge(clk);
        assert data_led = "11001100";
        assert data     = "ZZZZZZZZ";

        -- Read from address 0
        enable <= '1';
        wait until rising_edge(clk);
        assert data_led = "11001100";
        assert data     = "11001100";

        -- Read from address 1
        address <= "0001";
        enable <= '1';
        wait until rising_edge(clk);
        assert data_led = "10100110";
        assert data     = "10100110";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

