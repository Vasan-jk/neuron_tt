

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

    reg  [7:0] io_in;   // DUT inputs
    wire [7:0] io_out;  // DUT outputs

    // DUT instance
    tt_um_neuron dut (
        .io_in(io_in),
        .io_out(io_out)
    );

    // Input mapping for readability
    wire clk   = io_in[0];
    wire rst_n = io_in[1];

    // Clock generation (100 MHz → 10 ns period)
    reg clk_reg;
    assign io_in[0] = clk_reg;
    always #5 clk_reg = ~clk_reg;

    // Testbench procedure
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Initialize signals
        clk_reg = 0;
        io_in   = 8'd0;

        // Reset low
        io_in[1] = 0;  // rst_n = 0
        #20;
        io_in[1] = 1;  // release reset

        // -------- Test 1 --------
        io_in[5:2] = 4'd2;  // x0
        io_in[7:4] = 4'd1;  // x1
        #20;
        $display("Test1: x0=%0d, x1=%0d -> n3_out=%b", io_in[5:2], io_in[7:4], io_out[0]);

        // -------- Test 2 --------
        io_in[5:2] = 4'd4;
        io_in[7:4] = 4'd3;
        #20;
        $display("Test2: x0=%0d, x1=%0d -> n3_out=%b", io_in[5:2], io_in[7:4], io_out[0]);

        // -------- Test 3 --------
        io_in[5:2] = 4'd0;
        io_in[7:4] = 4'd0;
        #20;
        $display("Test3: x0=%0d, x1=%0d -> n3_out=%b", io_in[5:2], io_in[7:4], io_out[0]);

        $finish;
    end
initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end

endmodule



    // Optional: waveform dump for GTKWave


