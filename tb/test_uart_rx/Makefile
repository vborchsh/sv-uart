TOPLEVEL_LANG ?= verilog
SIM ?= questa
WAVES ?= 0
GUI ?= 0

COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

PWD=$(shell pwd)

DUT              = sv_uart_rx
TOPLEVEL         = $(DUT)
MODULE           = test_$(DUT)
VERILOG_SOURCES += $(PWD)/../../rtl/$(DUT).sv

# module's parameters
export PARAM_DATA_WIDTH ?= 8
export PARAM_IN_PIPE ?= 5

COMPILE_ARGS += +initmem+0

SIM_ARGS += -G DATA_WIDTH=$(PARAM_DATA_WIDTH)
SIM_ARGS += -G IN_PIPE=$(PARAM_IN_PIPE)

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	-rm -rf callgraph.svg
	-rm -rf __pycache__
	-rm -rf work
	-rm -rf modelsim.ini
	-rm -rf results.xml
	-rm -rf *.vstf
	-rm -rf *.wlf
	-rm -rf transcript