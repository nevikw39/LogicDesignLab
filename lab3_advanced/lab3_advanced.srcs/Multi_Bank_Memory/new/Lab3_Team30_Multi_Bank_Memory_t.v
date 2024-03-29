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
reg [1:0] wbank = 0, rbank = 0, wmem = 0, rmem = 0;
reg [6:0] waddr = 0, raddr = 0;
wire [7:0] dout;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc / 2) clk = !clk;

Multi_Bank_Memory mbm(clk, ren, wen, {wbank, wmem, waddr}, {rbank, rmem, raddr}, din, dout);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $dumpfile("Multi_Bank_Memory.vhd");
//     $dumpvars("+all");
// end

initial begin
    // Read uninitialized data, undefined behavior?
//    @(negedge clk)
//    ren = 1;
    
    // write, read to (0, 0, 2)
    @(negedge clk)
    ren = 0;
    wen = 1;
    waddr = 2;
    din = 3;
    @(negedge clk)
    ren = 1;
    raddr = 2;
    wen = 0;
    
    // write, read to (0, 2, 3)
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
    
    // write, read to (2, 3, 4)
    @(negedge clk)
    ren = 0;
    wen = 1;
    wbank = 2;
    wmem = 3;
    waddr = 4;
    din = 5;
    @(negedge clk)
    ren = 1;
    rbank = 2;
    rmem = 3;
    raddr = 4;
    wen = 0;
    
    // read from (0, 2, 3) == 4 & write 87 to (3, 2, 1)
    @(negedge clk)
    rbank = 0;
    rmem = 2;
    raddr = 3;
    wen = 1;
    wbank = 3;
    wmem = 2;
    waddr = 1;
    din = 87;
    
    // read from (3, 2, 1) == 87 & write 69 to (3, 1, 5)
    @(negedge clk)
    rbank = 3;
    rmem = 2;
    raddr = 1;
    wbank = 3;
    wmem = 1;
    waddr = 5;
    din = 69;
    
    // read from (3, 1, 5) == 69 (& write 89 to (3, 1, 64))
    @(negedge clk)
    rbank = 3;
    rmem = 1;
    raddr = 5;
    wbank = 3;
    wmem = 1;
    waddr = 64;
    din = 89;
    
    // read (3, 1, 64)
    @(negedge clk)
    rbank = 3;
    rmem = 1;
    raddr = 64;
    wen = 0;
    
    @(negedge clk)
    $finish;
end

endmodule
