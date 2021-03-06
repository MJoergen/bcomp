library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- control.vhd
-- Based on the videos here:
-- https://www.youtube.com/watch?v=9PPrrSyubG0
-- https://www.youtube.com/watch?v=35zLnS3fXeA

-- List of instructions:
-- =====================
-- 0000  NOP  No operation
-- 0001  LDA  Load memory to A
-- 0010  ADD  Add
-- 0011  SUB  Subtract
-- 0100  STA  Copy A to Ram
-- 0101  OUT  Copy A to Output
-- 0110  JMP  Jump to address
-- 0111  LDI  Load immediate to A
-- 1000  JC   Jump if carry flag set
-- 1111  HLT  Halt execution

-- All instructions take six cycles - three fetch and three execute.

entity control is

    port (
             -- System clock
             clk_i      : in  std_logic;

             -- Reset signal
             rst_i      : in  std_logic;

             -- Current instruction executing
             instruct_i : in  std_logic_vector(3 downto 0);

             -- The derived clock output
             control_o  : out std_logic_vector(15 downto 0);

             -- Debug output
             counter_o  : out std_logic_vector(2 downto 0));

end control;

architecture Structural of control is

    subtype control_type is std_logic_vector(15 downto 0);

    constant control_CE  : integer := 0;  -- Program counter count enable
    constant control_CO  : integer := 1;  -- Program counter output enable
    constant control_J   : integer := 2;  -- Program counter jump
    constant control_MI  : integer := 3;  -- Memory address register load
    constant control_RI  : integer := 4;  -- RAM load (write)
    constant control_RO  : integer := 5;  -- RAM output enable
    constant control_II  : integer := 6;  -- Instruction register load
    constant control_IO  : integer := 7;  -- Instruction register output enable
 
    constant control_AI  : integer := 8;  -- A register load
    constant control_AO  : integer := 9;  -- A register output enable
    constant control_SU  : integer := 10; -- ALU subtract
    constant control_EO  : integer := 11; -- ALU output enable
    constant control_BI  : integer := 12; -- B register load
    constant control_OI  : integer := 13; -- Output register load
    constant control_HLT : integer := 14; -- Output register load
    constant control_JC  : integer := 15; -- B register output enable

    signal counter       : std_logic_vector(2 downto 0) := "000"; -- Eight possible states
    signal micro_op_addr : integer range 0 to 5*16-1;

    ------------------------------------------
    -- List of all possible micro-instructions
    ------------------------------------------

    -- Common for all instructions
    constant PC_TO_ADDR : control_type := (
            control_CO => '1',
            control_CE => '1',
            control_MI => '1', others => '0');
    constant MEM_TO_IR : control_type := (
            control_RO => '1',
            control_II => '1', others => '0');

    -- LDA [addr]
    constant IR_TO_ADDR : control_type := (
            control_IO => '1',
            control_MI => '1', others => '0');
    constant MEM_TO_AREG : control_type := (
            control_RO => '1',
            control_AI => '1', others => '0');
    constant NOP : control_type := (others => '0');

    -- ADD [addr]
    constant MEM_TO_BREG : control_type := (
            control_RO => '1',
            control_BI => '1', others => '0');
    constant ALU_TO_AREG : control_type := (
            control_EO => '1',
            control_AI => '1', others => '0');

    -- SUB [addr]
    constant MEM_TO_BREG_SUB : control_type := (
            control_RO => '1',
            control_SU => '1',
            control_BI => '1', others => '0');

    -- STA [addr]
    constant AREG_TO_MEM : control_type := (
            control_AO => '1',
            control_RI => '1', others => '0');

    -- OUT
    constant AREG_TO_OUT : control_type := (
            control_AO => '1',
            control_OI => '1', others => '0');

    -- JMP
    constant IR_TO_PC : control_type := (
            control_IO => '1',
            control_J  => '1', others => '0');

    -- LDI
    constant IR_TO_AREG : control_type := (
            control_IO => '1',
            control_AI => '1', others => '0');

    -- JC
    constant IR_TO_PC_CARRY : control_type := (
            control_IO => '1',
            control_JC => '1', others => '0');

    -- HLT
    constant HLT : control_type := (
            control_HLT => '1', others => '0');

    type micro_op_rom_type is array(0 to 5*16-1) of std_logic_vector(15 downto 0);

    constant micro_op_rom : micro_op_rom_type := (
    -- 0000  NOP
    PC_TO_ADDR, MEM_TO_IR, NOP, NOP, NOP,

    -- 0001  LDA [addr]
    PC_TO_ADDR, MEM_TO_IR, IR_TO_ADDR, MEM_TO_AREG, NOP,

    -- 0010  ADD [addr]
    PC_TO_ADDR, MEM_TO_IR, IR_TO_ADDR, MEM_TO_BREG, ALU_TO_AREG,

    -- 0011  SUB [addr]
    PC_TO_ADDR, MEM_TO_IR, IR_TO_ADDR, MEM_TO_BREG_SUB, ALU_TO_AREG,

    -- 0100  STA [addr]
    PC_TO_ADDR, MEM_TO_IR, IR_TO_ADDR, AREG_TO_MEM, NOP,

    -- 0101  OUT
    PC_TO_ADDR, MEM_TO_IR, AREG_TO_OUT, NOP, NOP,

    -- 0110  JMP
    PC_TO_ADDR, MEM_TO_IR, IR_TO_PC, NOP, NOP,

    -- 0111  LDI
    PC_TO_ADDR, MEM_TO_IR, IR_TO_AREG, NOP, NOP,

    -- 1000  JC
    PC_TO_ADDR, MEM_TO_IR, IR_TO_PC_CARRY, NOP, NOP,

    -- 1001  HLT
    PC_TO_ADDR, MEM_TO_IR, HLT, NOP, NOP,

    -- 1010  HLT
    PC_TO_ADDR, MEM_TO_IR, HLT, NOP, NOP,

    -- 1011  HLT
    PC_TO_ADDR, MEM_TO_IR, HLT, NOP, NOP,

    -- 1100  HLT
    PC_TO_ADDR, MEM_TO_IR, HLT, NOP, NOP,

    -- 1101  HLT
    PC_TO_ADDR, MEM_TO_IR, HLT, NOP, NOP,

    -- 1110  HLT
    PC_TO_ADDR, MEM_TO_IR, HLT, NOP, NOP,

    -- 1111  HLT
    PC_TO_ADDR, MEM_TO_IR, HLT, NOP, NOP);

begin

    process(clk_i, rst_i)
    begin
        if rst_i = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk_i) then
            if counter = 4 then
                counter <= "000";
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    micro_op_addr <= conv_integer(instruct_i)*5 + conv_integer(counter);

    control_o <= micro_op_rom(micro_op_addr);

    counter_o <= counter;

end Structural;

