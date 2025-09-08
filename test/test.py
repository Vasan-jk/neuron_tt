import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Drive clk on ui_in[0]
    clock = Clock(dut.ui_in[0], 10, units="us")
    cocotb.start_soon(clock.start())

    # Enable always high
    dut.ena.value = 1
    dut.uio_in.value = 0

    # Reset using ui_in[1]
    dut.ui_in.value = 0  # ensures rst_n = 0
    await ClockCycles(dut.ui_in[0], 2)
    dut.ui_in[1].value = 1  # release reset

    # Test cases
    test_vectors = [
        (0b00010000, 1),  # x0[0]=1, x1[0]=1 => n0_out=1
        (0b00100000, 1),  # x0[1]=1, x1[1]=0 => n1_out=1
        (0b01000000, 1),  # x0[2]=1, x1[2]=0 => n2_out=1
        (0b00000000, 0),  # all zeros => output 0
    ]

    for vec, expected in test_vectors:
        # Keep clk (bit0) and rst_n (bit1) safe, load data into [7:2]
        dut.ui_in.value = (dut.ui_in.value & 0b00000011) | (vec & 0b11111100)
        await ClockCycles(dut.ui_in[0], 1)

        got = int(dut.uo_out.value & 1)
        dut._log.info(f"ui_in={dut.ui_in.value.integer:08b} -> got={got}, expected={expected}")
        assert got == expected, f"Mismatch: got {got}, expected {expected}"
