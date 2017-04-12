library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.vga_bitmap_pkg.ALL;

-- vga_disp.vhd
-- This shows the various debug outputs on a VGA screen.

entity vga_disp is
    port (
        -- From the VGA sync controller.
        hcount_i  : in  std_logic_vector(10 downto 0); -- horizontal count of the currently displayed pixel (even if not in visible area)
        vcount_i  : in  std_logic_vector(10 downto 0); -- vertical count of the currently active video line (even if not in visible area)
        blank_i   : in  std_logic;                     -- active when pixel is not in visible area.

        led_i     : in  std_logic_vector(7 downto 0);  -- This is the value to be shown.
        vga_o     : out std_logic_vector(7 downto 0)   -- Color output
		);
end vga_disp;

architecture Behavioral of vga_disp is

    constant OFFSET_X : integer := 50;  -- X position of first bit
    constant OFFSET_Y : integer := 150; -- Y position of first bit

    constant vga_white      : std_logic_vector(7 downto 0) := "11111111"; -- 0xFF
    constant vga_light      : std_logic_vector(7 downto 0) := "11011010"; -- 0xDA
    constant vga_dark       : std_logic_vector(7 downto 0) := "00100101"; -- 0x25
    constant vga_black      : std_logic_vector(7 downto 0) := "00000000"; -- 0x00
    constant vga_background : std_logic_vector(7 downto 0) := "10110110"; -- 0xB6

begin

    gen_vga : process (hcount_i, vcount_i, blank_i, led_i) is
        variable hcount : integer;
        variable vcount : integer;
        variable col    : integer;
        variable row    : integer;
        variable xdiff  : integer range 0 to 15;
        variable ydiff  : integer range 0 to 15;
        variable bitmap : vga_bitmap_t;

    begin
        hcount := conv_integer(hcount_i);
        vcount := conv_integer(vcount_i);
        col    := 0;
        row    := 0;
        xdiff  := 0;
        ydiff  := 0;

        vga_o  <= vga_black; -- Outside visible area, the color must be black.

        if blank_i = '0' then
            vga_o <= vga_background; -- Default background color on screen.

            if (hcount >= OFFSET_X) and (hcount < OFFSET_X+16*8)
                and (vcount >= OFFSET_Y) and (vcount < OFFSET_Y+16) then

                col   := (hcount - OFFSET_X) / 16;
                xdiff := (hcount - OFFSET_X) rem 16;
                ydiff := (vcount - OFFSET_Y) rem 16;

                if led_i(7-col) = '1' then
                    bitmap := vga_bitmap_1;
                else
                    bitmap := vga_bitmap_0;
                end if;

                if bitmap(ydiff*16 + xdiff) = '1' then
                    vga_o <= vga_light;
                else
                    vga_o <= vga_dark;
                end if;
            end if;

            if (hcount >= OFFSET_X) and (hcount <= OFFSET_X+16*8)
                and (vcount >= OFFSET_Y) and (vcount <= OFFSET_Y+16) then

                if ydiff = 0 or xdiff = 0 then
                    vga_o <= vga_white;
                end if;
            end if;
        end if;
    end process gen_vga;

end Behavioral;

