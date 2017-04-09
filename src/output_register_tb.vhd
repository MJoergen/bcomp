library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity output_register_tb is
end output_register_tb ;

architecture Structural of output_register_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal clr        : std_logic;
    signal load       : std_logic;

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
    inst_output_register : entity work.output_register
    port map (
                 clk_i       => clk    ,
                 clr_i       => clr    ,
                 data_i      => data   ,
                 reg_o       => reg    ,
                 load_i      => load   
             );

    -- Start the main test
    main_test : process is
    begin
        -- Check reset state
        clr    <= '1';
        data   <= "ZZZZZZZZ";
        wait for 80 ns;
        assert reg     = "00000000";

        -- Check not setting register
        clr    <= '0';
        load   <= '0';
        data   <= "01010101";
        wait for 80 ns;
        assert reg     = "00000000";

        -- Check setting register
        clr    <= '0';
        load   <= '1';
        data   <= "01010101";
        wait for 80 ns;
        assert reg     = "01010101";

        -- Check reset state
        clr    <= '1';
        data   <= "ZZZZZZZZ";
        wait for 80 ns;
        assert reg     = "00000000";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

