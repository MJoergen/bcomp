library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control_tb is
end control_tb ;

architecture Structural of control_tb is

    function slv_to_string ( a: std_logic_vector) return string is
    variable b : string (a'length-1 downto 0) := (others => NUL);
    begin
        for i in a'length-1 downto 0 loop
            b(i) := std_logic'image(a(i))(2);
        end loop;
        return b;
    end function;

    -- Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- Reset
    signal rst : std_logic;

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
                 rst_i       => rst,
                 instruct_i  => instruct,
                 control_o   => control
             );

    -- Start the main test
    main_test : process is
    begin

        rst <= '1';
        instruct <= "0000";
        wait until falling_edge(clk);
        assert control = X"000A" -- PC to ADDR
            report "received " & slv_to_string(control);

        rst <= '0';
        wait until falling_edge(clk);
        assert control = X"0060" -- MEM to IR
            report "received " & slv_to_string(control);

        wait until falling_edge(clk);
        assert control = X"0001" -- PC count
            report "received " & slv_to_string(control);

        wait until falling_edge(clk);
        assert control = X"0000" -- NOP
            report "received " & slv_to_string(control);

        wait until falling_edge(clk);
        assert control = X"0000" -- NOP
            report "received " & slv_to_string(control);

        wait until falling_edge(clk);
        assert control = X"0000" -- NOP
            report "received " & slv_to_string(control);

        wait until falling_edge(clk);
        assert control = X"0000" -- NOP
            report "received " & slv_to_string(control);

        wait until falling_edge(clk);
        assert control = X"0000" -- NOP
            report "received " & slv_to_string(control);

        test_running <= false;
        wait;
    end process main_test;

end Structural;

