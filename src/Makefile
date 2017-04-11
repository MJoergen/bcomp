project    = bcomp
top_module = bcomp
vfiles     = bcomp.vhd # Top level
vfiles    += clock_logic.vhd
vfiles    += bistable_clock.vhd
vfiles    += monostable_clock.vhd
vfiles    += register_8bit.vhd
vfiles    += instruction_register.vhd
vfiles    += alu.vhd
vfiles    += memory_address_register.vhd
vfiles    += ram_module.vhd
vfiles    += ram74ls189.vhd 
vfiles    += ram74ls189_datatypes.vhd
vfiles    += program_counter.vhd 
vfiles    += display.vhd 
vfiles    += output_register.vhd 
vfiles    += control.vhd 
vfiles    += astable_clock.vhd 

#project    = program_counter
#top_module = program_counter
#vfiles     = program_counter.vhd # Top level

#project    = ram_module
#top_module = ram_module
#vfiles     = ram_module.vhd # Top level
#vfiles    += ram74ls189.vhd 
#vfiles    += ram74ls189_datatypes.vhd

#project    = ram
#top_module = ram
#vfiles     = ram.vhd # Top level
#vfiles    += ram74ls189.vhd 

#project    = memory_address_register
#top_module = memory_address_register
#vfiles     = memory_address_register.vhd # Top level

#project    = ram74ls189
#top_module = ram74ls189
#vfiles     = ram74ls189.vhd # Top level
#vfiles    += ram74ls189_datatypes.vhd

#project    = monostable_clock
#top_module = monostable_clock
#vfiles     = monostable_clock.vhd # Top level

#project    = astable_clock
#top_module = astable_clock
#vfiles     = astable_clock.vhd # Top level

#project    = bistable_clock
#top_module = bistable_clock
#vfiles     = bistable_clock.vhd # Top level

#project    = clock_logic
#top_module = clock_logic
#vfiles     = clock_logic.vhd # Top level
#vfiles    += bistable_clock.vhd
#vfiles    += monostable_clock.vhd
#vfiles    += astable_clock.vhd

#project    = instruction_register
#top_module = instruction_register
#vfiles     = instruction_register.vhd # Top level

#project    = register_8bit
#top_module = register_8bit
#vfiles     = register_8bit.vhd # Top level

#project    = alu
#top_module = alu
#vfiles     = alu.vhd # Top level

#project    = display
#top_module = display
#vfiles     = display.vhd # Top level

#project    = output_register
#top_module = output_register
#vfiles     = output_register.vhd # Top level

#project    = control
#top_module = control
#vfiles     = control.vhd # Top level

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
#stoptime   = --stop-time=4000us
stoptime   = --stop-time=4000us --assert-level=none

# Host PC application
app_source = $(project).cpp
app_libs   = -ldmgr -ldepp

include xilinx.mk

