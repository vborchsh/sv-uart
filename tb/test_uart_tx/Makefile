TOPLEVEL_LANG ?= verilog
SIM ?= icarus
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


ifeq ($(SIM), icarus)
	PLUSARGS += -fst

	COMPILE_ARGS += -g2012

	COMPILE_ARGS += -P $(TOPLEVEL).DATA_WIDTH=$(PARAM_DATA_WIDTH)
	COMPILE_ARGS += -P $(TOPLEVEL).STOP_BITS=$(PARAM_STOP_BITS)

	ifeq ($(WAVES), 1)
		VERILOG_SOURCES += iverilog_dump.v
		COMPILE_ARGS += -s iverilog_dump
	endif
else ifneq ($(filter $(SIM),modelsim questa),)
	COMPILE_ARGS += +initmem+0

	SIM_ARGS += -G DATA_WIDTH=$(PARAM_DATA_WIDTH)
	SIM_ARGS += -G STOP_BITS=$(PARAM_STOP_BITS)
endif


include $(shell cocotb-config --makefiles)/Makefile.sim


iverilog_dump.v:
	echo 'module iverilog_dump();' > $@
	echo 'initial begin' >> $@
	echo '    $$dumpfile("$(TOPLEVEL).fst");' >> $@
	echo '    $$dumpvars(0, $(TOPLEVEL));' >> $@
	echo 'end' >> $@
	echo 'endmodule' >> $@


clean::
	-rm -rf callgraph.svg
	-rm -rf __pycache__
	-rm -rf work
	-rm -rf modelsim.ini
	-rm -rf results.xml
	-rm -rf *.vstf
	-rm -rf *.wlf
	-rm -rf *.fst*
	-rm -rf transcript
	-rm -rf iverilog_dump.v