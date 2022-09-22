`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: NTHU
// Engineer: nevikw39
// 
// Create Date: 2022/09/22 16:22:53
// Design Name: 4 bits 4-1 MUX test bench
// Module Name: mux_tb
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


module mux_tb();

reg [3:0] a = 4'b0000, b = 4'b0010, c = 4'b0100, d = 4'b1000;
reg [1:0] sel = 2'b0;
wire [3:0] f;

mux m(a, b, c, d, sel, f);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//      $fsdbDumpfile("MUX.fsdb");
//      $fsdbDumpvars;
// end

initial begin
    repeat (2 ** 3) begin
        #1 sel = sel + 2'b1;
        a = a + 4'b1;
        b = b + 4'b1;
        c = c + 4'b1;
        d = d + 4'b1;
    end
    #1 $finish;
end

endmodule
