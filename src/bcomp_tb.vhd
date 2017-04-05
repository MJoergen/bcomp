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
    alias regs_ir_load   : std_logic is sw(5);
    alias regs_ir_enable : std_logic is sw(6);
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
        data <= "01010101";
        regs_a_load <= '1';
        wait for 40 ns;
        assert led = "01010101";

        data <= "10101010";
        regs_a_load <= '0';
        regs_b_load <= '1';
        wait for 40 ns;
        assert led = "10101010";

        data <= "11001100";
        regs_b_load <= '0';
        regs_ir_load <= '1';
        wait for 40 ns;
        assert led = "11001100";

        data <= "ZZZZZZZZ";
        regs_ir_load <= '0';
        wait for 40 ns;
        assert led = "ZZZZZZZZ";

        regs_a_enable <= '1';
        wait for 40 ns;
        assert led = "01010101";

        regs_a_enable <= '0';
        regs_b_enable <= '1';
        wait for 40 ns;
        assert led = "10101010";

        regs_b_enable <= '0';
        regs_ir_enable <= '1';
        wait for 40 ns;
        assert led = "11001100";

        regs_ir_enable <= '0';

        test_running <= false;
        wait;
    end process main_test;

end Structural;

