`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
/*
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  tt_um_example user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

endmodule
*/
`timescale 1ns/1ps

module tb;

    // Testbench signals
    reg  [7:0] io_in;
    wire [7:0] io_out;

    // DUT instantiation
    neuron dut (
        .io_in(io_in),
        .io_out(io_out)
    );

    // Clock generation
    initial begin
        io_in[0] = 0; // clock
        forever #5 io_in[0] = ~io_in[0]; // 100 MHz clock (10 ns period)
    end

    // Stimulus
    initial begin
        // Initialize inputs
        io_in[1] = 0;   // rst_n = 0 (reset active)
        io_in[5:2] = 0; // x0
        io_in[7:4] = 0; // x1

        // Hold reset for a few cycles
        #20;
        io_in[1] = 1; // release reset

        // Apply some test vectors
        @(posedge io_in[0]);
        io_in[5:2] = 4'd2; io_in[7:4] = 4'd1; // x0=2, x1=1
        @(posedge io_in[0]);
        @(posedge io_in[0]);

        io_in[5:2] = 4'd3; io_in[7:4] = 4'd2; // x0=3, x1=2
        @(posedge io_in[0]);
        @(posedge io_in[0]);

        io_in[5:2] = 4'd5; io_in[7:4] = 4'd1; // x0=5, x1=1
        @(posedge io_in[0]);
        @(posedge io_in[0]);

        io_in[5:2] = 4'd7; io_in[7:4] = 4'd3; // x0=7, x1=3
        @(posedge io_in[0]);
        @(posedge io_in[0]);

        // Finish simulation
        #20;
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0t | rst_n=%b | x0=%d | x1=%d | Output=%b",
                 $time, io_in[1], io_in[5:2], io_in[7:4], io_out[0]);
    end

    // Optional: waveform dump for GTKWave
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule

