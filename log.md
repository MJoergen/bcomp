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
![alt text](https://github.com/MJoergen/bcomp/blob/master/img/pins.png "")
![alt text](https://github.com/MJoergen/bcomp/blob/master/img/pins2.png "")

## Blocks
Next thing is to have an overall block structure. The first video again gives
all the answers.

Blocks needed:
* Clock  -- DONE
* A-register   -- DONE
* B-register   -- DONE
* Instruction Register  -- DONE
* ALU -- DONE
* Memory Address Register -- DONE
* RAM -- DONE
* Program Counter
* Output-register
* Control Unit

So far, I've set up the build environment. Kind of like a "Hello World".

# 2017-04-05

The videos 5 through 8 deal with the clock circuit. Now since the BASYS2 board
has an onboard crystal oscillator, our implementation will be somewhat different
than in the videos. Specifically, the "astable 555 timer" in video 5 is not needed
at all. However, videos 6, 7, and 8 have been implemented as faithfully as possible:
* Video 6 - monostable_clock.vhd
* Video 7 - bistable_clock.vhd
* Video 8 - clock_logic.vhd

Note that each of these blocks have a separate test bench (name *_tb.vhd). These act
as unit tests for each block.

Next, videos 9 through 13 deal with the internal data bus and the three registers.
Since the three registers are identical, only one block is needed:
* Video 12 - register_8bit.vhd

Note that at this I have assembled the blocks made so far into the top level
file bcomp.vhd, and made an accompanying test bench bcomp_tb.vhd. This test bench
works similarly to the video number 13.

One caveat so far is that in the video, the instruction register only connects the 
four least significant bits to the data bus. At this moment, it's not clear why,
so I'm just connecting all eight bits.

# 2017-04-07

Video number 25 starts of with a good high level diagram of the computer.

It seems that the number of I/O pins necessary to control the computer is
way more than I originally estimated. At least if I want to be
able to program the computer using slide switches and push buttons.
This would suggest we move to a Basys3 board with double the number of slide
switches and LED's. But so far, I'll continue with the Basys2 board I have.

# 2017-04-08

I just realized the Basys2 board has 16 extra I/O pins in the form of
PMOD's. So it is not necessary after all to use the Basys3 board.

Slowly, the project is beginning to resemble a computer. Like an embryo growing into 
a fetus.

