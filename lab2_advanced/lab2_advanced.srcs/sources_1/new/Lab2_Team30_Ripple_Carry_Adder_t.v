`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/01 13:31:09
// Design Name: 
// Module Name: Ripple_Carry_Adder_t
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


module Ripple_Carry_Adder_t;
reg [8-1:0] a = 8'b0;
reg [8-1:0] b = 8'b0;
reg cin = 1'b0;
wire cout;
wire [8-1:0] sum;

Ripple_Carry_Adder RCA(
    .a(a), 
    .b(b), 
    .cin(cin), 
    .cout(cout), 
    .sum(sum)
);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("Adders.fsdb");
//      $fsdbDumpvars;
// end

initial begin
    repeat (3) begin
       repeat((2**9)-1) begin
            #1
            a = a + 8'b1;
            b = b + 8'b1;
        end
        cin = cin + 1'b1;
        a = 8'b0;
        b = 8'b0;
    end
    #1 $finish;
end

endmodule
