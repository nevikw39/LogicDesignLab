`timescale 1ns/1ps 

module Booth_Multiplier_4bit(clk, rst_n, start, a, b, p);
input clk;
input rst_n; 
input start;
input signed [3:0] a, b;
output reg signed [7:0] p;

wire [4:0] A = a;

localparam WAIT = 2'd0, CAL = 2'd1, FINISH = 2'd2;
reg [1:0] state, next_state, cnt, next_cnt;

// Combinatorial Circuit

reg signed [9:0] add, sub, prod, next_add, next_sub, next_prod;
always @(*)
    case (state)
        WAIT: begin
            next_add = {A, 5'd0};
            next_sub = {-A, 5'd0};
            next_prod = {1'd0, b, 1'd0};
            next_cnt = 2'd3;
        end
        CAL: begin
            next_add = add;
            next_sub = sub;
            case (prod[1:0])
                2'b01: next_prod = prod + add >>> 1;
                2'b10: next_prod = prod + sub >>> 1;
                default: next_prod = prod >>> 1;
            endcase
            next_cnt = cnt ? cnt - 2'b1 : 2'b1;
        end
        FINISH: begin
            next_add = add;
            next_sub = sub;
            next_prod = prod;
            next_cnt = cnt - 2'b1;
        end
        default: begin
            next_add = 9'bx;
            next_sub = 9'bx;
            next_prod = 9'bx;
            next_cnt = 2'bx;
        end
    endcase

// Next State Logic

always @(*)
    if (rst_n)
        case (state)
            WAIT:   next_state = start ? CAL : WAIT;
            CAL:    next_state = cnt ? CAL : FINISH;
            FINISH: next_state = cnt ? FINISH : WAIT;
        endcase
    else
        next_state = WAIT;

// Output Logic

always @(*)
    if (state == FINISH)
        p = prod[8:1];
    else
        p = 8'd0;
// MISC

always @(posedge clk) begin
    state <= next_state;
    add <= next_add;
    sub <= next_sub;
    prod <= next_prod;
    cnt <= next_cnt;
end

endmodule
