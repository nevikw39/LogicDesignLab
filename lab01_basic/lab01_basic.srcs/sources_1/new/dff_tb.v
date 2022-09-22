`timescale 1ns / 1ps

`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NTHU
// Engineer: nevikw39
// 
// Create Date: 2022/09/22 16:52:23
// Design Name: D Flip-Flop test bench
// Module Name: dff_tb
// Project Name: lab01_basic
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


module dff_tb();

// input and output signals
reg clk = 1'b0;
reg d = 1'b0;
wire q;

// generate clk
always#(1) clk = ~clk;

// test instance instantiation
dff DFF(
    .clk(clk),
    .d(d),
    .q(q)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("DFF.fsdb");
//      $fsdbDumpvars;
// end

// brute force 
initial begin
    @(negedge clk) d = 1'b1;
    @(negedge clk) d = 1'b0;
    @(negedge clk) $finish;
end

endmodule
