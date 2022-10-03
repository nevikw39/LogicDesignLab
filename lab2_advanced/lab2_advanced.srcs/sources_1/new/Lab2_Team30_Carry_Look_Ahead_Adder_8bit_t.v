`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/03 20:57:31
// Design Name: 
// Module Name: CLA_8bit_t
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


module CLA_8bit_t;
reg [8-1:0] a = 8'b0;
reg [8-1:0] b = 8'b0;
reg c0 = 1'b0;
wire [8-1:0] s;
wire c8;

Carry_Look_Ahead_Adder_8bit CLA(
    .a(a), 
    .b(b), 
    .c0(c0), 
    .s(s), 
    .c8(c8)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("Adders.fsdb");
//      $fsdbDumpvars;
// end

initial begin
    repeat (2**17) begin
            #1
           {a, b, c0} = {a, b, c0} + 1;
    end
    #1 $finish;
end
endmodule
