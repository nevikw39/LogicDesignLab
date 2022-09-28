`timescale 1ns/1ps

module Crossbar_4x4_4bit(in1, in2, in3, in4, out1, out2, out3, out4, control);
input [4-1:0] in1, in2, in3, in4;
input [5-1:0] control;
output [4-1:0] out1, out2, out3, out4;

wire [3:0] w0, w1, w2, w3, w4, w5;
Crossbar_2x2_4bit a(in1, in2, control[0], w0, w1),
                  b(in3, in4, control[3], w2, w3),
                  c(w1, w2, control[2], w4, w5),
                  d(w0, w4, control[1], out1, out2),
                  e(w5, w3, control[4], out3, out4);

endmodule
