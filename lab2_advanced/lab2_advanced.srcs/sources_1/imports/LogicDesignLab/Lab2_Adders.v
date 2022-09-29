`timescale 1ns/1ps

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

