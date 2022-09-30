`timescale 1ns/1ps

module Universal_Gate(a, b, out);
input a, b;
output out;

assign out = a & ~b;

endmodule