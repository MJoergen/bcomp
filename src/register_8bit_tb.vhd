library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity register_8bit_tb is
end register_8bit_tb ;

architecture Structural of register_8bit_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal data_in    : std_logic_vector(7 downto 0);
    signal load       : std_logic;
    signal enable     : std_logic;

    -- Output from the DUT
    signal data_out   : std_logic_vector(7 downto 0);
    signal reg        : std_logic_vector(7 downto 0);

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
    inst_register_8bit : entity work.register_8bit
    port map (
                 clk_i       => clk       ,
                 data_i      => data_in   ,
                 data_o      => data_out  ,
                 reg_o       => reg       ,
                 load_i      => load      ,
                 enable_i    => enable
             );

    -- Start the main test
    main_test : process is
    begin
        load    <= '1'; -- Start with a known value
        enable  <= '1';
        data_in <= "01010101";

        wait for 80 ns;
        assert data_out = "01010101";
        assert reg      = "01010101";

        data_in <= "00001111";
        wait for 80 ns;
        assert data_out = "00001111";
        assert reg      = "00001111";

        data_in <= "00110011";
        wait for 80 ns;
        assert data_out = "00110011";
        assert reg      = "00110011";

        load    <= '0';
        wait for 80 ns;
        assert data_out = "00110011";
        assert reg      = "00110011";

        data_in <= "10101010";
        wait for 80 ns;
        assert data_out = "00110011";
        assert reg      = "00110011";

        enable  <= '0';
        wait for 80 ns;
        assert data_out = "ZZZZZZZZ";
        assert reg      = "00110011";

        enable  <= '1';
        wait for 80 ns;
        assert data_out = "00110011";
        assert reg      = "00110011";

        load    <= '1';
        wait for 80 ns;
        assert data_out = "10101010";
        assert reg      = "10101010";

        enable  <= '0';
        wait for 80 ns;
        assert data_out = "ZZZZZZZZ";
        assert reg      = "10101010";

        data_in <= "11001100";
        load    <= '1';
        wait for 80 ns;
        assert data_out = "ZZZZZZZZ";
        assert reg      = "11001100";

        enable  <= '1';
        wait for 80 ns;
        assert data_out = "11001100";
        assert reg      = "11001100";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

