`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
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
  wire [6:0] seg = uo_out[6:0];
   
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  tt_um_example project (
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

localparam SEG_H = ~7'h76; // H
localparam SEG_E = ~7'h79; // E
localparam SEG_L = ~7'h38; // L
localparam SEG_O = ~7'h3F; // O
localparam CLK_PERIOD = 10; // 10ns test clock (makes testing simpler, functionally should be the exact same just faster)

integer failed = 0, passed = 0;

task check_seg;
    input [6:0] expected;
    input [63:0] letter_index;
    input [8*8-1:0] letter_name;
    begin
      if (seg !== expected) begin
        $display("FAIL [letter %0d '%s']: expected seg=0x%02X, got seg=0x%02X", letter_index, letter_name, expected, seg);
        failed = failed + 1;
      end else begin
        $display("PASS [letter %0d '%s']: seg=0x%02X", letter_index, letter_name, seg);
        passed = passed + 1;
      end
    end
endtask

initial begin // MAIN TESTBENCH
    // Initialise inputs
    clk    = 0;
    rst_n  = 0;
    ena    = 1;
    ui_in  = 8'h00;
    uio_in = 8'h00;

    // Apply reset for 2 cycles
    repeat(2) @(posedge clk);
    #1;

    // Release reset
    rst_n = 1;
    #1;

   
    // Check each letter in sequence: H -> E -> L -> L -> O
    // Each posedge advances the letter, so we sample after #1

    // Letter 0: h
    check_seg(SEG_H, 0, "H");

    @(posedge clk); #1;
    // Letter 1: E
    check_seg(SEG_E, 1, "E");

    @(posedge clk); #1;
    // Letter 2: L
    check_seg(SEG_L, 2, "L");

    @(posedge clk); #1;
    // Letter 3: L
    check_seg(SEG_L, 3, "L");

    @(posedge clk); #1;
    // Letter 4: o
    check_seg(SEG_O, 4, "O");

    // Check wrap-around: after 'O' -> 'H'
    @(posedge clk); #1;
    check_seg(SEG_H, 0, "H (wrap)");

    // Summary
    $display("----------------------------------");
    $display("Results: %0d passed, %0d failed", passed, failed);
    if (failed == 0)
      $display("ALL TESTS PASSED");
    else
      $display("SOME TESTS FAILED");
    $display("----------------------------------");

    $finish;
  end

  // Clock generation
  always #(CLK_PERIOD/2) clk = ~clk;

endmodule
