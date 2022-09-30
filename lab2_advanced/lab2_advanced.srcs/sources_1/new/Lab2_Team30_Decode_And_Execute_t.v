`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team30
// Engineer: nevikw39
// 
// Create Date: 10/01/2022 12:55:18 AM
// Design Name: Decode_And_Execute testbench
// Module Name: Decode_And_Execute_t
// Project Name: Lab 2 Advanced
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


module Decode_And_Execute_t();

reg [3:0] rs = 4'd0, rt = 4'd1;
reg [2:0] sel = 0;
wire [3:0] rd;

Decode_And_Execute dae(rs, rt, sel, rd);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $dumpfile("Decode_And_Execute.vhd");
//      $dumpvars("+all");
// end

initial begin
    repeat(8) begin
        repeat (8) begin
            #1 sel = sel + 1'b1;
        end
        rs = rs + 4'd4;
        rt = rt + 4'd2;
    end
    #1 $finish;
end 

endmodule
