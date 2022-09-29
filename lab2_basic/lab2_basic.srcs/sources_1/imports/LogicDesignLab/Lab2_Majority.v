`timescale 1ns/1ps

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