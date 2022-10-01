`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team30
// Engineer: nevikw39
// 
// Create Date: 10/01/2022 11:36:44 PM
// Design Name: Decode_And_Execute FPGA
// Module Name: Decode_And_Execute_fpga
// Project Name: Lab 2 Advanced
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


module seg_display(
    input [3:0] rd,
    output [6:0] C
    );

wire [7:0] w_xor, w_nor;
wire [3:0] w_and, w_or;

xor(w_xor[0], rd[3], rd[1]);
xor(w_xor[1], w_xor[0], rd[2]);
xor(w_xor[2], rd[1], w_and[0]);
xor(w_xor[3], rd[0], rd[3]);
xor(w_xor[4], w_xor[1], w_xor[3]);
xor(w_xor[5], w_nor[2], rd[3]);
xor(w_xor[6], w_or[3], rd[3]);
xor(w_xor[7], w_and[3], w_nor[5]);

nor(w_nor[0], w_xor[1], w_xor[2]);
nor(w_nor[1], w_nor[0], w_xor[0]);
nor(w_nor[2], w_xor[4], w_xor[3]);
nor(w_nor[3], w_nor[1], w_xor[5]);
nor(w_nor[4], w_xor[2], w_and[0]);
nor(w_nor[5], w_or[3], w_nor[4]);
nor(w_nor[6], w_nor[4], rd[3]);
nor(w_nor[7], w_xor[5], w_nor[6]);

and(w_and[0], rd[0], rd[2]);
and(w_and[1], w_or[0], w_xor[4]);
and(w_and[2], w_nor[1], rd[0]);
and(w_and[3], w_xor[5], rd[2]);

or(w_or[0], w_nor[1], rd[0]);
or(w_or[1], w_and[2], w_and[3]);
or(w_or[2], w_and[0], w_xor[3]);
or(w_or[3], w_nor[1], w_or[2]);

buf(C[0], w_nor[7]);
buf(C[1], w_or[1]);
buf(C[2], w_xor[7]);
buf(C[3], w_and[1]);
buf(C[4], w_xor[6]);
buf(C[5], w_nor[3]);
buf(C[6], w_nor[0]);

endmodule

module Decode_And_Execute_fpga(
    input [3:0] rs,
    input [3:0] rt,
    input [2:0] sel,
    output [6:0] C,
    output [3:0] AN
    );

wire [3:0] rd;
Decode_And_Execute dae(rs, rt, sel, rd);
seg_display sd(rd, C);

not n [3:0] (AN, 4'b0001);

endmodule
