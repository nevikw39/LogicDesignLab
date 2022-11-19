`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector (clk, rst_n, in, dec);
input clk, rst_n;
input in;
output dec;

localparam A0 = 4'h0, B1 = 4'h1, C2 = 4'h2, D3 = 4'h3, E4 = 4'h4, F5 = 4'h5, G6 = 4'h6, H7 = 4'h7, I8 = 4'h8, J9 = 4'h9;

reg [3:0] state, next_state;

always @(*)
    if (rst_n)
        case (state)
            A0: next_state = in ? B1 : A0;
            B1: next_state = in ? C2 : A0;
            C2: next_state = in ? D3 : A0;
            D3: next_state = in ? D3 : E4;
            E4: next_state = in ? B1 : F5;
            F5: next_state = in ? G6 : A0;
            G6: next_state = in ? I8 : H7;
            H7: next_state = in ? J9 : A0;
            I8: next_state = in ? D3 : A0;
            J9: next_state = in ? I8 : H7;
            default: next_state = A0;
        endcase
    else
        next_state = A0;

always @(posedge clk)
    state <= next_state;

assign dec = state == I8 ? in : 1'b0;

endmodule 