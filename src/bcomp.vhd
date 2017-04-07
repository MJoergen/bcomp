library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcomp is

   generic (
       FREQ       : integer := 25000000 -- Input clock frequency
       );
   port (
      -- Clock
      clk_i       : in  std_logic;  -- 25 MHz

      -- Input switches
      sw_i        : in  std_logic_vector (7 downto 0);

      -- Input buttons
      btn_i       : in  std_logic_vector (3 downto 0);

      -- pragma synthesis_off
      -- Used during testing to inject data onto the main data bus.
      data_i      : in  std_logic_vector (7 downto 0);
      -- pragma synthesis_on

      -- Output LEDs
      led_o       : out std_logic_vector (7 downto 0);

      -- Output segment display
      seg_ca_o    : out std_logic_vector (6 downto 0);
      seg_dp_o    : out std_logic;
      seg_an_o    : out std_logic_vector (3 downto 0)
      );

end bcomp;

architecture Structural of bcomp is

    -- The main internal clock
    signal clk  : std_logic;

    -- The main data bus
    -- All the blocks connected to the data bus
    -- must have an enable_i pin telling the block,
    -- whether to output data to the bus or not.
    -- Additionally, all these blocks provide
    -- access to the data before the output buffer.
    -- These blocks are: 
    --   A-register
    --   B-register
    --   instruction register
    --   ALU
    --   RAM
    signal databus       : std_logic_vector(7 downto 0);

    -- Interpretation of input switches.
    alias regs_clear     : std_logic is sw_i(0);
    alias areg_load      : std_logic is sw_i(1);
    alias areg_enable    : std_logic is sw_i(2);
    alias breg_load      : std_logic is sw_i(3);
    alias breg_enable    : std_logic is sw_i(4);
    alias alu_sub        : std_logic is sw_i(5);
    alias alu_enable     : std_logic is sw_i(6);
    alias clk_switch     : std_logic is sw_i(7);

    alias address_load   : std_logic is sw_i(5); -- Same as alu_sub for now.
    alias address_runmode: std_logic is sw_i(7); -- Same as clk_switch for now.

    signal areg_value    : std_logic_vector (7 downto 0);
    signal breg_value    : std_logic_vector (7 downto 0);
    signal ireg_value    : std_logic_vector (7 downto 0);
    signal alu_value     : std_logic_vector (7 downto 0);
    signal address_value : std_logic_vector (3 downto 0);

    constant ireg_load   : std_logic := '0';  -- Temporary
    constant ireg_enable : std_logic := '0';  -- Temporary

begin

    -- pragma synthesis_off
    databus <= data_i;
    -- pragma synthesis_on

    -- Instantiate clock module
    inst_clock_logic : entity work.clock_logic
    port map (
                 clk_i       => clk_i      , -- External crystal
                 sw_i        => clk_switch ,
                 btn_i       => btn_i(0)   ,
                 hlt_i       => '0'        ,
                 clk_deriv_o => clk         -- Main internal clock
             );

    -- Connect the registers to the main data bus

    -- Instantiate A-register
    inst_a_register : entity work.register_8bit
    port map (
                 clk_i       => clk          ,
                 load_i      => areg_load    , -- called AI
                 enable_i    => areg_enable  , -- called AO
                 clr_i       => regs_clear   ,
                 data_io     => databus      ,
                 reg_o       => areg_value     -- to ALU
             );

    -- Instantiate B-register
    inst_b_register : entity work.register_8bit
    port map (
                 clk_i       => clk          ,
                 load_i      => breg_load    , -- called BI
                 enable_i    => breg_enable  , -- called BO
                 clr_i       => regs_clear   ,
                 data_io     => databus      ,
                 reg_o       => breg_value     -- to ALU
             );

    -- Instantiate instruction register
    inst_instruction_register : entity work.register_8bit
    port map (
                 clk_i       => clk          ,
                 load_i      => ireg_load    , -- called II
                 enable_i    => ireg_enable  , -- called IO
                 clr_i       => regs_clear   ,
                 data_io     => databus      ,
                 reg_o       => ireg_value     -- to instruction decoder
             );

    -- Instantiate ALU
    inst_alu : entity work.alu
    port map (
                 sub_i       => alu_sub    , -- called SU
                 enable_i    => alu_enable , -- called EO
                 areg_i      => areg_value ,
                 breg_i      => breg_value ,
                 result_o    => databus    ,
                 led_o       => alu_value
             );

    -- Instantiate address register
    inst_memory_address_register : entity work.memory_address_register
    port map (
                 clk_i       => clk,
                 load_i      => address_load, -- called MI
                 address_i   => databus(3 downto 0),
                 address_o   => address_value,
                 runmode_i   => address_runmode,
                 sw_i        => sw_i(3 downto 0)
             );

    -- For now, just copy the data bus to the output LED's.
    -- This will later be multiplxed based on the push buttons.
    led_o <= databus;

    -- Not used at the moment.
    seg_ca_o <= "1111111";
    seg_dp_o <= '1';
    seg_an_o <= "1111";

end Structural;

