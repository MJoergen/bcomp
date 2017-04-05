library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_tb is
end alu_tb ;

architecture Structural of alu_tb is

    -- Inputs to the DUT
    signal areg       : std_logic_vector (7 downto 0);
    signal breg       : std_logic_vector (7 downto 0);
    signal sub        : std_logic;
    signal enable     : std_logic;

    -- Output from the DUT
    signal internal   : std_logic_vector (7 downto 0);
    signal result     : std_logic_vector (7 downto 0);

begin
    -- Instantiate DUT
    inst_alu : entity work.alu
    port map (
                 areg_i      => areg      ,
                 breg_i      => breg      ,
                 sub_i       => sub       ,
                 enable_i    => enable    ,
                 internal_o  => internal  ,
                 result_o    => result
             );

    -- Start the main test
    main_test : process is
    begin
        -- Clear all inputs
        enable <= '0';
        areg <= "00000000";
        breg <= "00000000";
        sub <= '0';
        wait for 40 ns;
        assert internal = "00000000";
        assert result   = "ZZZZZZZZ";

        areg <= "01010101";
        breg <= "00110011";
        sub <= '0';
        wait for 40 ns;
        assert internal = "10001000";
        assert result   = "ZZZZZZZZ";

        enable <= '1';
        wait for 40 ns;
        assert internal = "10001000";
        assert result   = "10001000"; -- 0x55 + 0x33 = 0x88

        enable <= '0';
        wait for 40 ns;
        assert internal = "10001000";
        assert result   = "ZZZZZZZZ";

        sub <= '1';
        wait for 40 ns;
        assert internal = "00100010";
        assert result   = "ZZZZZZZZ";

        enable <= '1';
        wait for 40 ns;
        assert internal = "00100010";
        assert result   = "00100010"; -- 0x55 - 0x33 = 0x22

        enable <= '0';
        wait for 40 ns;
        assert internal = "00100010";
        assert result   = "ZZZZZZZZ";

        wait;
    end process main_test;

end Structural;

