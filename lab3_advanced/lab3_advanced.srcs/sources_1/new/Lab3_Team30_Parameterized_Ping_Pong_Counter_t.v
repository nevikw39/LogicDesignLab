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
reg clk = 1'b0; 
reg rst_n = 1'b0; 
reg enable = 1'b1; 
reg flip = 1'b0;
reg [3:0]max = 4'b1111;
reg [3:0]min = 4'b0000;
wire direction;
wire [3:0]out; 

parameter cyc = 10;
always #(cyc/2) clk = !clk;


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
initial begin
    #cyc
    rst_n = 1'b1;
    max = 4'b1000;
    min = 4'b0000;
    #(cyc/2)
    #(cyc*10)
    enable = 1'b0; 
    #(cyc*5)
    enable = 1'b1;
    #(cyc*10)
    #(cyc/2)
    @(negedge clk) flip = 1'b1; 
    @(negedge clk) flip = 1'b0;
    #(cyc/2)
    #(cyc*8)
    max = 4'b0001;
    min = 4'b1000;
    
    #(cyc*5)   
    max = 4'b0010;
    min = 4'b0000;
    
    #(cyc*5)
    max = 4'b1000; 
    min = 4'b0101;
    
    #(cyc*5)
    max = 4'b1111;
    min = 4'b0000;
    
    #(cyc*5)
    
	#1 $finish;
end

endmodule
