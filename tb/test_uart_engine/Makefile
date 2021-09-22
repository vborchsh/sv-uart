TOPLEVEL_LANG ?= verilog
SIM ?= modelsim
WAVES ?= 0
GUI ?= 0

COCOTB_HDL_TIMEUNIT = 1ns
COCOTB_HDL_TIMEPRECISION = 1ps

PWD=$(shell pwd)

DUT              = sv_uart_engine
TOPLEVEL         = $(DUT)
MODULE           = test_$(DUT)
VERILOG_SOURCES += $(PWD)/../../rtl/$(DUT).sv
VERILOG_SOURCES += $(PWD)/../../rtl/sv_uart_rx.sv
VERILOG_SOURCES += $(PWD)/../../rtl/sv_uart_tx.sv

# module's parameters
export PARAM_DATA_WIDTH ?= 24

COMPILE_ARGS += +initmem+0

SIM_ARGS += -g DATA_WIDTH=$(PARAM_DATA_WIDTH)

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