`timescale 1ns/1ps

module ug_not(
    input i,
    output o
    );

Universal_Gate ug(1'b1, i, o);

endmodule

module ug_nor(
    input a,
    input b,
    output c
    );

wire not_a;
ug_not g0(a, not_a);
Universal_Gate g1(not_a, b, c);

endmodule

module ug_and(
    input a,
    input b,
    output c
    );

wire w0, w1;
ug_nor g0(a, a, w0), g1(b, b, w1), g2(w0, w1, c);

endmodule;

module ug_or(
    input a,
    input b,
    output c
    );

wire w;
ug_nor g0(a, b, w),
       g1(w, w, c);

endmodule

module ug_xor(
    input a,
    input b,
    output c
    );

wire not_a, not_b, w0, w1;
ug_not g0(a, not_a);
ug_not g1(b, not_b);
ug_and g2(a, not_b, w0);
ug_and g3(not_a, b, w1);
ug_or g4(w0, w1, c);

endmodule

module ug_xnor(
    input a,
    input b,
    output c
    );

wire not_a, not_b, w0, w1;
ug_not g0(a, not_a);
ug_not g1(b, not_b);
ug_and g2(a, b, w0);
ug_and g3(not_a, not_b, w1);
ug_or g4(w0, w1, c);

endmodule

module half_adder(
    input a,
    input b,
    output cout,
    output sum
    );

ug_and g0(a, b, cout);
ug_xor g1(a, b, sum);

endmodule

module adder(
    input a,
    input b,
    input cin,
    output cout,
    output sum
    );

wire w0, w1, w2;
half_adder h0(a, b, w0, w1), h1(cin, w1, w2, sum);
ug_or g0(w0, w2, cout);

endmodule

module adder4bit(
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum
    );

wire [3:1] c;
wire w;
adder a0(a[0], b[0], 1'b0, c[1], sum[0]),
      a1(a[1], b[1], c[1], c[2], sum[1]),
      a2(a[2], b[2], c[2], c[3], sum[2]),
      a3(a[3], b[3], c[3], w, sum[3]);

endmodule

module complementer4bit(
    input [3:0] in,
    output [3:0] out
    );

wire [3:0] w;
ug_not n [3:0] (in, w);
adder4bit a(w, 4'b0001, out);

endmodule

module suber4bit(
    input [3:0] a,
    input [3:0] b,
    output [3:0] dif
    );

wire [3:0] w;
complementer4bit c(b, w);
adder4bit ad(a, w, dif);

endmodule

module ari_r_shift(
    input [3:0] in,
    output [3:0] out
    );

wire [3:0] w;
ug_not a3(in[3], w[3]),
       a2(in[3], w[2]),
       a1(in[2], w[1]),
       a0(in[1], w[0]),
       b [3:0] (w, out);

endmodule

module cir_l_shift(
    input [3:0] in,
    output [3:0] out
    );

wire [3:0] w;
ug_not a3(in[2], w[3]),
       a2(in[1], w[2]),
       a1(in[0], w[1]),
       a0(in[3], w[0]),
       b [3:0] (w, out);

endmodule

module comparator(
    input [3:0] a,
    input [3:0] b,
    output [3:0] le,
    output [3:0] eq
    );

ug_not g0 [2:0] (3'b000, eq[3:1]);
wire [3:0] x;
ug_xnor g1 [3:0] (a, b, x);
wire x32, x321;
ug_and g2(x[3], x[2], x32),
       g3(x32, x[1], x321),
       g4(x321, x[0], eq[0]);

ug_not g5 [2:0] (3'b010, le[3:1]);
wire [3:0] not_a, not_a_and_b;
ug_not g6 [3:0] (a, not_a);
ug_and g7 [3:0] (not_a, b, not_a_and_b);
wire [4:0] w;
ug_and g8(x[3], not_a_and_b[2], w[0]),
       g9(x32, not_a_and_b[1], w[1]),
       g10(x321, not_a_and_b[0], w[2]);
ug_or g11(not_a_and_b[3], w[0], w[3]),
      g12(w[3], w[1], w[4]),
      g13(w[4], w[2], le[0]);

endmodule

module mux(
    input [3:0] a,
    input [3:0] b,
    input sel,
    output [3:0] f
);

wire not_sel;
ug_not g0(sel, not_sel);

wire [3:0] w0, w1, w2;
ug_and g1 [3:0] (a, {not_sel, not_sel, not_sel, not_sel}, w0);
ug_and g2 [3:0] (b, {sel, sel, sel, sel}, w1);
ug_or g3 [3:0] (w0, w1, f);

endmodule

module mux8(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input [3:0] in4,
    input [3:0] in5,
    input [3:0] in6,
    input [3:0] in7,
    input [2:0] sel,
    output [3:0] out
    );

wire [3:0] w0, w1, w2, w3, w4, w5;

mux a(in0, in1, sel[0], w0),
    b(in2, in3, sel[0], w1),
    c(in4, in5, sel[0], w2),
    d(in6, in7, sel[0], w3),
    e(w0, w1, sel[1], w4),
    f(w2, w3, sel[1], w5),
    g(w4, w5, sel[2], out);

endmodule

module Decode_And_Execute(rs, rt, sel, rd);
input [4-1:0] rs, rt;
input [3-1:0] sel;
output [4-1:0] rd;

wire [3:0] sub, add, bor, band, ars, cls, le, eq;
suber4bit Sub(rs, rt, sub);
adder4bit Add(rs, rt, add);
ug_or Bor [3:0] (rs, rt, bor);
ug_and Band [3:0] (rs, rt, band);
ari_r_shift ARS(rt, ars);
cir_l_shift CLS(rs, cls);
comparator cmp(rs, rt, le, eq);

mux8 m(sub, add, bor, band, ars, cls, le, eq, sel, rd );

endmodule
