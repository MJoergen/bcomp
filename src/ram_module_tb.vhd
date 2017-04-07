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
    signal address_load : std_logic;
    signal wr           : std_logic;
    signal enable       : std_logic;
    signal data         : std_logic_vector(7 downto 0);

    -- Used only in programming mode
    signal runmode      : std_logic;
    signal sw_address   : std_logic_vector(3 downto 0);
    signal sw_data      : std_logic_vector(7 downto 0);
    signal wr_button    : std_logic;

    -- Output from the DUT
    signal address_led  : std_logic_vector(3 downto 0);
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
    port map (
             clk_i          => clk          ,

             address_load_i => address_load ,
             wr_i           => wr           ,
             enable_i       => enable       ,
             data_io        => data         ,

             runmode_i      => runmode      ,
             sw_address_i   => sw_address   ,
             sw_data_i      => sw_data      ,
             wr_button_i    => wr_button    ,

             address_led_o  => address_led  ,
             data_led_o     => data_led     
         );

    -- Start the main test
    main_test : process is
    begin
        -- Switch to programming mode.
        runmode <= '0';

        -- Check tristate buffer
        address_load <= '0';
        wr <= '0';
        enable <= '0';
        data <= "ZZZZZZZZ";
        sw_address <= "0000";
        sw_data <= "00000000";
        wr_button <= '0';
        wait for 80 ns;
        assert data     = "ZZZZZZZZ";
        assert data_led = "ZZZZZZZZ";

        -- Check write to address 0
        sw_address <= "0000";
        sw_data <= "01010011";
        wr_button <= '1' after 20 ns, '0' after 40 ns;
        enable <= '0';
        wait for 80 ns;
        assert data_led = "01010011";
        assert data     = "ZZZZZZZZ";

        -- Check read from address 0
        sw_address <= "0000";
        wr_button <= '0';
        wait for 80 ns;
        assert data_led = "01010011";
        assert data     = "ZZZZZZZZ";

        enable <= '1';
        wait for 80 ns;
        assert data_led = "01010011";
        assert data     = "01010011";

        -- Check write to address 1
        sw_address <= "0001";
        sw_data <= "10100110";
        wr_button <= '1' after 20 ns, '0' after 40 ns;
        enable <= '0';
        wait for 80 ns;
        assert data_led = "10100110";
        assert data     = "ZZZZZZZZ";

        -- Check read from address 0
        sw_address <= "0000";
        wait for 80 ns;
        assert data_led = "01010011";
        assert data     = "ZZZZZZZZ";

        enable <= '1';
        wait for 80 ns;
        assert data_led = "01010011";
        assert data     = "01010011";

        -- Check read from address 1
        sw_address <= "0001";
        enable <= '0';
        wait for 80 ns;
        assert data_led = "10100110";
        assert data     = "ZZZZZZZZ";

        enable <= '1';
        wait for 80 ns;
        assert data_led = "10100110";
        assert data     = "10100110";

        -- Check tristate buffer
        sw_address <= "0000";
        sw_data <= "ZZZZZZZZ";
        wr_button <= '0';
        enable <= '0';
        wait for 80 ns;
        assert data_led = "01010011";
        assert data     = "ZZZZZZZZ";

        -- Switch to run mode.
        runmode <= '1';

        -- Read from address 0
        address_load <= '1';
        wr <= '0';
        enable <= '0';
        data <= "00000000";
        wait for 80 ns;
        assert address_led = "0000";
        assert data_led    = "01010011";
        assert data        = "00000000";

        -- Read from address 0
        address_load <= '1';
        wr <= '0';
        enable <= '0';
        data <= "00000001";
        wait for 80 ns;
        assert address_led = "0001";
        assert data_led    = "10100110";
        assert data        = "00000001";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

