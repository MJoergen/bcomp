library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcomp_tb is
end bcomp_tb ;

architecture Structural of bcomp_tb is

    --Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- LED
    signal led : std_logic_vector (7 downto 0) := (others => 'Z');

    -- slide-switches and push-buttons
    signal sw  : std_logic_vector (7 downto 0);
    signal btn : std_logic_vector (3 downto 0);

    alias regs_clear     : std_logic is sw(0);
    alias regs_a_load    : std_logic is sw(1);
    alias regs_a_enable  : std_logic is sw(2);
    alias regs_b_load    : std_logic is sw(3);
    alias regs_b_enable  : std_logic is sw(4);
    alias alu_sub        : std_logic is sw(5);
    alias alu_enable     : std_logic is sw(6);
    alias clk_switch     : std_logic is sw(7);

    constant ZERO : std_logic_vector (7 downto 0) := (others => '0');
    constant ZZZZ : std_logic_vector (7 downto 0) := (others => 'Z');

    -- Input to main data bus
    signal data : std_logic_vector (7 downto 0);

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
    inst_bcomp : entity work.bcomp
    generic map (
                    FREQ => 25000000
                )
    port map (
                 clk_i    => clk    ,
                 sw_i     => sw     ,
                 btn_i    => btn    ,
                 data_i   => data   , -- Used only for test purposes
                 led_o    => led    , 
                 seg_ca_o => open   ,
                 seg_dp_o => open   ,
                 seg_an_o => open
             );

    -- Start the main test
    main_test : process is
    begin
        -- Set initial values
        data <= "ZZZZZZZZ";
        btn <= "0000"; -- Not used
        sw <= "00000000";  -- Clear all enable bits
        clk_switch <= '1'; -- Use freerunning (astable) clock

        -- Test register clear
        regs_clear <= '1';
        wait for 40 ns;
        assert led = "ZZZZZZZZ"; -- All enable bits clear

        regs_clear <= '0';
        regs_a_enable <= '1';
        wait for 40 ns;
        assert led = "00000000"; -- Verify register A clear

        regs_a_enable <= '0';
        wait for 40 ns;
        assert led = "ZZZZZZZZ"; -- All enable bits clear

        -- Test register load
        data <= "01010101"; -- 0x55 into register A
        regs_a_load <= '1';
        wait for 40 ns;
        assert led = "01010101";

        data <= "00110011"; -- 0x33 into register B
        regs_a_load <= '0';
        regs_b_load <= '1';
        wait for 40 ns;
        assert led = "00110011";

        data <= "ZZZZZZZZ"; -- Clear data bus
        regs_b_load <= '0';
        wait for 40 ns;
        assert led = "ZZZZZZZZ";

        regs_a_enable <= '1';
        wait for 40 ns;
        assert led = "01010101"; -- Verify register A

        regs_a_enable <= '0';
        regs_b_enable <= '1';
        wait for 40 ns;
        assert led = "00110011"; -- Verify register B

        regs_b_enable <= '0';
        alu_sub <= '0';
        alu_enable <= '1';
        wait for 40 ns;
        assert led = "10001000"; -- Verify addition: 0x88

        alu_sub <= '1';
        wait for 40 ns;
        assert led = "00100010"; -- Verify subtraction: 0x22

        -- Verify counting.
        alu_sub <= '0';
        regs_a_load <= '1';
        wait for 40 ns;
        assert led = "01010101"; -- 0x22 + 0x33 = 0x55
        wait for 40 ns;
        assert led = "10001000"; -- 0x55 + 0x33 = 0x88
        wait for 40 ns;
        assert led = "10111011"; -- 0x88 + 0x33 = 0xbb
        wait for 40 ns;
        assert led = "11101110"; -- 0xbb + 0x33 = 0xee

        alu_enable <= '0';

        test_running <= false;
        wait;
    end process main_test;

end Structural;

