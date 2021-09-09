#!/usr/bin/env python

import itertools
import logging
import os
import random

import cocotb_test.simulator

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer
from cocotb.regression import TestFactory

from cocotbext.axi import AxiStreamBus, AxiStreamFrame, AxiStreamSource, AxiStreamSink
from cocotbext.uart import UartSink, UartSource


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
class TB(object):
    def __init__(self, dut, baud=1e6):
        self.dut = dut

        self.log = logging.getLogger("cocotb.tb")
        self.log.setLevel(logging.DEBUG)

        cocotb.fork(Clock(dut.iclk, 8, units="ns").start())

        self.axi_source = AxiStreamSource(AxiStreamBus.from_prefix(dut, "s_axis"), dut.iclk, dut.irst)
        self.axi_sink = AxiStreamSink(AxiStreamBus.from_prefix(dut, "m_axis"), dut.iclk, dut.irst)

        self.uart_sink = UartSink(dut.otx, baud=baud, bits=8, stop_bits=1)
        self.uart_source = UartSource(dut.irx, baud=baud, bits=8, stop_bits=1)

        dut.idivider.setimmediatevalue(int(1e9/baud/8))

    async def reset(self):
        self.dut.irst.setimmediatevalue(0)
        await RisingEdge(self.dut.iclk)
        await RisingEdge(self.dut.iclk)
        self.dut.irst <= 1
        await RisingEdge(self.dut.iclk)
        await RisingEdge(self.dut.iclk)
        self.dut.irst <= 0
        await RisingEdge(self.dut.iclk)
        await RisingEdge(self.dut.iclk)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
async def run_test_tx(dut, payload_lengths=None, payload_data=None):
    tb = TB(dut)
    await tb.reset()

    for test_data in [payload_data(x) for x in payload_lengths()]:
        await tb.axi_source.write(test_data)

        rx_data = bytearray()
        while len(rx_data) < int(3 * len(test_data)):
            rx_data.extend(await tb.uart_sink.read())

        tb.log.info("Readed data: %s", rx_data)
        rx_data = rx_data[2::3]
        tb.log.info("Parsed data: %s", rx_data)

        assert tb.uart_sink.empty()
        assert rx_data == test_data

        await Timer(1, 'us')

    await RisingEdge(dut.iclk)
    await RisingEdge(dut.iclk)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
async def run_test_rx(dut, payload_lengths=None, payload_data=None):
    tb = TB(dut)
    await tb.reset()

    for test_data in [payload_data(x) for x in payload_lengths()]:
        await tb.uart_source.write(test_data)

        rx_data = bytearray()
        while len(rx_data) < len(test_data):
            rx_data.extend(await tb.axi_sink.read())

        tb.log.info("Readed data: %s", rx_data)

        assert tb.axi_sink.empty()
        assert rx_data == test_data

        await Timer(1, 'us')

    await RisingEdge(dut.iclk)
    await RisingEdge(dut.iclk)


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def prbs31(state=0x7fffffff):
    while True:
        for i in range(8):
            if bool(state & 0x08000000) ^ bool(state & 0x40000000):
                state = ((state & 0x3fffffff) << 1) | 1
            else:
                state = (state & 0x3fffffff) << 1
        yield state & 0xff


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def prbs_payload(length):
    gen = prbs31()
    return bytearray([next(gen) for x in range(length)])


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def incrementing_payload(length):
    return bytearray(itertools.islice(itertools.cycle(range(256)), length))


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
def size_list():
    return list(range(1, 16)) + [32, 128, 1024]


#----------------------------------------------------------------------------------
#
#----------------------------------------------------------------------------------
# cocotb-test
if cocotb.SIM_NAME:
    for test in [run_test_rx, run_test_rx]:
        factory = TestFactory(test)
        factory.add_option("payload_lengths", [size_list])
        factory.add_option("payload_data", [incrementing_payload, prbs_payload])
        factory.generate_tests()
