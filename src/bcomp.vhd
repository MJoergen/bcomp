library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- This is the top level
-- The video in https://www.youtube.com/watch?v=g_1HyxBzjl0 gives a 
-- high level view of the computer.

entity bcomp is

    generic (
                SIMULATION : boolean := false;
                FREQ       : integer := 25000000 -- Input clock frequency
            );
   port (
      -- Clock
      clk_i       : in  std_logic;  -- 25 MHz

      -- Input switches
      sw_i        : in  std_logic_vector (7 downto 0);

      -- Inputs from PMOD's
      pmod_i      : in  std_logic_vector (15 downto 0);

      -- Input buttons
      btn_i       : in  std_logic_vector (3 downto 0);

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
    --   Program counter
    signal databus       : std_logic_vector(7 downto 0);

    -- Interpretation of input button and switches.
    alias btn_clk     : std_logic is btn_i(0);
    alias btn_write      : std_logic is btn_i(1);
    alias btn_reset      : std_logic is btn_i(2);

    alias sw_clk_free     : std_logic is sw_i(0);
    alias sw_runmode        : std_logic is sw_i(1);
    alias sw_address     : std_logic_vector (3 downto 0) is pmod_i(11 downto 8);
    alias sw_data        : std_logic_vector (7 downto 0) is pmod_i( 7 downto 0);

    alias led_select     : std_logic_vector (2 downto 0) is sw_i(4 downto 2);
    constant LED_SELECT_BUS  : std_logic_vector (2 downto 0) := "000";
    constant LED_SELECT_ALU  : std_logic_vector (2 downto 0) := "001";
    constant LED_SELECT_RAM  : std_logic_vector (2 downto 0) := "010";
    constant LED_SELECT_ADDR : std_logic_vector (2 downto 0) := "011";
    constant LED_SELECT_AREG : std_logic_vector (2 downto 0) := "100";
    constant LED_SELECT_BREG : std_logic_vector (2 downto 0) := "101";
    constant LED_SELECT_OUT  : std_logic_vector (2 downto 0) := "110";
    constant LED_SELECT_IREG : std_logic_vector (2 downto 0) := "111";

    -- Communication between blocks
    signal areg_value    : std_logic_vector (7 downto 0);
    signal breg_value    : std_logic_vector (7 downto 0);
    signal ireg_value    : std_logic_vector (7 downto 0);
    signal address_value : std_logic_vector (3 downto 0);
    signal disp_two_comp : std_logic;
    signal disp_value    : std_logic_vector (7 downto 0);
    signal carry         : std_logic;
    signal pc_load       : std_logic;

    -- Debug outputs connected to LEDs
    signal alu_value     : std_logic_vector (7 downto 0);
    signal ram_value     : std_logic_vector (7 downto 0);
    signal pc_value      : std_logic_vector (3 downto 0);

    -- Control signals
    signal control    : std_logic_vector (15 downto 0);
    alias  control_CE : std_logic is control(0);   -- Program counter count enable
    alias  control_CO : std_logic is control(1);   -- Program counter output enable
    alias  control_J  : std_logic is control(2);   -- Program counter jump
    alias  control_MI : std_logic is control(3);   -- Memory address register load
    alias  control_RI : std_logic is control(4);   -- RAM load (write)
    alias  control_RO : std_logic is control(5);   -- RAM output enable
    alias  control_II : std_logic is control(6);   -- Instruction register load
    alias  control_IO : std_logic is control(7);   -- Instruction register output enable

    alias  control_AI : std_logic is control(8);   -- A register load
    alias  control_AO : std_logic is control(9);   -- A register output enable
    alias  control_SU : std_logic is control(10);  -- ALU subtract
    alias  control_EO : std_logic is control(11);  -- ALU output enable
    alias  control_BI : std_logic is control(12);  -- B register load
    alias  control_OI : std_logic is control(13);  -- Program counter count enable
    alias  control_HLT: std_logic is control(14);  -- Halt clock
    alias  control_JC : std_logic is control(15);  -- Jump if carry

begin

    led_o <= databus                when led_select = LED_SELECT_BUS  else
             alu_value              when led_select = LED_SELECT_ALU  else
             ram_value              when led_select = LED_SELECT_RAM  else
             "0000" & address_value when led_select = LED_SELECT_ADDR else
             areg_value             when led_select = LED_SELECT_AREG else
             breg_value             when led_select = LED_SELECT_BREG else
             disp_value             when led_select = LED_SELECT_OUT  else
             ireg_value             when led_select = LED_SELECT_IREG;

    -- Instantiate clock module
    inst_clock_logic : entity work.clock_logic
    generic map (
                    SIMULATION => SIMULATION
                )
    port map (
                 clk_i       => clk_i       , -- External crystal
                 sw_i        => sw_clk_free  ,
                 btn_i       => btn_clk  ,
                 hlt_i       => control_HLT ,
                 clk_deriv_o => clk           -- Main internal clock
             );

    -- Instantiate A-register
    inst_a_register : entity work.register_8bit
    port map (
                 clk_i       => clk          ,
                 load_i      => control_AI   ,
                 enable_i    => control_AO   ,
                 clr_i       => btn_reset    ,
                 data_io     => databus      ,
                 reg_o       => areg_value     -- to ALU
             );

    -- Instantiate B-register
    inst_b_register : entity work.register_8bit
    port map (
                 clk_i       => clk          ,
                 load_i      => control_BI   ,
                 enable_i    => '0'          ,
                 clr_i       => btn_reset    ,
                 data_io     => databus      ,
                 reg_o       => breg_value     -- to ALU
             );

    -- Instantiate instruction register
    inst_instruction_register : entity work.instruction_register
    port map (
                 clk_i       => clk          ,
                 load_i      => control_II   ,
                 enable_i    => control_IO   ,
                 clr_i       => btn_reset    ,
                 data_io     => databus      ,
                 reg_o       => ireg_value     -- to instruction decoder
             );

    -- Instantiate ALU
    inst_alu : entity work.alu
    port map (
                 sub_i       => control_SU ,
                 enable_i    => control_EO ,
                 areg_i      => areg_value ,
                 breg_i      => breg_value ,
                 result_o    => databus    ,
                 carry_o     => carry      ,
                 led_o       => alu_value    -- Debug output
             );

    -- Instantiate memory address register
    inst_memory_address_register : entity work.memory_address_register
    port map (
                 clk_i       => clk                 ,
                 load_i      => control_MI          ,
                 address_i   => databus(3 downto 0) ,
                 runmode_i   => sw_runmode             ,
                 sw_i        => sw_address          ,
                 address_o   => address_value         -- to RAM module
             );

    -- Instantiate RAM module
    inst_ram_module : entity work.ram_module
    port map (
                 wr_i        => control_RI    ,
                 enable_i    => control_RO    ,
                 data_io     => databus       ,
                 address_i   => address_value ,
                 runmode_i   => sw_runmode       ,
                 sw_data_i   => sw_data       ,
                 wr_button_i => btn_write     ,
                 data_led_o  => ram_value       -- Debug output
             );

    pc_load <= control_J or (control_JC and carry);

    -- Instantiate Program counter
    inst_program_counter : entity work.program_counter
    port map (
                 clk_i       => clk         ,
                 clr_i       => btn_reset   ,
                 data_io     => databus     ,
                 load_i      => pc_load     ,
                 enable_i    => control_CO  ,
                 count_i     => control_CE  ,
                 led_o       => pc_value      -- Debug output
             );

    -- Instantiate Display
    inst_display : entity work.display
    port map (
                 clk_i       => clk_i         , -- Use crystal clock
                 two_comp_i  => disp_two_comp ,
                 value_i     => disp_value    ,
                 seg_ca_o    => seg_ca_o      ,
                 seg_dp_o    => seg_dp_o      ,
                 seg_an_o    => seg_an_o 
             );

    -- Instantiate output register
    inst_output_register : entity work.output_register
    port map (
                 clk_i       => clk        ,
                 clr_i       => btn_reset  ,
                 data_i      => databus    ,
                 load_i      => control_OI ,
                 reg_o       => disp_value  -- Connected to display module
             );

    -- Instantiate control module
    inst_control : entity work.control
    port map (
                 clk_i       => clk                    ,
                 rst_i       => btn_reset              ,
                 instruct_i  => ireg_value(7 downto 4) ,
                 control_o   => control
             );

end Structural;

