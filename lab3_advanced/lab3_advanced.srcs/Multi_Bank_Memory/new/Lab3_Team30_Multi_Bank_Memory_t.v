`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team 30
// Engineer: nevikw39
// 
// Create Date: 10/17/2022 01:49:30 AM
// Design Name: Multi-Bank Memory testbench
// Module Name: Multi_Bank_Memory_t
// Project Name: Lab 3 Advanced
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


module Multi_Bank_Memory_t();

reg clk = 0, ren = 0, wen = 0;
reg [7:0] din = 0;
reg [10:0] waddr, raddr;
wire [7:0] dout;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc / 2) clk = !clk;

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $dumpfile("Multi_Bank_Memory.vhd");
//     $dumpvars("+all");
// end

Multi_Bank_Memory mbm(clk, ren, wen, waddr, raddr, din, dout);

endmodule
