library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- clock_logic.vhd
-- This entity implements the feature described in the video
-- https://www.youtube.com/watch?v=SmQ5K7UQPMM

entity clock_logic is

    generic (
                SIMULATION : boolean := false
            );

    port (
             -- Clock input from crystal (for delay)
             clk_i       : in  std_logic;

             -- Switch input
             sw_i        : in  std_logic;

             -- Push button input
             btn_i       : in  std_logic;

             -- Halt input
             hlt_i       : in  std_logic;

             -- The derived clock output
             clk_deriv_o : out std_logic);

end clock_logic;

architecture Structural of clock_logic is
    signal btn_delay : std_logic;
    signal sw_reg    : std_logic;

begin
    -- Instantiate monostable
    inst_monostable_clock : entity work.monostable_clock
    generic map (
                    SIMULATION => SIMULATION
                )
    port map (
                 clk_i       => clk_i  ,
                 btn_i       => btn_i  ,
                 btn_delay_o => btn_delay
             );

    -- Instantiate bistable
    inst_bistable_clock : entity work.bistable_clock
    generic map (
                    SIMULATION => SIMULATION
                )
    port map (
                 clk_i    => clk_i  ,
                 sw_i     => sw_i   ,
                 sw_reg_o => sw_reg
             );

    clk_deriv_o <= ((clk_i and sw_reg) or (btn_delay and not sw_reg)) and not hlt_i;

end Structural;

