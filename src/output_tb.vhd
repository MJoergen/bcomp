library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity output_tb is
end output_tb ;

architecture Structural of output_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal value      : std_logic_vector (7 downto 0);

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
    inst_output : entity work.output
    generic map (
                    COUNTER_SIZE => 3
                )
    port map (
                 clk_i       => clk       ,
                 value_i     => value     ,
                 seg_ca_o    => seg_ca    ,
                 seg_dp_o    => seg_dp    ,
                 seg_an_o    => seg_an 
              );


    -- Start the main test
    main_test : process is
        type digits_type is array(0 to 9) of std_logic_vector(7 downto 0);
        constant digits : digits_type :=
            ("01000000", "01111001", "00100100", "00110000", "00011001",
            "00010010", "00000010", "01111000", "00000000", "00010000");
    begin
        wait for 3*8*40 ns;
        wait for 40 ns;
        value <= "01111011"; -- 123 decimal
        wait for 40 ns;
        assert seg_ca = digits(3);
        assert seg_dp = '1';
        assert seg_an = "1110";
        wait for 8*40 ns;
        assert seg_ca = digits(2);
        assert seg_dp = '1';
        assert seg_an = "1101";
        wait for 8*40 ns;
        assert seg_ca = digits(1);
        assert seg_dp = '1';
        assert seg_an = "1011";
        wait for 8*40 ns;
        assert seg_ca = "1111111";
        assert seg_dp = '1';
        assert seg_an = "0111";
        wait for 8*40 ns;

        test_running <= false;
        wait;
    end process main_test;

end Structural;

