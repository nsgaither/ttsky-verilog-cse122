module hello_display (
    input  logic       clk,     // Needs 1HZ input ( each letter is shown for 1 second)
    input  logic       rst_n,
    output logic [6:0] seg      // Active-low segment output {g,f,e,d,c,b,a}
);

    localparam H = 7'h76; // 0b0111_0110
    localparam E = 7'h79; // 0b0111_1001
    localparam L = 7'h38; // 0b0011_1000
    localparam O = 7'h3F; // 0b0011_1111

    logic [2:0]  letter;

    always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) letter  <= '0;
      else letter <= (letter == 3'd4) ? '0 : letter + 1;
    end

    always_comb begin
        case (letter)
            3'd0: seg = ~H; // for active-high remove ~
            3'd1: seg = ~E;
            3'd2: seg = ~L;
            3'd3: seg = ~L;
            3'd4: seg = ~O;
            default: seg = 7'hFF; // all off
        endcase
    end

endmodule
