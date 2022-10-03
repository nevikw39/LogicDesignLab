`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/04 01:04:47
// Design Name: 
// Module Name: Exhausted_Testing_t
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


module Exhausted_Testing_t;

    wire [3:0] a, b;
    wire cin, error, done;
    
    Exhausted_Testing ET(
    .a(a), 
    .b(b), 
    .cin(cin), 
    .error(error), 
    .done(done)
    );
// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("Adders.fsdb");
//      $fsdbDumpvars;
// end


endmodule
