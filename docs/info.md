How it works

This project implements a miniature neural network in digital logic using Verilog.

Two 4-bit inputs (x0, x1) are provided via the input bus.

These inputs are processed by two neurons in the first layer. Each neuron multiplies the inputs by hard-coded weights, adds a bias, and applies a simple step activation function (output = 1 if the sum is above a threshold, otherwise 0).

The outputs of these two neurons are then fed into a third neuron in the second layer, which combines them into the final output.

The output neuron result is registered on the rising edge of the clock and is reset to 0 when reset is asserted low.

Only one output pin (io_out[0]) is used to display the neuron’s final activation. All other output pins are tied to 0.

This structure resembles a 2-2-1 perceptron network — two inputs, two hidden neurons, one output neuron. It demonstrates how neural-network-style computation can be mapped into hardware, even in the very limited resources of a single TinyTapeout tile.

How to test

Simulation

Provide a clock signal on io_in[0] and a reset signal on io_in[1] (active low).

Apply test values to x0 = io_in[5:2] and x1 = io_in[7:4].

Release reset (set io_in[1] = 1), then observe the final neuron output on io_out[0].

The output will update only on the rising edge of the clock.

Step-by-step testing

Use a slow clock (or manual clock pulse in simulation) to tick the circuit one cycle at a time.

Compare the output against the expected behavior of a neuron:

N1 and N2 produce intermediate binary outputs.

N3 combines these results into the final output.

Waveform analysis

Run a simulation with multiple clock cycles.

Verify that io_out[0] only changes state on clock edges and follows the step-activation logic.

External hardware

This project does not require external hardware when simulated. For FPGA or breadboard testing:

Clock source (can be a push button, oscillator, or FPGA clock pin).

Switches or DIP inputs to set the 8 input bits (clk, rst_n, x0[3:0], x1[3:0]).

1 LED connected to io_out[0] to visualize the neuron’s output.

Optional: additional LEDs on inputs to monitor applied values.
