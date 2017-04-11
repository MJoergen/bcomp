library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- ram74ls189_datatypes.vhd
-- This is needed in order to be able to give the RAM initial values.

package ram74ls189_datatypes is

    type ram_type is array (0 to 15) of std_logic_vector(3 downto 0);

end ram74ls189_datatypes;

package body ram74ls189_datatypes is
end ram74ls189_datatypes;

