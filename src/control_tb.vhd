library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_tb is
end control_tb ;

architecture Structural of control_tb is

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Inputs to the DUT
    signal instruct :  std_logic_vector (3 downto 0);

    -- Output from the DUT
    signal control  :  std_logic_vector (15 downto 0);

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
    inst_control : entity work.control
    port map (
                 clk_i       => clk,
                 instruct_i  => instruct,
                 control_o   => control
             );

    -- Start the main test
    main_test : process is
    begin

        test_running <= false;
        wait;
    end process main_test;

end Structural;

