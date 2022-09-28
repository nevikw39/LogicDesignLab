`timescale 1ns/1ps

module D_Latch(
    input e,
    input d,
    output q
    );

wire not_d, w0, w1, not_q;
not(not_d, d);
nand(w0, d, e);
nand(w1, not_d, e);

nand(q, w0, not_q);
nand(not_q, w1, q);

endmodule

module D_Flip_Flop(
    input clk,
    input d,
    output q
    );

wire not_clk, w;
not(not_clk, clk);

D_Latch master(not_clk, d, w), slave(clk, w, q);

endmodule


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