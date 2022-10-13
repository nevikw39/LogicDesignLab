`timescale 1ns/1ps

module Clock_Divider (clk, rst_n, sel, clk1_2, clk1_4, clk1_8, clk1_3, dclk);
input clk, rst_n;
input [2-1:0] sel;
output reg clk1_2;
output reg clk1_4;
output reg clk1_8;
output reg clk1_3;
output reg dclk;

reg two = 0;
reg[1:0] four = 0, three = 0;
reg[2:0] eight = 0;

always @(posedge clk) begin
    two <= two + 1;
    four <= four + 1;
    eight <= eight + 1;
    three <= three != 2 ? three + 1 : 0;
    if (rst_n) begin
        clk1_2 <= two == 1;
        clk1_4 <= four == 1;
        clk1_8 <= eight == 1;
        clk1_3 <= three == 1;
    end
    else begin
        clk1_2 <= 1;
        clk1_4 <= 1;
        clk1_8 <= 1;
        clk1_3 <= 1;
    end
end

always @(*) begin
    case (sel)
        0: dclk = clk1_3;
        1: dclk = clk1_2;
        2: dclk = clk1_4;
        3: dclk = clk1_8;
    endcase
end

endmodule
