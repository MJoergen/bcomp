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
    signal led : std_logic_vector (7 downto 0);

    -- slide-switches and push-buttons
    signal sw  : std_logic_vector (7 downto 0);
    signal btn : std_logic_vector (3 downto 0);

    -- segment display
    signal seg_ca : std_logic_vector (6 downto 0);
    signal seg_dp : std_logic;
    signal seg_an : std_logic_vector (3 downto 0);

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

    btn <= "0000";

    -- Instantiate DUT
    inst_bcomp : entity work.bcomp
    generic map (
                    FREQ => 25000000
                )
    port map (
                 clk_i    => clk    ,
                 sw_i     => sw     ,
                 btn_i    => btn    ,
                 led_o    => led    , 
                 seg_ca_o => seg_ca ,
                 seg_dp_o => seg_dp ,
                 seg_an_o => seg_an
             );

    -- Start the main test
    main_test : process is
    begin
        sw <= "11111111";
        wait for 200 ns;
        assert led = "11111111";

        sw <= "00000000";
        wait for 200 ns;
        assert led = "00000000";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

