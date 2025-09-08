

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

    // DUT inputs
    reg clk;
    reg rst_n;
    reg ena;
    reg [7:0] ui_in;
    reg [7:0] uio_in;

    // DUT outputs
    wire [7:0] uo_out;
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

    // Clock generation: 100 KHz → 10 us period = 10,000 ns
    initial clk = 0;
    always #5000 clk = ~clk; // Toggle every 5 us = 100 KHz

    // Stimulus
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);

        ena = 1;
        uio_in = 0;
        ui_in = 0;

        // Reset
        rst_n = 0;
        #20000;  // hold reset low for 20 us
        rst_n = 1;

        $display("Start testing...");

        // Test cases
        apply_test(8'b00010001, 1); // x0[0]=1, x1[0]=1 → output=1
        apply_test(8'b00100010, 1); // x0[1]=1, x1[1]=0 → output=1
        apply_test(8'b01000100, 1); // x0[2]=1, x1[2]=0 → output=1
        apply_test(8'b00000000, 0); // all zeros → output=0

        $display("All tests done.");
        $finish;
    end

    // Task for applying input and checking output
    task apply_test(input [7:0] vec, input expected);
        begin
            ui_in = vec;
            @(posedge clk);
            #1; // small delay after clock edge
            $display("ui_in=%b -> uo_out[0]=%b, expected=%b",
                     ui_in, uo_out[0], expected);
            if (uo_out[0] !== expected) begin
                $display("ERROR: mismatch detected!");
                $stop;
            end
        end
    endtask

       initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb);
    end


endmodule


    // Optional: waveform dump for GTKWave


