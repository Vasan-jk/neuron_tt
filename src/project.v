/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
/*
`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
*/
module neuron (
    input  wire [7:0] ui_in,    
    output wire [7:0] uo_out   
);
    // Pin mapping
    wire clk   = ui_in[0];
    wire rst_n = ui_in[1];
    wire [3:0] x0 = ui_in[5:2];
    wire [3:0] x1 = ui_in[7:4];

    // Intermediate outputs
    wire n1_out, n2_out, n3_out;

    // First layer: 2 neurons
    neuron #(.W0(2), .W1(1), .BIAS(1), .THRESH(6)) N1 (
        .clk(clk), .rst_n(rst_n), .x0(x0), .x1(x1), .y(n1_out)
    );

    neuron #(.W0(1), .W1(3), .BIAS(2), .THRESH(10)) N2 (
        .clk(clk), .rst_n(rst_n), .x0(x0), .x1(x1), .y(n2_out)
    );

    // Second layer: 1 neuron taking N1 and N2 as "inputs"
    neuron #(.W0(2), .W1(2), .BIAS(0), .THRESH(2)) N3 (
        .clk(clk), .rst_n(rst_n), 
        .x0({3'b000, n1_out}),   // extend 1-bit to 4-bit
        .x1({3'b000, n2_out}),   // extend 1-bit to 4-bit
        .y(n3_out)
    );

    // Output mapping: final neuron result on pin 0, rest 0
    assign uo_out = {7'b0000000, n3_out};

endmodule
