# 2017-03-11:

Looking at the first video in Ben Eater's series we quickly discern the overall
layout.

## Inputs and Outputs
First thing to figure out are the Inputs and Outputs.

There are 3 seven-segment LED displays, and the BASYS2 board has four, so that
is fine.

There are a LOT of LED's on Ben Eaters computer, and the BASYS2 has only eight.
But on the other hand, the BASYS2 has a number of slide switches. They can be used to
control, what the LED's mean.

So that means, we'll be using the following I/O:
* seven-segment display.
* All eight LED's.
* Some of the slide switches to control the output LED's.
* Some of the slide switches to control the clock.
* 4 push buttons. One of them is probably for single-stepping the clock.

The BASYS2 has an additional VGA output. That may come in handy later, but
initially I won't use it.

The above is reflected in the file bcomp.ucf, which contains all the pin
assignments of the FPGA. This file is written based on the following images
from the BASYS2 datasheet:
!(https://github.com/MJoergen/bcomp/blob/master/pins.png)
!(https://github.com/MJoergen/bcomp/blob/master/pins2.png)

## Blocks
Next thing is to have an overall block structure. The first video again gives
all the answers.

Blocks needed:
* Clock
* Program Counter
* Memory Address Register
* RAM
* Instruction Register
* Control Unit
* A-register
* ALU
* B-register
* Output-register

So far, I've set up the build environment. Kind of like a "Hello World".
