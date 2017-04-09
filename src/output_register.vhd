library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- output_register.vhd
-- This entity implements the feature described in the video

entity output_register is

    port (
             -- Clock input
             clk_i    : in std_logic;

             -- Control inputs
             load_i   : in std_logic; -- called AI or BI or II.
             clr_i    : in std_logic;

             -- Data bus connection
             data_i   : in std_logic_vector(7 downto 0);

             -- To display module
             reg_o    : out std_logic_vector(7 downto 0)
         );


end output_register;

architecture Structural of output_register is

    signal data : std_logic_vector(7 downto 0);

begin
    
    process(clk_i, clr_i)
    begin
        if clr_i = '1' then
            data <= (others => '0');
        elsif rising_edge(clk_i) then
            if load_i = '1' then
                data <= data_i;
            end if;
        end if;
    end process;

    reg_o <= data;

end Structural;

