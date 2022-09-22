`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  NTHU
// Engineer:  nevikw39
// 
// Create Date: 2022/09/22 15:54:13
// Design Name:  4 bits 4-1 MUX
// Module Name: mux
// Project Name: lab01_basic
// Target Devices: Basys 3
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux2to1(
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


module mux(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [1:0] sel,
    output [3:0] f
    );

wire [3:0] w0, w1;

mux2to1 p(a, b, sel[0], w0), q(c, d, sel[0], w1), r(w0, w1, sel[1], f);

endmodule
