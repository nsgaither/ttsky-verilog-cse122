/*
 * Copyright (c) 2024 Nicholas Gaither
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs - uo_out[6:0] = seg {g,f,e,d,c,b,a}
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock (1Hz)
    input  wire       rst_n     // reset_n - low to reset (active-low)
);
    localparam H = 7'h76;
    localparam E = 7'h79;
    localparam L = 7'h38;
    localparam O = 7'h3F;

    reg [2:0] letter;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)    letter <= 3'd0;
        else          letter <= (letter == 3'd4) ? 3'd0 : letter + 1;
    end

    always @(*) begin
        case (letter)
            3'd0: seg = ~H;
            3'd1: seg = ~E;
            3'd2: seg = ~L;
            3'd3: seg = ~L;
            3'd4: seg = ~O;
            default: seg = 7'hFF;
        endcase
    end
    
  assign uo_out  = {1'b0, seg};  // MSB always 0, seg on bits 6-0
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
