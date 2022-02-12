# SystemVerilog UART-AXIs converter

[![pipeline status](https://gitlab.com/vborshch/sv-uart/badges/master/pipeline.svg)](https://gitlab.com/vborshch/sv-uart/-/commits/master)

## Introduction

This is a simple UART-AXI Stream converter, written in SystemVerilog with cocotb testbenches. There are three modules: rx part, tx part and engine which connect together other modules.

The RX module has a built-in 2FF metastability protection.

There is 16-bit clock divider value `idivider` for baudrate generation.

## Dependencies

- Python 3.8
- Icarus Verilog 12.0 *or* ModelSim/QuestaSim
- cocotb 1.6.1
- SystemVerilog IEEE 1800-2012

> Feel free to use any simulator with SV support

## Parameters

`DATA_WIDTH` - *_axis_tdata bitwidth. Must be divided by 8

`RX_PIPE` - input pipeline in RX datapath, means debouncing.
