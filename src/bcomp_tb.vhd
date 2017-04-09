library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcomp_tb is
end bcomp_tb ;

architecture Structural of bcomp_tb is

    --Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- slide-switches and push-buttons
    signal sw   : std_logic_vector (7 downto 0);
    signal btn  : std_logic_vector (3 downto 0);
    signal pmod : std_logic_vector (15 downto 0);

    alias btn_clk_step   : std_logic is btn(0);
    alias write_btn      : std_logic is btn(1);
    alias reset_btn      : std_logic is btn(2);
    
    alias sw_clk_free    : std_logic is sw(7);
    alias sw_runmode     : std_logic is sw(1);
    alias address_sw     : std_logic_vector (3 downto 0) is pmod(11 downto 8);
    alias data_sw        : std_logic_vector (7 downto 0) is pmod( 7 downto 0);

    alias sw_led_select  : std_logic_vector (1 downto 0) is sw(3 downto 2);
    constant LED_SELECT_BUS  : std_logic_vector (1 downto 0) := "00";
    constant LED_SELECT_ALU  : std_logic_vector (1 downto 0) := "01";
    constant LED_SELECT_RAM  : std_logic_vector (1 downto 0) := "10";
    constant LED_SELECT_ADDR : std_logic_vector (1 downto 0) := "11";

    -- LED
    signal led : std_logic_vector (7 downto 0);

    -- Used only for test purposes
    signal databus       : std_logic_vector (7 downto 0);
    signal control       : std_logic_vector (13 downto 0);

    -- Bus commands
    constant control_AI : integer :=  0; -- A register load
    constant control_AO : integer :=  1; -- A register output enable
    constant control_BI : integer :=  2; -- B register load
    constant control_BO : integer :=  3; -- B register output enable
    constant control_II : integer :=  4; -- Instruction register load
    constant control_IO : integer :=  5; -- Inttruction register output enable
    constant control_EO : integer :=  6; -- ALU output enable
    constant control_MI : integer :=  8; -- Memory address register load
    constant control_RI : integer :=  9; -- RAM load (write)
    constant control_RO : integer := 10; -- RAM output enable
    constant control_CO : integer := 11; -- Program counter output enable
    constant control_J  : integer := 12; -- Program counter jump

    -- Additional control signals
    constant control_SU : integer :=  7; -- ALU subtract
    constant control_CE : integer := 13; -- Program counter count enable

    subtype control_type is std_logic_vector(13 downto 0);
    constant MEM_TO_AREG : control_type := (
            control_RO => '1', control_AI => '1', others => '0');
    constant ALU_TO_AREG : control_type := (
            control_EO => '1', control_AI => '1', others => '0');
    constant AREG_TO_MEM : control_type := (
            control_AO => '1', control_RI => '1', others => '0');
    constant BREG_TO_MEM : control_type := (
            control_BO => '1', control_RI => '1', others => '0');
    constant AREG_TO_ADDR : control_type := (
            control_AO => '1', control_MI => '1', others => '0');
    constant ALU_SUB : control_type := (
            control_SU => '1', others => '0');
    constant NOP : control_type := (
            others => '0');

    -- No specific opcodes, only used for testing.
    constant AREG_TO_BUS : control_type := (
            control_AO => '1', others => '0');
    constant BREG_TO_BUS : control_type := (
            control_BO => '1', others => '0');
    constant ALU_TO_BUS : control_type := (
            control_EO => '1', others => '0');
    constant BUS_TO_AREG : control_type := (
            control_AI => '1', others => '0');
    constant BUS_TO_BREG : control_type := (
            control_BI => '1', others => '0');

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

                 -- Used only for test purposes
                 databus_i    => databus ,
                 control_i    => control       
             );

    -- Start the main test
    main_test : process is
    begin
        -- Set initial values
        sw  <= "00000000";
        btn <= "0000";
        sw_clk_free <= '1'; -- Use freerunning (astable) clock
        sw_runmode <= '1'; -- Set memory to run mode.

        databus    <= "ZZZZZZZZ";
        control    <= (others => '0');
        address_sw <= (others => '0');
        data_sw    <= (others => '0');

        -- Test register clear
        reset_btn <= '1';
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "ZZZZZZZZ"; -- All enable bits clear

        reset_btn <= '0';
        control <= AREG_TO_BUS;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "00000000"; -- Verify register A clear

        control <= NOP;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "ZZZZZZZZ"; -- All enable bits clear

        -- Test register load
        databus <= "01010101"; -- 0x55 into register A
        control <= BUS_TO_AREG;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "01010101";

        databus <= "00110011"; -- 0x33 into register B
        control <= BUS_TO_BREG;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "00110011";

        databus <= "ZZZZZZZZ"; -- Clear data bus
        control <= NOP;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "ZZZZZZZZ";

        control <= AREG_TO_BUS;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "01010101"; -- Verify register A

        control <= BREG_TO_BUS;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "00110011"; -- Verify register B

        control <= ALU_TO_BUS;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "10001000"; -- Verify addition: 0x88

        control <= ALU_TO_BUS + ALU_SUB;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "00100010"; -- Verify subtraction: 0x22

        -- Verify counting.
        control <= ALU_TO_AREG;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "10001000"; -- 0x55 + 0x33 = 0x88
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "10111011"; -- 0x88 + 0x33 = 0xbb
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "11101110"; -- 0xbb + 0x33 = 0xee

        control <= AREG_TO_BUS;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "11101110"; -- Verify A-register

        control <= NOP;
        wait until rising_edge(clk);
        sw_led_select <= LED_SELECT_BUS;
        assert led = "ZZZZZZZZ"; -- All enable bits clear

        -- Verify from A-register to memory address register
        control <= AREG_TO_ADDR;
        sw_led_select <= LED_SELECT_BUS;
        wait until rising_edge(clk);
        assert led = "11101110";

        sw_led_select <= LED_SELECT_ADDR;
        wait until rising_edge(clk);
        assert led = "00001110";

        -- Verify from B-register to memory contents
        control <= BREG_TO_MEM;
        sw_led_select <= LED_SELECT_BUS;
        wait until rising_edge(clk);
        assert led = "00110011";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

