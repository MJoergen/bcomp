library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram_tb is
end ram_tb ;

architecture Structural of ram_tb is

    -- Clock
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal wr         : std_logic;
    signal enable     : std_logic;
    signal address    : std_logic_vector (3 downto 0);
    signal data_in    : std_logic_vector(7 downto 0);

    -- Output from the DUT
    signal data_out   : std_logic_vector(7 downto 0);
    signal led        : std_logic_vector(7 downto 0);

begin

    -- Instantiate DUT
    inst_ram : entity work.ram
    port map (
                 address_i   => address  ,
                 data_in_i   => data_in  ,
                 data_out_o  => data_out ,
                 led_o       => led      ,
                 wr_i        => wr       ,
                 enable_i    => enable
             );

    -- Start the main test
    main_test : process is
    begin
        -- Check tristate buffer
        address <= "0000";
        data_in <= "ZZZZZZZZ";
        wr <= '0';
        enable <= '0';
        wait for 80 ns;
        assert data_out = "ZZZZZZZZ";

        -- Check write to address 0
        address <= "0000";
        data_in <= "01010011";
        wr <= '1' after 20 ns, '0' after 40 ns;
        enable <= '0';
        wait for 80 ns;
        assert data_out = "ZZZZZZZZ";
        assert led      = "01010011";

        -- Check tristate buffer
        address <= "0000";
        data_in <= "ZZZZZZZZ";
        enable <= '0';
        wait for 80 ns;
        assert led     = "01010011";
        assert data_out    = "ZZZZZZZZ";

        -- Check read from address 0
        address <= "0000";
        data_in <= "ZZZZZZZZ";
        enable <= '1';
        wait for 80 ns;
        assert led     = "01010011";
        assert data_out    = "01010011";

        -- Check write to address 1
        address <= "0001";
        data_in <= "10100110";
        wr <= '1' after 20 ns, '0' after 40 ns;
        enable <= '0';
        wait for 80 ns;
        assert led      = "10100110";
        assert data_out = "ZZZZZZZZ";

        -- Check read from address 0
        address <= "0000";
        data_in <= "ZZZZZZZZ";
        enable <= '1';
        wait for 80 ns;
        assert led       = "01010011";
        assert data_out  = "01010011";

        -- Check read from address 1
        address <= "0001";
        data_in <= "ZZZZZZZZ";
        enable <= '0', '1' after 20 ns;
        wait for 80 ns;
        assert led       = "10100110";
        assert data_out  = "10100110";

        -- Check tristate buffer
        address <= "0000";
        data_in <= "ZZZZZZZZ";
        enable <= '0';
        wait for 80 ns;
        assert led       = "01010011";
        assert data_out  = "ZZZZZZZZ";

        wait;
    end process main_test;

end Structural;

