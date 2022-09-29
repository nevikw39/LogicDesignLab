`timescale 1ns/1ps

module mux(
    input a,
    input b,
    input sel,
    output f
);

wire not_sel;
not(not_sel, sel);

wire w0, w1, w2;
and(w0, a, not_sel);
and(w1, b, sel);
or(f, w0, w1);

endmodule

module mux8(
    input [7:0] in,
    input [2:0] sel,
    output out
    );

wire [5:0] w;

mux a(in[0], in[1], sel[0], w[0]),
    b(in[2], in[3], sel[0], w[1]),
    c(in[4], in[5], sel[0], w[2]),
    d(in[6], in[7], sel[0], w[3]),
    e(w[0], w[1], sel[1], w[4]),
    f(w[2], w[3], sel[1], w[5]),
    g(w[4], w[5], sel[2], out);

endmodule

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

module nand_nor(
    input a,
    input b,
    output o
    );

wire w;
nand_or g0(a, b, w);
nand_not g1(w, o);

endmodule

module nand_xnor(
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

module nand_xor(
    input a,
    input b,
    output o
    );

wire not_a, not_b, w0, w1;
nand_not g0(a, not_a);
nand_not g1(b, not_b);
nand_and g2(a, b, w0);
nand_and g3(not_b, not_a, w1);
nand_or g4(w0, w1, o);

endmodule

module NAND_Implement (a, b, sel, out);
input a, b;
input [3-1:0] sel;
output out;

wire [7:0] w;

nand(w[0], a, b);
nand_and g1(a, b, w[1]);
nand_or g2(a, b, w[2]);
nand_nor g3(a, b, w[3]);
nand_xor g4(a, b, w[4]);
nand_xnor g5(a, b, w[5]);
nand_not g6(a, w[6]);
nand_not g7(a, w[7]);

mux8 m(w, sel, out);

endmodule
