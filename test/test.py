# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Example test vectors for your neuron design
    test_vectors = [
        (0b00010001, 1),  # x0[0]=1, x1[0]=1 => AND neuron fires
        (0b00100010, 1),  # x0[1]=1, x1[1]=0 => OR neuron fires
        (0b01000100, 1),  # x0[2]=1, x1[2]=0 => XOR neuron fires
        (0b00000000, 0),  # all zeros => output 0
    ]

    for vec, expected in test_vectors:
        dut.ui_in.value = vec
        await ClockCycles(dut.clk, 1)
        got = int(dut.uo_out.value & 1)
        dut._log.info(f"ui_in={vec:08b} -> got={got}, expected={expected}")
        assert got == expected, f"Mismatch: got {got}, expected {expected}"
