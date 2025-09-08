

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

    // Simulated inputs/outputs to the DUT
    reg  [7:0] io_in;
    wire [7:0] io_out;

    // Instantiate the DUT
    tt_um_neuron dut (
        .io_in(io_in),
        .io_out(io_out)
    );

    // Internal registers for individual control
    reg clk;
    reg rst_n;
    reg [3:0] x0, x1;

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 100 MHz

    // Assign all io_in bits in one place
    always @(*) begin
        io_in[0] = clk;
        io_in[1] = rst_n;
        io_in[5:2] = x0;
        io_in[7:4] = x1;
    end

    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Reset sequence
        rst_n = 0;
        x0 = 4'd0;
        x1 = 4'd0;
        #20;
        rst_n = 1;

        // -------------------------
        // Test 1: x0=2, x1=1
        // -------------------------
        x0 = 4'd2;
        x1 = 4'd1;
        #20;
        $display("Test 1: x0=%d, x1=%d => output=%b", x0, x1, io_out[0]);

        // -------------------------
        // Test 2: x0=4, x1=3
        // -------------------------
        x0 = 4'd4;
        x1 = 4'd3;
        #20;
        $display("Test 2: x0=%d, x1=%d => output=%b", x0, x1, io_out[0]);

        // -------------------------
        // Test 3: x0=0, x1=0
        // -------------------------
        x0 = 4'd0;
        x1 = 4'd0;
        #20;
        $display("Test 3: x0=%d, x1=%d => output=%b", x0, x1, io_out[0]);

        $display("Simulation completed.");
        $finish;
    end
initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end
endmodule




    // Optional: waveform dump for GTKWave


