# bcomp
8-bit computer

This is an attempt to mimic the 8-bit breadboard computer by Ben Eater:
https://www.youtube.com/playlist?list=PLowKtXNTBypGqImE405J2565dvjafglHU

This will implement everything in VHDL, taylored for the BASYS2 FPGA board
http://store.digilentinc.com/basys-2-spartan-3e-fpga-trainer-board-limited-time-see-basys-3/ , see picture below:
![alt text](https://github.com/MJoergen/bcomp/blob/master/img/Basys2.png "")

The FPGA board is based on a Spartan-3E FPGA chip from Xilinx.

Suggestions and contributions are welcome.

The overall block diagram of the computer is the picture below taken from video number 25 in Ben Eater's series:
![alt text](https://github.com/MJoergen/bcomp/blob/master/img/Block_diagram.png "")

Please see the [log file](https://github.com/MJoergen/bcomp/blob/master/log.md)
for additional implementation details and links to individual videos.

# Resources
Here are some links to additional learning resources:
* http://www.fpga4student.com/
* Datasheet for the BASYS2 board: https://reference.digilentinc.com/_media/basys2:basys2_rm.pdf

# Installation
This project assumes you're running on a Linux based system.
You need to install the Xilinx ISE Design Suite (version 14.7) from this link:
https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/design-tools.html
Don't bother with the cable drivers, they are not needed.
Instead, go to 

Please see the [Digilent's
website](http://store.digilentinc.com/digilent-adept-2-download-only/) to
download both the Runtime and the Utilities.

Alternatively, follow this guide: https://www.realdigital.org/document/44

