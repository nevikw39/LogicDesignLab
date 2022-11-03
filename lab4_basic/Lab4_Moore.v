`timescale 1ns/1ps

module Moore (clk, rst_n, in, out, state);
input clk, rst_n;
input in;
output reg [2-1:0] out;
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
    S0:
        if (in)
            next_state = S2;
        else
            next_state = S1;
    S1:
        if (in)
            next_state = S5;
        else
            next_state = S4;
    S2:
        if (in)
            next_state = S3;
        else
            next_state = S1;
    S3:
        if (in)
            next_state = S0;
        else
            next_state = S1;
    S4:
        if (in)
            next_state = S5;
        else
            next_state = S4;
    S5:
        if (in)
            next_state = S0;
        else
            next_state = S3;
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
    S0: out = 2'b11;
    S1: out = 2'b01;
    S2: out = 2'b11;
    S3: out = 2'b10;
    S4: out = 2'b10;
    S5: out = 2'b00;
    default: out = 2'bxx;
    endcase
end

endmodule
