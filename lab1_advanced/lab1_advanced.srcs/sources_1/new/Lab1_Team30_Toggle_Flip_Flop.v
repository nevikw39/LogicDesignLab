`timescale 1ns/1ps

module Toggle_Flip_Flop(clk, q, t, rst_n);
input clk;
input t;
input rst_n;
output q;
wire w0, w1, x0, x1, not_q, not_t;

not n1(not_t, t);
not n2(not_q, q);
and xo1(x0, t, not_q);
and xo2(x1, not_t, q);
or xo3(w0, x0, x1);

and a0(w1, rst_n, w0);

D_Flip_Flop d1(clk, w1, q);

endmodule