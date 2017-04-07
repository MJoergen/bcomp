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
    signal sw  : std_logic_vector (7 downto 0);
    signal btn : std_logic_vector (3 downto 0);

    alias btn_clk_step   : std_logic is btn(0);
    alias sw_clk_free    : std_logic is sw(7);
    alias sw_regs_clear  : std_logic is sw(0);
    alias sw_runmode     : std_logic is sw(1);

    -- LED
    signal led : std_logic_vector (7 downto 0) := (others => 'Z');

    -- Useful constants
--    constant ZERO : std_logic_vector (7 downto 0) := (others => '0');
--    constant ZZZZ : std_logic_vector (7 downto 0) := (others => 'Z');

    -- Used only for test purposes
    signal databus    : std_logic_vector (7 downto 0);
    signal control    : std_logic_vector (10 downto 0);
    signal address_sw : std_logic_vector (3 downto 0);
    signal data_sw    : std_logic_vector (7 downto 0);
    signal write_btn  : std_logic;

    -- Control signals
    alias  control_AI : std_logic is control(0);  -- A register load
    alias  control_AO : std_logic is control(1);  -- A register output enable
    alias  control_BI : std_logic is control(2);  -- B register load
    alias  control_BO : std_logic is control(3);  -- B register output enable
    alias  control_II : std_logic is control(4);  -- Instruction register load
    alias  control_IO : std_logic is control(5);  -- Instruction register output enable
    alias  control_EO : std_logic is control(6);  -- ALU output enable
    alias  control_SU : std_logic is control(7);  -- ALU subtract
    alias  control_MI : std_logic is control(8);  -- Memory address register load
    alias  control_RI : std_logic is control(9);  -- RAM load (write)
    alias  control_RO : std_logic is control(10); -- RAM output enable

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
                 clk_i        => clk    ,
                 sw_i         => sw     ,
                 btn_i        => btn    ,
                 led_o        => led    , 
                 seg_ca_o     => open   ,
                 seg_dp_o     => open   ,
                 seg_an_o     => open   ,

                 -- Used only for test purposes
                 databus_i    => databus    ,
                 control_i    => control    ,
                 address_sw_i => address_sw ,
                 data_sw_i    => data_sw    ,
                 write_btn_i  => write_btn  
             );

    -- Start the main test
    main_test : process is
    begin
        -- Set initial values
        sw  <= "00000000";
        btn <= "0000";
        sw_clk_free <= '1'; -- Use freerunning (astable) clock

        databus    <= "ZZZZZZZZ";
        control    <= (others => '0');
        address_sw <= (others => '0');
        data_sw    <= (others => '0');
        write_btn  <= '0';

        -- Test register clear
        sw_regs_clear <= '1';
        wait for 40 ns;
        assert led = "ZZZZZZZZ"; -- All enable bits clear

        sw_regs_clear <= '0';
        control_AO    <= '1';
        wait for 40 ns;
        assert led = "00000000"; -- Verify register A clear

        control_AO    <= '0';
        wait for 40 ns;
        assert led = "ZZZZZZZZ"; -- All enable bits clear

        -- Test register load
        databus <= "01010101"; -- 0x55 into register A
        control_AI <= '1';
        wait for 40 ns;
        assert led = "01010101";

        databus <= "00110011"; -- 0x33 into register B
        control_AI <= '0';
        control_BI <= '1';
        wait for 40 ns;
        assert led = "00110011";

        databus <= "ZZZZZZZZ"; -- Clear data bus
        control_BI <= '0';
        wait for 40 ns;
        assert led = "ZZZZZZZZ";

        control_AO <= '1';
        wait for 40 ns;
        assert led = "01010101"; -- Verify register A

        control_AO <= '0';
        control_BO <= '1';
        wait for 40 ns;
        assert led = "00110011"; -- Verify register B

        control_BO <= '0';
        control_SU <= '0';
        control_EO <= '1';
        wait for 40 ns;
        assert led = "10001000"; -- Verify addition: 0x88

        control_SU <= '1';
        wait for 40 ns;
        assert led = "00100010"; -- Verify subtraction: 0x22

        -- Verify counting.
        control_SU <= '0';
        control_AI <= '1';
        wait for 40 ns;
        assert led = "01010101"; -- 0x22 + 0x33 = 0x55
        wait for 40 ns;
        assert led = "10001000"; -- 0x55 + 0x33 = 0x88
        wait for 40 ns;
        assert led = "10111011"; -- 0x88 + 0x33 = 0xbb
        wait for 40 ns;
        assert led = "11101110"; -- 0xbb + 0x33 = 0xee

        control_EO <= '0';
        wait for 40 ns;
        assert led = "ZZZZZZZZ"; -- All enable bits clear

        test_running <= false;
        wait;
    end process main_test;

end Structural;

