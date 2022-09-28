`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/28 16:25:17
// Design Name: 
// Module Name: Crossbar_2x2_4bit_fpga
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


module Crossbar_2x2_4bit_fpga(
    input [3:0] in1,
    input [3:0] in2,
    input control,
    output [3:0] out1a,
    output [3:0] out1b,
    output [3:0] out2a,
    output [3:0] out2b
    );

Crossbar_2x2_4bit cb_a(in1, in2, control, out1a, out2a),
                  cb_b(in1, in2, control, out1b, out2b);

endmodule
