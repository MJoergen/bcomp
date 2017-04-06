library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram74ls189_tb is
end ram74ls189_tb ;

architecture Structural of ram74ls189_tb is

    -- Inputs to the DUT
    signal address    : std_logic_vector (3 downto 0);
    signal data_in    : std_logic_vector (3 downto 0);
    signal we         : std_logic;
    signal cs         : std_logic;

    -- Output from the DUT
    signal data_out   : std_logic_vector(3 downto 0);

begin
    -- Instantiate DUT
    inst_ram74ls189 : entity work.ram74ls189
    port map (
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
        wait for 100 ns;
        assert data_out = "ZZZZ";

        -- Check reset state (reading from address 0)
        we <= '0';
        address <= "0000";
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "0000";
        
        -- Check writing to address 0
        address <= "0000";
        data_in <= "0110";
        we <= '1';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "0110";


        -- Check writing to address 1
        address <= "0001";
        data_in <= "1101";
        we <= '1';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "0110";

        -- Check reading from address 1
        address <= "0001";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "1101";


        -- Check writing to address 2
        address <= "0010";
        data_in <= "1010";
        we <= '1';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "0110";

        -- Check reading from address 1
        address <= "0001";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "1101";

        -- Check reading from address 2
        address <= "0010";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "1010";


        -- Check writing to address 4
        address <= "0100";
        data_in <= "0101";
        we <= '1';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "0110";

        -- Check reading from address 1
        address <= "0001";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "1101";

        -- Check reading from address 2
        address <= "0010";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "1010";

        -- Check reading from address 4
        address <= "0100";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "0101";


        -- Check writing to address 8
        address <= "1000";
        data_in <= "1011";
        we <= '1';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "ZZZZ";

        -- Check reading from address 0
        address <= "0000";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "0110";

        -- Check reading from address 1
        address <= "0001";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "1101";

        -- Check reading from address 2
        address <= "0010";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "1010";

        -- Check reading from address 4
        address <= "0100";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "0101";

        -- Check reading from address 8
        address <= "1000";
        we <= '0';
        cs <= '0', '1' after 20 ns;
        wait for 100 ns;
        assert data_out = "1011";


        -- Check tristate buffer
        we <= '0';
        cs <= '0';
        address <= "0000";
        wait for 100 ns;
        assert data_out = "ZZZZ";

        wait;
    end process main_test;

end Structural;

