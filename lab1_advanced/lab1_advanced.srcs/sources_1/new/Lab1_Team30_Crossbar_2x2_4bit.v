`timescale 1ns/1ps

module Crossbar_2x2_4bit(in1, in2, control, out1, out2);
input [4-1:0] in1, in2;
input control;
output [4-1:0] out1, out2;
wire not_con;
wire [4-1:0]  w1, w2, w3, w4;

not n1(not_con, control);

dmux dm1(in1, control, w1, w2);
dmux dm2(in2, not_con, w3, w4);

mux m1(w1, w3, control, out1);
mux m2(w2, w4, not_con, out2);

endmodule
