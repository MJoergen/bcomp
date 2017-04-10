library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity instruction_register_tb is
end instruction_register_tb ;

architecture Structural of instruction_register_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal clr        : std_logic;
    signal load       : std_logic;
    signal enable     : std_logic;

    -- Output from the DUT
    signal reg        : std_logic_vector(7 downto 0);

    -- Main data bus
    signal data       : std_logic_vector(7 downto 0);

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
    inst_instruction_register : entity work.instruction_register
    port map (
                 clk_i       => clk    ,
                 clr_i       => clr    ,
                 data_io     => data   ,
                 reg_o       => reg    ,
                 load_i      => load   ,
                 enable_i    => enable
             );

    -- Start the main test
    main_test : process is
    begin
        -- Check reset state
        clr    <= '1';
        enable <= '1'; -- When activating enable, remember to tristate data.
        data   <= "ZZZZZZZZ";
        wait for 80 ns;
        assert data    = "00000000";
        assert reg     = "00000000";

        -- Check tristate buffer
        enable <= '0';
        wait for 80 ns;
        assert data    = "ZZZZZZZZ";
        assert reg     = "00000000";

        -- Check setting register
        clr    <= '0';
        load   <= '1';
        enable <= '0'; -- When setting load, remember to clear enable.
        data   <= "01010101";
        wait for 80 ns;
        assert data    = "01010101";
        assert reg     = "01010101";

        -- Check tristate buffer
        enable <= '0';
        load   <= '0';
        data   <= "ZZZZZZZZ";
        wait for 80 ns;
        assert data    = "ZZZZZZZZ";
        assert reg     = "01010101";

        -- Check reading register
        clr    <= '0';
        load   <= '0'; -- When setting enable, remember to clear load.
        enable <= '1';
        data   <= "ZZZZZZZZ";
        wait for 80 ns;
        assert data    = "00000101";
        assert reg     = "01010101";

        -- Check reset state
        clr    <= '1';
        enable <= '1';
        data   <= "ZZZZZZZZ";
        wait for 80 ns;
        assert data    = "00000000";
        assert reg     = "00000000";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

