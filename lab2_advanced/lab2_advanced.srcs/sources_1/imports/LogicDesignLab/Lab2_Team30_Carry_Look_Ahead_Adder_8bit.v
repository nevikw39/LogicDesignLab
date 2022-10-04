`timescale 1ns/1ps
module nand_and_1(
    input a,
    input b,
    output o
    );

wire w;
nand(w, a, b);
nand(o, w, w);

endmodule

module nand_or_1(
    input a,
    input b,
    output o
    );

wire w0, w1;
nand(w0, a, a);
nand(w1, b, b);
nand(o, w0, w1);

endmodule

module nand_not(
    input i,
    output o
    );

nand(o, i, i);

endmodule

module nand_xor_1(
    input a,
    input b,
    output o
    );

wire not_a, not_b, w0, w1;
nand_not g0(a, not_a);
nand_not g1(b, not_b);
nand_and_1 g2(a, not_b, w0);
nand_and_1 g3(b, not_a, w1);
nand_or_1 g4(w0, w1, o);

endmodule

module getpgs(a, b, cin, p, g, s);
input a, b, cin;
output p, g, s;
wire w;

nand_xor_1 r0(a, b, w);
nand_xor_1 r1(w, cin, s);

nand_and_1 r2(a, b, g);
nand_or_1 r3(a, b, p);

endmodule

module CLA_4bit(p, g, cin, cout, pg, gg);
input [3:0] p, g;
input cin;
output [2:0] cout;
output pg, gg;

wire[8:0] w;
wire[6:0] t;

nand_and_1 y4(p[0], cin, w[0]);
nand_or_1 y5(g[0], w[0], cout[0]);

nand_and_1 y6(p[1], w[0], w[1]);
nand_and_1 y7(p[1], g[0], w[2]);
nand_or_1 y8(w[1], w[2], t[0]);
nand_or_1 y9(g[1], t[0], cout[1]);

nand_and_1 y10(p[2], w[1], w[3]);
nand_and_1 y11(p[2], w[2], w[4]);
nand_and_1 y12(p[2], g[1], w[5]);
nand_or_1 y13(w[3], w[4], t[1]);
nand_or_1 y14(w[5], t[1], t[2]);
nand_or_1 y15(t[2], g[2], cout[2]);

nand_and_1 y16(p[3], w[4], w[6]);
nand_and_1 y17(p[3], w[5], w[7]);
nand_and_1 y18(g[2],p[3], w[8]);
nand_or_1 y19(w[6], w[7], t[3]);
nand_or_1 y20(w[8], t[3], t[4]);
nand_or_1 y21(g[3], t[4], gg);

nand_and_1 y22(p[3], p[2], t[5]);
nand_and_1 y23(p[1], t[5], t[6]);
nand_and_1 y24(p[0], t[6], pg);

endmodule

module CLA_2bit (pg, gg, c0, c4, c8);
input [1:0] pg, gg;
input c0;
output c4, c8;

wire [2:0] w;

nand_and_1 a1(pg[0], c0, w[0]);
nand_or_1 a2(w[0], gg[0], c4);

nand_or_1 a3(w[0], gg[0], w[1]);
nand_and_1 a4(pg[1], w[1], w[2]);
nand_or_1 a5(w[2], gg[1], c8);

endmodule

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [8-1:0] a, b;
input c0;
output [8-1:0] s;
output c8;

wire [7:0] p, g;
wire [7:1] cout;
wire [1:0] pg, gg;

getpgs g0(a[0], b[0], c0, p[0], g[0], s[0]);
getpgs g1(a[1], b[1], cout[1], p[1], g[1], s[1]);
getpgs g2(a[2], b[2], cout[2], p[2], g[2], s[2]);
getpgs g3(a[3], b[3], cout[3], p[3], g[3], s[3]);
getpgs g4(a[4], b[4], cout[4], p[4], g[4], s[4]);
getpgs g5(a[5], b[5], cout[5], p[5], g[5], s[5]);
getpgs g6(a[6], b[6], cout[6], p[6], g[6], s[6]);
getpgs g7(a[7], b[7], cout[7], p[7], g[7], s[7]);

CLA_4bit c1(p[3:0], g[3:0], c0, cout[3:1], pg[0], gg[0]);
CLA_4bit c2(p[7:4], g[7:4], cout[4], cout[7:5], pg[1], gg[1]);
CLA_2bit c3(pg, gg, c0, cout[4], c8);
endmodule
