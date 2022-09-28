`timescale 1ns/1ps
module dmux(
    input [3:0] in,
    input sel,
    output [3:0] a,
    output [3:0] b
    );

wire not_sel;
not(not_sel, sel);

and a1[3:0](a, in, {not_sel, not_sel, not_sel, not_sel});
and a2[3:0](b, in, {sel, sel, sel, sel});

endmodule

module mux(
    input [3:0] a,
    input [3:0] b,
    input sel,
    output [3:0] f
);

wire not_sel;
not(not_sel, sel);

wire [3:0] w0, w1, w2;

and(w0[0], a[0], not_sel);
and(w0[1], a[1], not_sel);
and(w0[2], a[2], not_sel);
and(w0[3], a[3], not_sel);

and(w1[0], b[0], sel);
and(w1[1], b[1], sel);
and(w1[2], b[2], sel);
and(w1[3], b[3], sel);

or o[3:0](f, w0, w1);

endmodule

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
