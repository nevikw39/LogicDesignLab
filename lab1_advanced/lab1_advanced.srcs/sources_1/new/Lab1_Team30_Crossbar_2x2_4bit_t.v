`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/09/28 11:59:03
// Design Name: 
// Module Name: Crossbar_2x2_4bit_t
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


module Crossbar_2x2_4bit_t();
reg [4-1:0] in1 = 4'b0, in2 = 4'b1;
reg control = 1'b0;
wire [4-1:0] out1, out2;
Crossbar_2x2_4bit cb(in1, in2, control, out1, out2);
// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("MUX.fsdb");
//      $fsdbDumpvars;
// end
initial begin
    repeat(8) begin
        #1
        in1 = in1 + 4'd2;
        in2 = in2 + 4'd2;
        control = !control;
    end
    #1
    $finish;
end
endmodule
