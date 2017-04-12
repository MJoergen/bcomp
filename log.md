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
* Clock
* A-register
* B-register
* Instruction Register
* ALU
* Memory Address Register
* RAM
* Program Counter
* Output-register
* Control Unit

So far, I've set up the build environment. Kind of like a "Hello World".

# 2017-04-05

The videos 5 through 8 deal with the clock circuit. Now since the BASYS2 board
has an onboard crystal oscillator, our implementation will be somewhat different
than in the videos. Specifically, the "astable 555 timer" in video 5 is not needed
at all, because that is precisely what the external crystal does. However,
videos 6, 7, and 8 have been implemented as faithfully as possible:
* Video 6 - monostable_clock.vhd
* Video 7 - bistable_clock.vhd
* Video 8 - clock_logic.vhd

Note that each of these blocks have a separate test bench (name *_tb.vhd). These act
as unit tests for each block.

Next, videos 9 through 13 deal with the internal data bus and the three registers.
Since the three registers are identical, only one block is needed:
* Video 12 - register_8bit.vhd

Note that at this time I have assembled the blocks made so far into the top level
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

# 2017-04-10

I've gone ahead and finished the design, before the next video from Ben Eater.

The following picture shows output from the simulation.
![alt text](https://github.com/MJoergen/bcomp/blob/master/img/Simulation.png "")
At the bottom we see the control logic.
The first cycle sets CO and MI high. That copies the program counter to the
memory address register. The value of the program counter can currently be seen
on the data bus (value 0x0B).

Second cycle sets RO and II high. That copies the memory contents to the
instruction register.  The instruction op code can currently be seen on the
data bus (value 0x80).

Third cycle, it sets CE high, which increments the program counter. 

Fourth cycle, the program counter has been incremented from 0x0B to 0x0C.
Control module sets IO and JC high.  That performs a conditional jump, based on
whether the register 'carry_reg' is high. In this case that is true, so the
jump is performed. The destination address is currently seen on the data bus
(value 0x00).

Cycles five through eight are empty.

After that the next instruction fetch proceeds, by once again setting CO and MI high.

## Synthesis

The current design uses 19% of the available logic in the FPGA and can run at up to 141 MHz.

## TODO

* Make a more extensive test of the CPU and all it's instructions and capabilities.
* Increase memory, so larger programs can be stored.
* Add more instructions.


# 2017-04-11

Added the possibility to preload the program, so it's not necessary to program the computer
using the PMOD's.

But more importantly, when I tested the computer on the physical board, sometimes reads
from the RAM would fail. I suspect this is because the RAM is implemented using latches in
the FPGA, and that is generally something to be avoided. So I've supplied a clock signal
to the RAM module and made the writes synchronuous. This avoids latches, and now everything works
charmingly!

# 2017-04-12

I'm about to wrap up this project. I've added VGA output, so you can view all the LED's simultaneously
on the screen. I intend to start a new project, building a modular computer with an architecture
more simular to regular 8-bit CPU's (e.g. Z80 and/or 6502).

Phew. A major re-organization, collecting all the CPU-related stuff into a single module. This 
hierarchical division is very helpful and closely resembles normal CPU architecture.

Currently, the design now uses 22% of the available logic, and can run up to 140 MHz. The total
build time on my (slow) desktop PC is around 2 minutes.
So the VGA display has only used about 3% of the available logic.
