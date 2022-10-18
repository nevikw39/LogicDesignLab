`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/18 00:09:38
// Design Name: 
// Module Name: Parameterized_Ping_Pong_Counter_t
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


module Parameterized_Ping_Pong_Counter_t();
reg clk = 1'b0, rst_n = 1'b0;
reg enable = 1'b0;
reg flip = 1'b0;
reg [3:0] max ;
reg [3:0] min;
wire direction;
wire [4-1:0] out;

Parameterized_Ping_Pong_Counter P (
.clk(clk), 
.rst_n(rst_n), 
.enable(enable), 
.flip(flip),
.max(max),
.min(min),
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

end
endmodule
