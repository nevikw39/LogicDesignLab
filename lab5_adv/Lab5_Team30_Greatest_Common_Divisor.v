`timescale 1ns/1ps

module Greatest_Common_Divisor (clk, rst_n, start, a, b, done, gcd);
input clk, rst_n;
input start;
input [15:0] a;
input [15:0] b;
output done;
output [15:0] gcd;

parameter WAIT = 2'b00;
parameter CAL = 2'b01;
parameter FINISH = 2'b10;

reg [1:0] state, next_state, next_cnt;
reg cnt;
reg [15:0] A, B, next_A, next_B;

always @(*)
    case (state)
        WAIT: next_state = start ? CAL : WAIT;
        CAL: next_state = next_A && next_B ? CAL : FINISH;
        FINISH: next_state = cnt ? FINISH : WAIT;
        default: next_state = WAIT;
    endcase

always @(*)
    next_cnt = cnt - 1;

always @(*)
    case (state)
        WAIT: begin
            next_A = a;
            next_B = b;
        end
        CAL:
            if (A > B) begin
                next_A = A - B;
                next_B = B;
            end
            else begin
                next_A = A;
                next_B = B - A;
            end
        FINISH: begin
            next_A = A;
            next_B = B;
        end
        default: begin
            next_A = 16'bx;
            next_B = 16'bx;
        end
    endcase
    

always @(posedge clk) begin
    state <= next_state;
    A <= next_A;
    B <= next_B;
    if (state == FINISH)
        cnt <= next_cnt;
    else
        cnt <= 1'b1;
end

assign done = state == FINISH;
assign gcd = done ? (A ? A : B) : 16'b0;

endmodule
