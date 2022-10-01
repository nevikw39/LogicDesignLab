`timescale 1ns/1ps

module nand_and(
    input a,
    input b,
    output o
    );

wire w;
nand(w, a, b);
nand(o, w, w);

endmodule

module nand_or(
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

module nand_xor(
    input a,
    input b,
    output o
    );

wire not_a, not_b, w0, w1;
nand_not g0(a, not_a);
nand_not g1(b, not_b);
nand_and g2(a, not_b, w0);
nand_and g3(b, not_a, w1);
nand_or g4(w0, w1, o);

endmodule

module half_adder(
    input a,
    input b,
    output cout,
    output sum
    );

nand_and g0(a, b, cout);
nand_xor g1(a, b, sum);

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
nand_or g0(w0, w2, cout);

endmodule

module Adder_4bit(
    input [3:0] a,
    input [3:0] b,
    output cout,
    output [3:0] sum
    );

wire [3:1] c;
adder a0(a[0], b[0], 1'b0, c[1], sum[0]),
           a1(a[1], b[1], c[1], c[2], sum[1]),
           a2(a[2], b[2], c[2], c[3], sum[2]),
           a3(a[3], b[3], c[3], cout, sum[3]);

endmodule

module Multiplier_4bit(a, b, p);
input [4-1:0] a, b;
output [8-1:0] p;

wire [22:0] w;
nand_and g0 [3:0] (a, {b[0], b[0], b[0], b[0]}, {w[2:0], p[0]}),
         g1 [3:0] (a, {b[1], b[1], b[1], b[1]}, w[6:3]),
         g2 [3:0] (a, {b[2], b[2], b[2], b[2]}, w[14:11]),
         g3 [3:0] (a, {b[3], b[3], b[3], b[3]}, w[22:19]);

Adder_4bit a0(w[6:3], {1'b0, w[2:0]}, w[10], {w[9:7], p[1]}),
           a1(w[14:11], w[10:7], w[18], {w[17:15], p[2]}),
           a2(w[22:19], w[18:15], p[7], p[6:3]);

endmodule
