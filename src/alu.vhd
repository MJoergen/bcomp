library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- alu.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=S-3fXU3FZQc&index=16

entity alu is

    port (
             -- Control input:
             sub_i       : in  std_logic; -- called SU
             enable_i    : in  std_logic; -- called EO

             -- Data inputs
             areg_i      : in  std_logic_vector (7 downto 0);
             breg_i      : in  std_logic_vector (7 downto 0);

             -- Data bus connection
             result_o    : out std_logic_vector (7 downto 0);

             -- LED output
             led_o       : out std_logic_vector (7 downto 0)
         );

end alu;

architecture Structural of alu is

    signal plus   : std_logic_vector (7 downto 0);
    signal minus  : std_logic_vector (7 downto 0);
    signal result : std_logic_vector (7 downto 0);

begin

    -- Intermediate calculations
    -- Note. This is slightly cheating compared to the video
    -- because we're here relying on the synthesis tool
    -- using the chip's builtin adders and subtractors.
    plus  <= areg_i + breg_i;
    minus <= areg_i - breg_i;

    -- Multiplex the correct result depending on the operation.
    result <= minus when sub_i = '1' else plus;

    led_o <= result;

    -- The output is a tristate buffer.
    result_o <= result when enable_i = '1' else (others => 'Z');

end Structural;

