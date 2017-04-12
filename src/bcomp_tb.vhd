library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bcomp_tb is
end bcomp_tb ;

architecture Structural of bcomp_tb is

    function slv_to_string ( a: std_logic_vector) return string is
    variable b : string (a'length-1 downto 0) := (others => NUL);
    begin
        for i in a'length-1 downto 0 loop
            b(i) := std_logic'image(a(i))(2);
        end loop;
        return b;
    end function;

    --Clock
    signal clk : std_logic; -- 25 MHz
    signal test_running : boolean := true;

    -- slide-switches and push-buttons
    signal sw   : std_logic_vector (7 downto 0);
    signal btn  : std_logic_vector (3 downto 0);
    signal pmod : std_logic_vector (15 downto 0);

    alias btn_clk     : std_logic is btn(0);
    alias btn_write   : std_logic is btn(1);
    alias btn_reset   : std_logic is btn(2);
    
    alias sw_clk_free : std_logic is sw(0);
    alias sw_runmode  : std_logic is sw(1);

    alias sw_led_select  : std_logic_vector (2 downto 0) is sw(4 downto 2);
    constant LED_SELECT_BUS  : std_logic_vector (2 downto 0) := "000"; -- Databus
    constant LED_SELECT_ALU  : std_logic_vector (2 downto 0) := "001"; -- ALU output
    constant LED_SELECT_RAM  : std_logic_vector (2 downto 0) := "010"; -- RAM output
    constant LED_SELECT_ADDR : std_logic_vector (2 downto 0) := "011"; -- Memory address
    constant LED_SELECT_AREG : std_logic_vector (2 downto 0) := "100"; -- A register
    constant LED_SELECT_BREG : std_logic_vector (2 downto 0) := "101"; -- B register
    constant LED_SELECT_OUT  : std_logic_vector (2 downto 0) := "110"; -- Output register
    constant LED_SELECT_PC   : std_logic_vector (2 downto 0) := "111"; -- Program counter

    alias sw_disp_two_comp : std_logic is sw(5); -- Display two's complement

    alias pmod_address  : std_logic_vector (3 downto 0) is pmod(11 downto 8);
    alias pmod_data     : std_logic_vector (7 downto 0) is pmod( 7 downto 0);

    -- LED
    signal led : std_logic_vector (7 downto 0);

    -- Bus commands
    constant control_CE  : integer :=  0; -- Program counter count enable
    constant control_CO  : integer :=  1; -- Program counter output enable
    constant control_J   : integer :=  2; -- Program counter jump
    constant control_MI  : integer :=  3; -- Memory address register load
    constant control_RI  : integer :=  4; -- RAM load (write)
    constant control_RO  : integer :=  5; -- RAM output enable
    constant control_II  : integer :=  6; -- Instruction register load
    constant control_IO  : integer :=  7; -- Inttruction register output enable

    constant control_AI  : integer :=  8; -- A register load
    constant control_AO  : integer :=  9; -- A register output enable
    constant control_SU  : integer := 10; -- ALU subtract
    constant control_EO  : integer := 11; -- ALU output enable
    constant control_BI  : integer := 12; -- B register load
    constant control_OI  : integer := 13; -- Output register load
    constant control_HLT : integer := 14; -- Halt clock
    constant control_JC  : integer := 15; -- Jump if carry
 
    subtype control_type is std_logic_vector(15 downto 0);
    constant MEM_TO_AREG : control_type := (
            control_RO => '1', control_AI => '1', others => '0');
    constant MEM_TO_BREG : control_type := (
            control_RO => '1', control_BI => '1', others => '0');
    constant ALU_TO_AREG : control_type := (
            control_EO => '1', control_AI => '1', others => '0');
    constant AREG_TO_MEM : control_type := (
            control_AO => '1', control_RI => '1', others => '0');
    constant AREG_TO_ADDR : control_type := (
            control_AO => '1', control_MI => '1', others => '0');
    constant ALU_SUB : control_type := (
            control_SU => '1', others => '0');
    constant NOP : control_type := (
            others => '0');
    constant AREG_TO_OUT : control_type := (
            control_AO => '1', control_OI => '1', others => '0');

    -- No specific opcodes, only used for testing.
    constant AREG_TO_BUS : control_type := (
            control_AO => '1', others => '0');
    constant ALU_TO_BUS : control_type := (
            control_EO => '1', others => '0');
    constant BUS_TO_AREG : control_type := (
            control_AI => '1', others => '0');
    constant BUS_TO_BREG : control_type := (
            control_BI => '1', others => '0');
    constant BUS_TO_ADDR : control_type := (
            control_MI => '1', others => '0');

    -- This contains the contents of the memory
    type mem_type is array (0 to 15) of std_logic_vector(7 downto 0);
    constant mem : mem_type := (
        "01110001",  -- 00: 71  LDI 0x01
        "01001110",  -- 01: 4E  STA [0x0E] (Y)
        "01110000",  -- 02: 70  LDI 0x00
        "01010000",  -- 03: 50  OUT
        "00101110",  -- 04: 2E  ADD [0x0E] (Y)
        "01001111",  -- 05: 4F  STA [0x0F] (Z)
        "00011110",  -- 06: 1E  LDA [0x0E] (Y)
        "01001101",  -- 07: 4D  STA [0x0D] (X)
        "00011111",  -- 08: 1F  LDA [0x0F] (Z)
        "01001110",  -- 09: 4E  STA [0x0E] (Y)
        "00011101",  -- 0A: 1D  LDA [0x0D] (X)
        "10000000",  -- 0B: 80  JC 0x00
        "01100011",  -- 0C: 63  J 0x03
        "00000000",  -- 0D: 00  X
        "00000000",  -- 0E: 00  Y
        "00000000"); -- 0F: 00  Z

    -- VGA output
    signal vga_hs  : std_logic;
    signal vga_vs  : std_logic;
    signal vga_col : std_logic_vector(7 downto 0);

begin
    -- Simulate external crystal clock (25 MHz)
    clk_gen : process
    begin
        if not test_running then
            wait;
        end if;

        clk <= '1', '0' after 20 ns;
        wait for 40 ns;
    end process clk_gen;

    -- Instantiate DUT
    inst_bcomp : entity work.bcomp
    generic map (
                    SIMULATION => true ,
                    FREQ => 25000000
                )
    port map (
                 clk_i        => clk     ,
                 sw_i         => sw      ,
                 btn_i        => btn     ,
                 pmod_i       => pmod    ,
                 led_o        => led     , 
                 seg_ca_o     => open    ,
                 seg_dp_o     => open    ,
                 seg_an_o     => open    ,
                 vga_hs_o     => vga_hs  ,
                 vga_vs_o     => vga_vs  ,
                 vga_col_o    => vga_col
             );

    -- Start the main test
    main_test : process is
    begin
        -- Set initial values
        sw        <= "00000000";
        btn       <= "0000";
        pmod      <= (others => '0');
        btn_reset <= '1';

        -- Configure DUT
        sw_clk_free   <= '0'; -- Use manual clock (switch off control logic)
        sw_runmode    <= '0'; -- Set RAM to programming mode
        sw_led_select <= LED_SELECT_ADDR;

--        -- Program the RAM
--        for i in 0 to 15 loop
--            pmod_address <= std_logic_vector(to_unsigned(i, 4));
--            pmod_data    <= mem(i);
--            wait until falling_edge(clk);
--            btn_write  <= '1';
--            wait until rising_edge(clk);
--            assert led = std_logic_vector(to_unsigned(i, 8));
--            btn_write  <= '0';
--        end loop;

        -- Reset DUT
        sw_clk_free <= '1'; -- Use freerunning (astable) clock
        sw_runmode  <= '1'; -- Set memory to run mode.
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        btn_reset <= '0';
        wait until rising_edge(clk);

        wait for 400 us;

        test_running <= false;
        wait;
    end process main_test;

end Structural;

