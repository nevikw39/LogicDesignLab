`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/17 23:03:27
// Design Name: 
// Module Name: Ping_Pong_Counter_t
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


module Ping_Pong_Counter_t();
reg clk = 1'b0, rst_n = 1'b0;
reg enable = 1'b0;
wire direction;
wire [4-1:0] out;

Ping_Pong_Counter P (
.clk(clk), 
.rst_n(rst_n), 
.enable(enable), 
.direction(direction), 
.out(out));

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $dumpfile("Multi_Bank_Memory.vhd");
//     $dumpvars("+all");
// end
always begin
#5 clk = ~clk; 
end

always begin
#10 enable = ~enable; 
end

initial begin
#10 rst_n = 1'b1;
#5000 $finish;
end
endmodule
