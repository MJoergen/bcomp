library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram74ls189_tb is
end ram74ls189_tb ;

architecture Structural of ram74ls189_tb is

    -- Inputs to the DUT
    signal clk        : std_logic;
    signal address    : std_logic_vector (3 downto 0);
    signal data_in    : std_logic_vector (3 downto 0);
    signal we         : std_logic;
    signal cs         : std_logic;

    -- Output from the DUT
    signal data_out   : std_logic_vector(3 downto 0);

    -- Control
    signal test_running : boolean := true;

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
    inst_ram74ls189 : entity work.ram74ls189
    generic map (
                    INITIAL => (0 => "1011", 1 => "0110", others => "0000")
                )
    port map (
                 clk_i       => clk      ,
                 address_i   => address  ,
                 data_i      => data_in  ,
                 we_i        => we       ,
                 cs_i        => cs       ,
                 data_o      => data_out
             );

    -- Start the main test
    main_test : process is
    begin
        -- Check tristate buffer
        we <= '0';
        cs <= '0';
        address <= "0000";
        wait until rising_edge(clk);
        assert data_out = "ZZZZ";

        -- Check reset state (reading from address 0)
        we <= '0';
        address <= "0000";
        cs <= '1';
        wait until rising_edge(clk);
        assert data_out = "1011";
        
        -- Check reset state (reading from address 1)
        we <= '0';
        address <= "0001";
        cs <= '1';
        wait until rising_edge(clk);
        assert data_out = "0110";
        
        -- Check writing to address 0
        address <= "0000";
        data_in <= "0110";
        we <= '1';
        wait until rising_edge(clk);
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "0110";


        -- Check writing to address 1
        address <= "0001";
        data_in <= "1101";
        we <= '1';
        wait until rising_edge(clk);
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "0110";

        -- Check reading from address 1
        address <= "0001";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "1101";


        -- Check writing to address 2
        address <= "0010";
        data_in <= "1010";
        we <= '1';
        wait until rising_edge(clk);
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "0110";

        -- Check reading from address 1
        address <= "0001";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "1101";

        -- Check reading from address 2
        address <= "0010";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "1010";


        -- Check writing to address 4
        address <= "0100";
        data_in <= "0101";
        we <= '1';
        wait until rising_edge(clk);
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "0110";

        -- Check reading from address 1
        address <= "0001";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "1101";

        -- Check reading from address 2
        address <= "0010";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "1010";

        -- Check reading from address 4
        address <= "0100";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "0101";


        -- Check writing to address 8
        address <= "1000";
        data_in <= "1011";
        we <= '1';
        wait until rising_edge(clk);
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "0110";

        -- Check reading from address 1
        address <= "0001";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "1101";

        -- Check reading from address 2
        address <= "0010";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "1010";

        -- Check reading from address 4
        address <= "0100";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "0101";

        -- Check reading from address 8
        address <= "1000";
        we <= '0';
        wait until rising_edge(clk);
        assert data_out = "1011";


        -- Check tristate buffer
        we <= '0';
        cs <= '0';
        address <= "0000";
        wait until rising_edge(clk);
        assert data_out = "ZZZZ";

        test_running <= false;
        wait;
    end process main_test;

end Structural;

