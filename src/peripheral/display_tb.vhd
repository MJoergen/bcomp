library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity display_tb is
end display_tb ;

architecture Structural of display_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal value      : std_logic_vector (7 downto 0);
    signal two_comp   : std_logic;

    -- Output from the DUT
    signal seg_ca     : std_logic_vector (6 downto 0);
    signal seg_dp     : std_logic;
    signal seg_an     : std_logic_vector (3 downto 0);

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
    inst_display : entity work.display
    generic map (
                    SIMULATION => true
                )
    port map (
                 clk_i       => clk       ,
                 two_comp_i  => two_comp  ,
                 value_i     => value     ,
                 seg_ca_o    => seg_ca    ,
                 seg_dp_o    => seg_dp    ,
                 seg_an_o    => seg_an 
              );


    -- Start the main test
    main_test : process is
        constant DIG_0 : std_logic_vector (7 downto 0) := "11000000";
        constant DIG_1 : std_logic_vector (7 downto 0) := "11111001";
        constant DIG_2 : std_logic_vector (7 downto 0) := "10100100";
        constant DIG_3 : std_logic_vector (7 downto 0) := "10110000";
        constant DIG_4 : std_logic_vector (7 downto 0) := "10011001";
        constant DIG_5 : std_logic_vector (7 downto 0) := "10010010";
        constant DIG_6 : std_logic_vector (7 downto 0) := "10000010";
        constant DIG_7 : std_logic_vector (7 downto 0) := "11111000";
        constant DIG_8 : std_logic_vector (7 downto 0) := "10000000";
        constant DIG_9 : std_logic_vector (7 downto 0) := "10010000";
        constant BLANK : std_logic_vector (7 downto 0) := "11111111";
        constant NEGAT : std_logic_vector (7 downto 0) := "10111111";
    begin
        wait for 3*4*40 ns;
        wait for 40 ns;

        two_comp <= '0';
        value <= "11010101"; -- 213 decimal
        wait for 40 ns;
        assert seg_ca = DIG_3(6 downto 0);
        assert seg_dp = DIG_3(7);
        assert seg_an = "1110";
        wait for 4*40 ns;
        assert seg_ca = DIG_1(6 downto 0);
        assert seg_dp = DIG_1(7);
        assert seg_an = "1101";
        wait for 4*40 ns;
        assert seg_ca = DIG_2(6 downto 0);
        assert seg_dp = DIG_2(7);
        assert seg_an = "1011";
        wait for 4*40 ns;
        assert seg_ca = BLANK(6 downto 0);
        assert seg_dp = BLANK(7);
        assert seg_an = "0111";
        wait for 4*40 ns;

        two_comp <= '1';
        value <= "11010101"; -- -43 decimal
        wait for 40 ns;
        assert seg_ca = DIG_3(6 downto 0);
        assert seg_dp = DIG_3(7);
        assert seg_an = "1110";
        wait for 4*40 ns;
        assert seg_ca = DIG_4(6 downto 0);
        assert seg_dp = DIG_4(7);
        assert seg_an = "1101";
        wait for 4*40 ns;
        assert seg_ca = BLANK(6 downto 0);
        assert seg_dp = BLANK(7);
        assert seg_an = "1011";
        wait for 4*40 ns;
        assert seg_ca = NEGAT(6 downto 0);
        assert seg_dp = NEGAT(7);
        assert seg_an = "0111";
        wait for 4*40 ns;

        test_running <= false;
        wait;
    end process main_test;

end Structural;

