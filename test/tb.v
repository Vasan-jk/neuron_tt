

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

    // DUT signals
    reg        clk;
    reg        rst_n;
    reg        ena;
    reg  [7:0] ui_in;
    wire [7:0] uo_out;
    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate the DUT
    tt_um_neuron dut (
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena),
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe)
    );

    // Clock generation (100 MHz -> 10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        // Initialize inputs
        rst_n   = 0;
        ena     = 1;
        ui_in   = 8'd0;
        uio_in  = 8'd0;

        // Apply reset
        #20;
        rst_n = 1;

        // -------- Test 1 --------
        ui_in = 8'b00010001; // x0=1, x1=1
        #10;
        $display("Test1: ui_in=%b -> uo_out[0]=%b", ui_in, uo_out[0]);
        if (uo_out[0] !== 1'b1) $fatal("FAIL Test1");

        // -------- Test 2 --------
        ui_in = 8'b00100010; // x0=2, x1=2
        #10;
        $display("Test2: ui_in=%b -> uo_out[0]=%b", ui_in, uo_out[0]);
        if (uo_out[0] !== 1'b1) $fatal("FAIL Test2");

        // -------- Test 3 --------
        ui_in = 8'b01000100; // x0=4, x1=4
        #10;
        $display("Test3: ui_in=%b -> uo_out[0]=%b", ui_in, uo_out[0]);
        if (uo_out[0] !== 1'b1) $fatal("FAIL Test3");

        // -------- Test 4 --------
        ui_in = 8'b00000000; // x0=0, x1=0
        #10;
        $display("Test4: ui_in=%b -> uo_out[0]=%b", ui_in, uo_out[0]);
        if (uo_out[0] !== 1'b0) $fatal("FAIL Test4");

        $display("All tests passed!");
        $finish;
    end
initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end
endmodule




    // Optional: waveform dump for GTKWave


