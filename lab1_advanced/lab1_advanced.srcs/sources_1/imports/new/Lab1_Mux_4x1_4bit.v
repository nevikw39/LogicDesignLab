`timescale 1ns/1ps

module mux(
    input [3:0] a,
    input [3:0] b,
    input sel,
    output [3:0] f
);

wire not_sel;
not(not_sel, sel);

wire [3:0] w0, w1, w2;

and(w0[0], a[0], not_sel);
and(w0[1], a[1], not_sel);
and(w0[2], a[2], not_sel);
and(w0[3], a[3], not_sel);

and(w1[0], b[0], sel);
and(w1[1], b[1], sel);
and(w1[2], b[2], sel);
and(w1[3], b[3], sel);

or o[3:0](f, w0, w1);

endmodule
