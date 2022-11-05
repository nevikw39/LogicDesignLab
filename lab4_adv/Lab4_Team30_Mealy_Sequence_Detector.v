`timescale 1ns/1ps

module Mealy_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output reg dec;

parameter A = 4'b0, B = A + 4'b1, C = B + 4'b1, D = C + 4'b1, E = D + 4'b1, F = E + 4'b1, G = F + 4'b1, H = G + 4'b1, I = H + 4'b1;

reg [3:0] state, next_state;
always @(*) begin
    case (state)
    A: next_state = in ? C : B;
    B: next_state = in ? D : H;
    C: next_state = in ? E : D;
    D: next_state = in ? F : I;
    E: next_state = in ? I : G;
    H: next_state = I;
    default: next_state = A;
    endcase
end
always @(posedge clk) begin
    if (rst_n)
        state <= next_state;
    else
        state <= A;
end

always @(*) begin
    case (state)
    F: dec = in;
    G: dec = ~in;
    default: dec = 1'b0;
    endcase
end

endmodule
