`timescale 1ns/1ps

module D_Flip_Flop(
    input clk,
    input d,
    output q
    );

wire not_clk, w;
not(not_clk, clk);

D_Latch master(not_clk, d, w), slave(clk, w, q);

endmodule

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