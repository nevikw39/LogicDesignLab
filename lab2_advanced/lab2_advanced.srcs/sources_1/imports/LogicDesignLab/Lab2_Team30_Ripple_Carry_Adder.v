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

module Majority(a, b, c, out);
input a, b, c;
output out;

wire [3:0] w;
nand_and g0(a, b, w[0]),
         g1(b, c, w[1]),
         g2(a, c, w[2]);
nand_or g3(w[0], w[1], w[3]),
        g4(w[2], w[3], out);

endmodule

module Half_Adder(a, b, cout, sum);
input a, b;
output cout, sum;

nand_xor g0(a, b, sum);
nand_and g1(a, b, cout);

endmodule

module Full_Adder (a, b, cin, cout, sum);
input a, b, cin;
output cout, sum;

wire w;
nand_xor g0(a, b, w);
nand_xor g1(w, cin, sum);

Majority m(a, b, cin, cout);

endmodule


module Ripple_Carry_Adder_8(a, b, cin, cout, sum);
input [8-1:0] a, b;
input cin;
output cout;
output [8-1:0] sum;

wire [7-1:0] c;

Full_Adder f1(a[0], b[0], cin, c[0], sum[0]),
           f2(a[1], b[1], c[0], c[1], sum[1]),
           f3(a[2], b[2], c[1], c[2], sum[2]),
           f4(a[3], b[3], c[2], c[3], sum[3]),
           f5(a[4], b[4], c[3], c[4], sum[4]),
           f6(a[5], b[5], c[4], c[5], sum[5]),
           f7(a[6], b[6], c[5], c[6], sum[6]),
           f8(a[7], b[7], c[6], cout, sum[7]);
endmodule
