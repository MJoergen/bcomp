library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- cpu_module.vhd

entity cpu_module is

    port (
             -- Clock input from crystal.
             clk_i       : in    std_logic;

             rst_i       : in    std_logic;

             addr_o      : out   std_logic_vector (3 downto 0);

             data_io     : inout std_logic_vector (7 downto 0);

             out_cs_o    : out   std_logic;
             ram_cs_o    : out   std_logic;
             ram_wr_o    : out   std_logic;
             hlt_o       : out   std_logic;

             led_array_o : out   std_logic_vector(9*8-1 downto 0)
                                -- PC
                                -- BREG
                                -- AREG
                                -- ADR
                                -- ALU
                                -- BUS
                                -- IREG
                                -- CON-H
                                -- CON-L
         );

end cpu_module;

architecture Structural of cpu_module is

    -- Communication between blocks
    signal areg_value    : std_logic_vector (7 downto 0);
    signal breg_value    : std_logic_vector (7 downto 0);
    signal ireg_value    : std_logic_vector (3 downto 0); -- Upper four bits
    signal address_value : std_logic_vector (3 downto 0);
    signal carry         : std_logic;
    signal carry_reg     : std_logic; -- Registered value of carry
    signal pc_load       : std_logic;

    -- Debug outputs connected to LEDs
    signal alu_value     : std_logic_vector (7 downto 0);
    signal pc_value      : std_logic_vector (3 downto 0);
    signal counter       : std_logic_vector (2 downto 0); -- from Control module.

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
    alias  control_OI : std_logic is control(13);  -- Output register load
    alias  control_HLT: std_logic is control(14);  -- Halt clock
    alias  control_JC : std_logic is control(15);  -- Jump if carry

begin

    led_array_o <= "0000" & ireg_value &         -- IREG
                   control &                     -- CONH & CONL
                   clk_i & counter & pc_value &  -- PC
                   breg_value &                  -- BREG
                   areg_value &                  -- AREG
                   "0000" & address_value &      -- ADR
                   alu_value &                   -- ALU
                   data_io;                      -- BUS

    addr_o   <= address_value;
    hlt_o    <= control_HLT;
    out_cs_o <= control_OI;
    ram_cs_o <= control_RI or control_RO;
    ram_wr_o <= control_RI;

    pc_load <= control_J or (control_JC and carry_reg);

    process (clk_i)
    begin
        if rising_edge(clk_i) then
            if control_EO = '1' then
                carry_reg <= carry;
            end if;
        end if;
    end process;

    -- Instantiate Program counter
    inst_program_counter : entity work.program_counter
    port map (
                 clk_i       => clk_i       ,
                 clr_i       => rst_i       ,
                 data_io     => data_io     ,
                 load_i      => pc_load     ,
                 enable_i    => control_CO  ,
                 count_i     => control_CE  ,
                 led_o       => pc_value      -- Debug output
             );

    -- Instantiate Control module
    inst_control : entity work.control
    port map (
                 clk_i       => clk_i      ,
                 rst_i       => rst_i      ,
                 instruct_i  => ireg_value ,
                 control_o   => control    ,
                 counter_o   => counter       -- Debug output
             );

    -- Instantiate Instruction register
    inst_instruction_register : entity work.instruction_register
    port map (
                 clk_i       => clk_i      ,
                 clr_i       => rst_i      ,
                 load_i      => control_II ,
                 enable_i    => control_IO ,
                 data_io     => data_io    ,
                 reg_o       => ireg_value   -- to instruction decoder
             );

    -- Instantiate A-register
    inst_a_register : entity work.register_8bit
    port map (
                 clk_i       => clk_i      ,
                 clr_i       => rst_i      ,
                 load_i      => control_AI ,
                 enable_i    => control_AO ,
                 data_io     => data_io    ,
                 reg_o       => areg_value   -- to ALU
             );

    -- Instantiate B-register
    inst_b_register : entity work.register_8bit
    port map (
                 clk_i       => clk_i      ,
                 clr_i       => rst_i      ,
                 load_i      => control_BI ,
                 enable_i    => '0'        ,
                 data_io     => data_io    ,
                 reg_o       => breg_value   -- to ALU
             );

    -- Instantiate ALU
    inst_alu : entity work.alu
    port map (
                 sub_i       => control_SU ,
                 enable_i    => control_EO ,
                 areg_i      => areg_value ,
                 breg_i      => breg_value ,
                 result_o    => data_io    ,
                 carry_o     => carry      ,
                 led_o       => alu_value    -- Debug output
             );

    -- Instantiate Memory Address Register
    inst_memory_address_register : entity work.memory_address_register
    port map (
                 clk_i       => clk_i               ,
                 load_i      => control_MI          ,
                 address_i   => data_io(3 downto 0) ,
                 address_o   => address_value         -- to RAM module
             );


end Structural;

