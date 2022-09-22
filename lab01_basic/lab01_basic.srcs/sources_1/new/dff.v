`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  NTHU
// Engineer:  nevikw39
// 
// Create Date: 2022/09/22 15:54:13
// Design Name: D Flip-Flop
// Module Name: dff
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


module d_latch(
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


module dff(
    input clk,
    input d,
    output q
    );

wire not_clk, w;
not(not_clk, clk);

d_latch master(not_clk, d, w), slave(clk, w, q);

endmodule
