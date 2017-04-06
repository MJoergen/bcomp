#project    = bcomp
#top_module = bcomp
#vfiles     = bcomp.vhd # Top level
#vfiles    += clock_logic.vhd # Top level
#vfiles    += bistable_clock.vhd
#vfiles    += monostable_clock.vhd
#vfiles    += register_8bit.vhd
#vfiles    += alu.vhd # Top level

project    = ram
top_module = ram
vfiles     = ram.vhd # Top level

#project    = ram74ls189
#top_module = ram74ls189
#vfiles     = ram74ls189.vhd # Top level

#project    = monostable_clock
#top_module = monostable_clock
#vfiles     = monostable_clock.vhd # Top level

#project    = bistable_clock
#top_module = bistable_clock
#vfiles     = bistable_clock.vhd # Top level

#project    = clock_logic
#top_module = clock_logic
#vfiles     = clock_logic.vhd # Top level
#vfiles    += bistable_clock.vhd
#vfiles    += monostable_clock.vhd

#project    = register_8bit
#top_module = register_8bit
#vfiles     = register_8bit.vhd # Top level

#project    = alu
#top_module = alu
#vfiles     = alu.vhd # Top level

# Synthesis
vendor     = xilinx
family     = spartan3e
part       = xc3s250e-5-cp132
board      = Basys2
index      = 0
#part       = xc7a35t-1-cpg236
#board      = Basys3

# Simulation
testbench  = $(top_module)_tb
tb_sources = $(testbench).vhd
wave       = $(testbench).ghw
wavesave   = $(testbench).gtkw
unisim_lib = unisim-obj93.cf
stoptime   = --stop-time=4000us

# Host PC application
app_source = $(project).cpp
app_libs   = -ldmgr -ldepp

include xilinx.mk

