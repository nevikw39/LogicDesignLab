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

module Dmux_1x4_4bit(in, a, b, c, d, sel);
input [4-1:0] in;
input [2-1:0] sel;
output [4-1:0] a, b, c, d;

wire [3:0] w1, w2;

dmux d1(in, sel[1], w1, w2), d2(w1, sel[0], a, b), d3(w2, sel[0], c, d);
endmodule
