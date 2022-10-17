`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team 30
// Engineer: neivkw39
// 
// Create Date: 10/17/2022 06:59:27 PM
// Design Name: Bank testbench
// Module Name: Bank_t
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


module Bank_t();

reg clk = 0, ren = 0, wen = 0;
reg [7:0] din = 0;
reg [1:0] wmem = 0, rmem = 0;
reg [6:0] waddr = 0, raddr = 0;
wire [7:0] dout;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc / 2) clk = !clk;

Bank b(clk, ren, wen, {rmem, raddr}, {wmem, waddr}, din, dout);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $dumpfile("Multi_Bank_Memory.vhd");
//     $dumpvars("+all");
// end

initial begin
    $finish;
    // Read uninitialized data, undefined behavior?
//    @(negedge clk)
//    ren = 1;
    
    // write, read to (0, 2)
    @(negedge clk)
    ren = 0;
    wen = 1;
    waddr = 2;
    din = 3;
    @(negedge clk)
    ren = 1;
    raddr = 2;
    wen = 0;
    
    // write, read to (2, 3)
    @(negedge clk)
    ren = 0;
    wen = 1;
    wmem = 2;
    waddr = 3;
    din = 4;
    @(negedge clk)
    ren = 1;
    rmem = 2;
    raddr = 3;
    wen = 0;
    
    // read & write to (0, 2) & (3, 5)
    @(negedge clk)
    rmem = 0;
    raddr = 2;
    wen = 1;
    wmem = 3;
    waddr = 5;
    din = 7;
    
    // read (& write) to (3, 5) (& (3, 7))
    @(negedge clk)
    rmem = 3;
    raddr = 5;
    wmem = 3;
    waddr = 7;
    din = 11;
    
    // read (3, 7)
    @(negedge clk)
    raddr = 7;
    wen = 0;
    
    @(negedge clk)
    $finish;
end

endmodule
