`timescale 1ns/1ps

module Mealy (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg out;
output reg [3-1:0] state;

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;
parameter S5 = 3'b101;

reg [3-1:0] next_state;

always @(*) begin
    case (state)
    S0: next_state = in ? S2 : S0;
    S1: next_state = in ? S4 : S0;
    S2: next_state = in ? S1 : S5;
    S3: next_state = in ? S2 : S3;
    S4: next_state = in ? S4 : S2;
    S5: next_state = in ? S4 : S3;
    default: next_state = 3'bxxx;
    endcase
end

always @(posedge clk) begin
    if (rst_n)
        state <= next_state;
    else
        state <= S0;
end

always @(*) begin
    case (state)
    S0: out = in;
    S1: out = 1'b1;
    S2: out = ~in;
    S3: out = ~in;
    S4: out = 1'b1;
    S5: out = 1'b0;
    default: out = 1'bx;
    endcase
end

endmodule
