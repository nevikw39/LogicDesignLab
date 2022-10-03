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

module CLA_4bit(a, b, cin, co, s);
input [3:0] a, b;
input cin;
output co;
output [3:0] s;

wire [3:0] p, g, c;
wire[9:0] w;
wire[15:0] t;

nand_xor_1 d0(a[0], b[0], p[0]);
nand_xor_1 d1(a[1], b[1], p[1]);
nand_xor_1 d2(a[2], b[2], p[2]);
nand_xor_1 d3(a[3], b[3], p[3]);

nand_and_1 d4(a[0], b[0], g[0]);
nand_and_1 d5(a[1], b[1], g[1]);
nand_and_1 d6(a[2], b[2], g[2]);
nand_and_1 d7(a[3], b[3], g[3]);

nand_xor_1 d8(p[0], c[0], s[0]);
nand_xor_1 d9(p[1], c[1], s[1]);
nand_xor_1 d10(p[2], c[2], s[2]);
nand_xor_1 d11(p[3], c[3], s[3]);

nand_and_1 y0(cin, cin, c[0]);

nand_and_1 y4(p[0], c[0], w[0]);
nand_or_1 y5(g[0], w[0], c[1]);

nand_and_1 y6(p[1], g[0], w[1]);
nand_and_1 y7(p[1], p[0], t[0]);
nand_and_1 y8(t[0], c[0], w[2]);
nand_or_1 y9(g[1], w[1], t[1]);
nand_or_1 y10(t[1], w[2], c[2]);

nand_and_1 y11(p[2], g[1], w[3]);
nand_and_1 y12(p[2], p[1], t[2]);
nand_and_1 y13(t[2], g[0], w[4]);
nand_and_1 y19(p[2], p[1], t[6]);
nand_and_1 y14(t[6], p[0], t[3]);
nand_and_1 y15(t[3], c[0], w[5]);
nand_or_1 y16(g[2], w[3], t[4]);
nand_or_1 y17(t[4], w[4], t[5]);
nand_or_1 y18(t[5], w[5], c[3]);

nand_and_1 y20(p[3], g[2], w[6]);
nand_and_1 y21(p[2], g[1], t[7]);
nand_and_1 y22(t[7], p[3], w[7]);
nand_and_1 y23(p[2], p[1], t[8]);
nand_and_1 y24(t[8], p[3], t[9]);
nand_and_1 y25(t[9], g[0], w[8]);
nand_and_1 y26(p[2], p[1], t[10]);
nand_and_1 y27(t[10], p[0], t[11]);
nand_and_1 y28(t[11], p[3], t[12]);
nand_and_1 y29(t[12], c[0], w[9]);
nand_or_1 y30(g[3], w[6], t[13]);
nand_or_1 y31(t[13], w[7], t[14]);
nand_or_1 y32(t[14], w[8], t[15]);
nand_or_1 y33(t[15], w[9], co);

endmodule

module Carry_Look_Ahead_Adder_8bit(a, b, c0, s, c8);
input [8-1:0] a, b;
input c0;
output [8-1:0] s;
output c8;

wire c4;

CLA_4bit z1(a[3:0], b[3:0], c0, c4, s[3:0]);
CLA_4bit z2(a[7:4], b[7:4], c4, c8, s[7:4]);
endmodule
