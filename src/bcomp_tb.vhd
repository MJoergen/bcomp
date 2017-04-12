library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcomp_tb is
end bcomp_tb ;

architecture Structural of bcomp_tb is

    function slv_to_string ( a: std_logic_vector) return string is
    variable b : string (a'length-1 downto 0) := (others => NUL);
    begin
        for i in a'length-1 downto 0 loop
            b(i) := std_logic'image(a(i))(2);
        end loop;
        return b;
    end function;

    --Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- slide-switches and push-buttons
    signal sw   : std_logic_vector (7 downto 0);
    signal btn  : std_logic_vector (3 downto 0);
    signal pmod : std_logic_vector (15 downto 0);

    alias btn_clk     : std_logic is btn(0);
    alias btn_write   : std_logic is btn(1);
    alias btn_reset   : std_logic is btn(2);
    
    alias sw_clk_free : std_logic is sw(0);
    alias sw_runmode  : std_logic is sw(1);

    alias sw_led_select  : std_logic_vector (2 downto 0) is sw(4 downto 2);
    constant LED_SELECT_RAM  : std_logic_vector (2 downto 0) := "000";
    constant LED_SELECT_ADDR : std_logic_vector (2 downto 0) := "001";
    constant LED_SELECT_OUT  : std_logic_vector (2 downto 0) := "010";
    constant LED_SELECT_BUS  : std_logic_vector (2 downto 0) := "011";
    constant LED_SELECT_ALU  : std_logic_vector (2 downto 0) := "100";
    constant LED_SELECT_AREG : std_logic_vector (2 downto 0) := "101";
    constant LED_SELECT_BREG : std_logic_vector (2 downto 0) := "110";
    constant LED_SELECT_PC   : std_logic_vector (2 downto 0) := "111";

    alias sw_disp_two_comp : std_logic is sw(5); -- Display two's complement

    alias pmod_address  : std_logic_vector (3 downto 0) is pmod(11 downto 8);
    alias pmod_data     : std_logic_vector (7 downto 0) is pmod( 7 downto 0);

    -- LED
    signal led : std_logic_vector (7 downto 0);

    -- VGA output
    signal vga_hs  : std_logic;
    signal vga_vs  : std_logic;
    signal vga_col : std_logic_vector(7 downto 0);

begin
    -- Simulate external crystal clock (25 MHz)
    clk_gen : process
    begin
        if not test_running then
            wait;
        end if;

        clk <= '1', '0' after 20 ns;
        wait for 40 ns;
    end process clk_gen;

    -- Instantiate DUT
    inst_bcomp : entity work.bcomp
    generic map (
                    SIMULATION => true ,
                    FREQ => 25000000
                )
    port map (
                 clk_i        => clk     ,
                 sw_i         => sw      ,
                 btn_i        => btn     ,
                 pmod_i       => pmod    ,
                 led_o        => led     , 
                 seg_ca_o     => open    ,
                 seg_dp_o     => open    ,
                 seg_an_o     => open    ,
                 vga_hs_o     => vga_hs  ,
                 vga_vs_o     => vga_vs  ,
                 vga_col_o    => vga_col
             );

    -- Start the main test
    main_test : process is
        variable old_led : std_logic_vector(7 downto 0);

        -- This contains the expected values of the output register
        type led_array_type is array (integer range <>) of std_logic_vector(7 downto 0);
        constant led_array : led_array_type := (
            "00000001",  --   1 = 0x01
            "00000010",  --   2 = 0x02
            "00000011",  --   3 = 0x03
            "00000101",  --   5 = 0x05
            "00001000",  --   8 = 0x08
            "00001101",  --  13 = 0x0D
            "00010101",  --  21 = 0x15
            "00100010",  --  34 = 0x22
            "00110111",  --  55 = 0x37
            "01011001",  --  89 = 0x59
            "10010000",  -- 144 = 0x90
            "00000000",  --   0 = 0x00
            "00000001"); --   1 = 0x01

    begin
        -- Set initial values
        sw            <= "00000000";
        btn           <= "0000";
        pmod          <= (others => '0');
        sw_led_select <= LED_SELECT_OUT;

        -- Reset DUT
        sw_clk_free   <= '1'; -- Use freerunning (astable) clock
        sw_runmode    <= '1'; -- Set RAM to run mode.
        btn_reset     <= '1';
        wait until rising_edge(clk);
        btn_reset     <= '0';
        wait until rising_edge(clk);

        assert led = "00000000";

        -- Run the program
        for i in led_array'range loop
            old_led := led;
            wait until old_led /= led;
            assert led = led_array(i)
                report "received " & slv_to_string(led) & ", expected " & slv_to_string(led_array(i));
        end loop;

        test_running <= false;
        wait;
    end process main_test;

end Structural;

