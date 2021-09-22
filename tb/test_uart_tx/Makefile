TOPLEVEL_LANG ?= verilog
SIM ?= questa
WAVES ?= 0
GUI ?= 0

COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

PWD=$(shell pwd)

DUT      			   = sv_uart_tx
TOPLEVEL 			   = $(DUT)
MODULE   			   = test_$(DUT)
VERILOG_SOURCES += $(PWD)/../../rtl/$(DUT).sv

# module's parameters
export PARAM_DATA_WIDTH ?= 8
export PARAM_STOP_BITS ?= 1

COMPILE_ARGS += +initmem+0

SIM_ARGS += -G DATA_WIDTH=$(PARAM_DATA_WIDTH)
SIM_ARGS += -G STOP_BITS=$(PARAM_STOP_BITS)

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