library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package vga_bitmap_pkg is
    subtype vga_bitmap_t is std_logic_vector(0 to 255);

    constant vga_bitmap_char_0 : vga_bitmap_t := (
        "0000000000000000" &
        "0000000000000000" &
        "0000000111000000" &
        "0000001000100000" &
        "0000010000010000" &
        "0000010000010000" &
        "0000010000010000" &
        "0000010000010000" &
        "0000010000010000" &
        "0000010000010000" &
        "0000010000010000" &
        "0000010000010000" &
        "0000001000100000" &
        "0000000111000000" &
        "0000000000000000" &
        "0000000000000000");

    constant vga_bitmap_char_1 : vga_bitmap_t := (
        "0000000000000000" &
        "0000000000000000" &
        "0000000110000000" &
        "0000011010000000" &
        "0000000010000000" &
        "0000000010000000" &
        "0000000010000000" &
        "0000000010000000" &
        "0000000010000000" &
        "0000000010000000" &
        "0000000010000000" &
        "0000000010000000" &
        "0000000010000000" &
        "0000011111110000" &
        "0000000000000000" &
        "0000000000000000");

    -- This is the Radon Wide format from: https://hea-www.harvard.edu/~fine/Tech/x11fonts.html
    constant vga_bitmap_char_space : vga_bitmap_t := ( -- This is used instead of space.
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_A : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03E0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"05D0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_B : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"05e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"05e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"05e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_C : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03e0" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"03e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_D : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"05e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"05e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_E : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03e0" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"05c0" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"03e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_F : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03e0" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"05c0" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_G : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03e0" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"04d0" &
        X"0410" &
        X"0410" &
        X"03e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_H : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"05d0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_I : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_J : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0020" &
        X"0020" &
        X"0020" &
        X"0020" &
        X"0020" &
        X"0020" &
        X"0020" &
        X"0420" &
        X"03c0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_K : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"05e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_L : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"03f0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_M : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03e0" &
        X"0410" &
        X"0490" &
        X"0490" &
        X"0490" &
        X"0490" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_N : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_O : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"03e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_P : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"05e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"05e0" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_Q : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0450" &
        X"0450" &
        X"0410" &
        X"03e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_R : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"05e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"05e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_S : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"03f0" &
        X"0400" &
        X"0400" &
        X"0400" &
        X"03e0" &
        X"0010" &
        X"0010" &
        X"0010" &
        X"07e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_T : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"07f0" &
        X"0000" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_U : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"03e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_V : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0420" &
        X"0440" &
        X"0480" &
        X"0500" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_W : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0490" &
        X"0490" &
        X"0490" &
        X"0410" &
        X"03e0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_X : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"03e0" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_Y : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"0410" &
        X"03e0" &
        X"0000" &
        X"0080" &
        X"0080" &
        X"0080" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    constant vga_bitmap_char_Z : vga_bitmap_t := (
        X"0000" &
        X"0000" &
        X"0000" &
        X"07e0" &
        X"0010" &
        X"0020" &
        X"0040" &
        X"0080" &
        X"0100" &
        X"0200" &
        X"0400" &
        X"03f0" &
        X"0000" &
        X"0000" &
        X"0000" &
        X"0000");

    type vga_letters_t is array (0 to 26) of vga_bitmap_t;
    constant vga_letters : vga_letters_t := (
        vga_bitmap_char_space, -- The @ character is used instead of space.
        vga_bitmap_char_A,
        vga_bitmap_char_B,
        vga_bitmap_char_C,
        vga_bitmap_char_D,
        vga_bitmap_char_E,
        vga_bitmap_char_F,
        vga_bitmap_char_G,
        vga_bitmap_char_H,
        vga_bitmap_char_I,
        vga_bitmap_char_J,
        vga_bitmap_char_K,
        vga_bitmap_char_L,
        vga_bitmap_char_M,
        vga_bitmap_char_N,
        vga_bitmap_char_O,
        vga_bitmap_char_P,
        vga_bitmap_char_Q,
        vga_bitmap_char_R,
        vga_bitmap_char_S,
        vga_bitmap_char_T,
        vga_bitmap_char_U,
        vga_bitmap_char_V,
        vga_bitmap_char_W,
        vga_bitmap_char_X,
        vga_bitmap_char_Y,
        vga_bitmap_char_Z);

    type vga_string_t is array (0 to 6) of character; -- Exactly 7 characters.
    type vga_names_t is array (0 to 10) of vga_string_t; -- One string for each row.

end package vga_bitmap_pkg;

