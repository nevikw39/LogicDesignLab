`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team30
// Engineer: nevikw39
// 
// Create Date: 09/28/2022 01:56:53 PM
// Design Name: 4-bit 4-to-4 Crossbar testbench
// Module Name: Crossbar_4x4_4bit_t
// Project Name: Lab 1 Advanced
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


module Crossbar_4x4_4bit_t();

reg [3:0] in1 = 4'd0, in2 = 4'd1, in3 = 4'd2, in4 = 4'd3;
reg [4:0] control = 5'b0;
wire [3:0] out1, out2, out3, out4;
Crossbar_4x4_4bit cb(in1, in2, in3, in4, out1, out2, out3, out4, control);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("MUX.fsdb");
//      $fsdbDumpvars;
// end

initial begin
    repeat(32) begin
        #1
        in1 = in1 + 4'd4;
        in2 = in2 + 4'd4;
        in3 = in3 + 4'd4;
        in4 = in4 + 4'd4;
        control = control + 5'b1;
    end
    #1
    $finish;
end

endmodule
