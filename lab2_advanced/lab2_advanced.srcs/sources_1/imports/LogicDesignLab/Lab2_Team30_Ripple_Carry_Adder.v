`timescale 1ns/1ps

module Ripple_Carry_Adder(a, b, cin, cout, sum);
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
