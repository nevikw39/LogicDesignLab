`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2022 06:18:12 PM
// Design Name: 
// Module Name: Multiplier_4bit_t
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


module Multiplier_4bit_t();

reg [3:0] a = 4'd0, b = 4'd1;
wire [7:0] p;
Multiplier_4bit m(a, b, p);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $dumpfile("Decode_And_Execute.vhd");
//      $dumpvars("+all");
// end

initial begin
    repeat(8) begin
        #1
        a = a + 4'd2;
        b = b + 4'd2;
    end
    #1 $finish;
end

endmodule
