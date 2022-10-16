`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team 30
// Engineer: nevikw39
// 
// Create Date: 10/16/2022 09:00:16 PM
// Design Name: 8-bit FIFO testbench
// Module Name: FIFO_8_t
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


module FIFO_8_t();

reg clk = 0, rst_n = 0, ren = 1, wen = 0;
reg[7:0] din = 0;
wire[7:0] dout;
wire error;
FIFO_8 f(clk, rst_n, wen, ren, din, dout, error);

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc / 2) clk = !clk;

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $dumpfile("FIFO_8.vhd");
//     $dumpvars("+all");
// end

initial begin
    // 0
    @(negedge clk)
    rst_n = 1;
    
    // 1
    @(negedge clk)
    din = 56;
    ren = 0;
    wen = 1;
    
    // 2
    @(negedge clk)
    din = 11;
    
    // 3
    @(negedge clk)
    din = 42;
    
    // 4
    @(negedge clk)
    din = 10;
    
    // 5
    @(negedge clk)
    din = 23;
    
    // 6
    @(negedge clk)
    din = 20;
    
    // 7
    @(negedge clk)
    din = 6;
    
    // 8
    @(negedge clk)
    din = 85;
    
    // 9
    @(negedge clk)
    din = 45;
    ren = 1;
    
    // 10
    @(negedge clk)
    din = 12;
    ren = 0;
    
    // 11
    @(negedge clk)
    din = 77;
    
    // 12
	@(negedge clk)
	wen = 0;
	
	// 
	@(negedge clk)
    $finish;
end

endmodule
