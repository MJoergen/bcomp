library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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

    alias btn_clk_step   : std_logic is btn(0);
    alias write_btn      : std_logic is btn(1);
    alias reset_btn      : std_logic is btn(2);
    
    alias sw_clk_free    : std_logic is sw(0);
    alias sw_runmode     : std_logic is sw(1);
    alias address_sw     : std_logic_vector (3 downto 0) is pmod(11 downto 8);
    alias data_sw        : std_logic_vector (7 downto 0) is pmod( 7 downto 0);

    alias sw_led_select  : std_logic_vector (2 downto 0) is sw(4 downto 2);
    constant LED_SELECT_BUS  : std_logic_vector (2 downto 0) := "000";
    constant LED_SELECT_ALU  : std_logic_vector (2 downto 0) := "001";
    constant LED_SELECT_RAM  : std_logic_vector (2 downto 0) := "010";
    constant LED_SELECT_ADDR : std_logic_vector (2 downto 0) := "011";
    constant LED_SELECT_AREG : std_logic_vector (2 downto 0) := "100";
    constant LED_SELECT_BREG : std_logic_vector (2 downto 0) := "101";
    constant LED_SELECT_OUT  : std_logic_vector (2 downto 0) := "110";
    constant LED_SELECT_IREG : std_logic_vector (2 downto 0) := "111";

    -- LED
    signal led : std_logic_vector (7 downto 0);

    -- Used only for test purposes
    signal databus       : std_logic_vector (7 downto 0);
    signal control       : std_logic_vector (14 downto 0);

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
    constant control_OI : integer := 14; -- Output register load

    -- Additional control signals
    constant control_SU : integer :=  7; -- ALU subtract
    constant control_CE : integer := 13; -- Program counter count enable

    subtype control_type is std_logic_vector(14 downto 0);
    constant MEM_TO_AREG : control_type := (
            control_RO => '1', control_AI => '1', others => '0');
    constant MEM_TO_BREG : control_type := (
            control_RO => '1', control_BI => '1', others => '0');
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
    constant AREG_TO_OUT : control_type := (
            control_AO => '1', control_OI => '1', others => '0');

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
    constant BUS_TO_ADDR : control_type := (
            control_MI => '1', others => '0');


    -- This contains a single microcode operation.
    type step_type is record
        databus    : std_logic_vector (7 downto 0);
        control    : control_type;
        led_select : std_logic_vector (2 downto 0);
        led_value  : std_logic_vector (7 downto 0);
    end record;

    type steps_array is array (integer range <>) of step_type;
    constant steps : steps_array :=
        -- Verify idle state
       (("ZZZZZZZZ", NOP,          LED_SELECT_BUS,  "ZZZZZZZZ"),

        -- Verify register transfer
        ("ZZZZZZZZ", AREG_TO_BUS,  LED_SELECT_BUS,  "00000000"),
        ("01010101", BUS_TO_AREG,  LED_SELECT_BUS,  "01010101"),
        ("00110011", BUS_TO_BREG,  LED_SELECT_BUS,  "00110011"),
        ("ZZZZZZZZ", NOP,          LED_SELECT_BUS,  "ZZZZZZZZ"),
        ("ZZZZZZZZ", AREG_TO_BUS,  LED_SELECT_BUS,  "01010101"), -- A := 0x55
        ("ZZZZZZZZ", BREG_TO_BUS,  LED_SELECT_BUS,  "00110011"), -- B := 0x33

        -- Verify ALU
        ("ZZZZZZZZ", NOP,          LED_SELECT_ALU,  "10001000"), -- 0x55 + 0x33 = 0x88
        ("ZZZZZZZZ", ALU_SUB,      LED_SELECT_ALU,  "00100010"), -- 0x55 - 0x33 = 0x22
        ("ZZZZZZZZ", NOP,          LED_SELECT_BUS,  "ZZZZZZZZ"),
        ("ZZZZZZZZ", ALU_TO_BUS,   LED_SELECT_BUS,  "10001000"),
        ("ZZZZZZZZ", ALU_TO_BUS + ALU_SUB, LED_SELECT_BUS, "00100010"),

        -- Verify counting.
        ("ZZZZZZZZ", ALU_TO_AREG,  LED_SELECT_AREG, "10001000"), -- 0x55 + 0x33 = 0x88
        ("ZZZZZZZZ", ALU_TO_AREG,  LED_SELECT_AREG, "10111011"), -- 0x88 + 0x33 = 0xbb
        ("ZZZZZZZZ", ALU_TO_AREG,  LED_SELECT_AREG, "11101110"), -- 0xbb + 0x33 = 0xee
        ("ZZZZZZZZ", AREG_TO_BUS,  LED_SELECT_BUS,  "10111011"), 
        ("ZZZZZZZZ", NOP,          LED_SELECT_BUS,  "ZZZZZZZZ"),

        -- Verify simple addition program
        -- LDA [4]
        ("00000100", BUS_TO_ADDR,  LED_SELECT_ADDR, "00000100"), -- Decimal 4
        ("ZZZZZZZZ", MEM_TO_AREG,  LED_SELECT_BUS,  "00001110"), -- Decimal 14

        -- ADD [5]
        ("00000101", BUS_TO_ADDR,  LED_SELECT_ADDR, "00000101"), -- Decimal 5
        ("ZZZZZZZZ", MEM_TO_BREG,  LED_SELECT_BUS,  "00011100"), -- Decimal 28
        ("ZZZZZZZZ", ALU_TO_AREG,  LED_SELECT_AREG, "00101010"), -- 14 + 28 = 42

        -- OUT
        ("ZZZZZZZZ", AREG_TO_OUT,  LED_SELECT_OUT,  "00101010")  -- Decimal 42
    );

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
        sw          <= "00000000";
        btn         <= "0000";
        sw_clk_free <= '1'; -- Use freerunning (astable) clock
        sw_runmode  <= '0'; -- Set RAM to programming mode

        databus     <= "ZZZZZZZZ";
        control     <= (others => '0');
        address_sw  <= (others => '0');
        data_sw     <= (others => '0');

        -- Reset DUT
        reset_btn <= '1';
        wait until rising_edge(clk);
        reset_btn <= '0';
        wait until rising_edge(clk);

        -- Program the RAM
        address_sw <= "0100";     -- decimal 4
        data_sw    <= "00001110"; -- decimal 14
        wait until falling_edge(clk);
        write_btn  <= '1';
        wait until rising_edge(clk);
        write_btn  <= '0';

        address_sw <= "0101";     -- decimal 5
        data_sw    <= "00011100"; -- decimal 28
        wait until falling_edge(clk);
        write_btn  <= '1';
        wait until rising_edge(clk);
        write_btn  <= '0';

        sw_runmode <= '1'; -- Set memory to run mode.

        -- Run through program in microcode.
        for i in steps'range loop
            databus       <= steps(i).databus;
            control       <= steps(i).control;
            sw_led_select <= steps(i).led_select;
            wait until rising_edge(clk);
            wait until falling_edge(clk);
            assert  led = steps(i).led_value
                report "received " & slv_to_string(led);
        end loop;

        test_running <= false;
        wait;
    end process main_test;

end Structural;

