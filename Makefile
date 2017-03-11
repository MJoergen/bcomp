project    = bcomp
top_module = bcomp
vfiles     = bcomp.vhd # Top level

# Synthesis
vendor     = xilinx
family     = spartan3e
part       = xc3s250e-5-cp132
board      = Basys2
index      = 0

# Simulation
testbench  = $(top_module)_tb
#testbench  = $(project)_tb
tb_sources = $(testbench).vhd
wave       = $(testbench).ghw
wavesave   = $(testbench).gtkw
unisim_lib = unisim-obj93.cf
stoptime   = --stop-time=1000us

# Host PC application
app_source = $(project).cpp
app_libs   = -ldmgr -ldepp

include xilinx.mk

