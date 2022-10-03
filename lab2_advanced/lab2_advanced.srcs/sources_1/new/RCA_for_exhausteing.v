`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/04 00:31:10
// Design Name: 
// Module Name: Ripple_Carry_Adder
// Project Name: 
// Target Devices: 
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

module Ripple_Carry_Adder(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output cout,
    output [3:0] sum
    );

wire [3:1] c;
wire w;
adder a0(a[0], b[0], cin, c[1], sum[0]),
      a1(a[1], b[1], c[1], c[2], sum[1]),
      a2(a[2], b[2], c[2], c[3], sum[2]),
      a3(a[3], b[3], c[3], cout, sum[3]);

endmodule
