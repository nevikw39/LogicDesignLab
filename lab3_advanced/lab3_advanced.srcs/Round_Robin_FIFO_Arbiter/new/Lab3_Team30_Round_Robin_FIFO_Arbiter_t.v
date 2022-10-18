`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2022 09:53:44 PM
// Design Name: 
// Module Name: Round_Robin_FIFO_Arbiter_t
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


module Round_Robin_FIFO_Arbiter_t();

reg clk = 0, rst_n = 0;
reg [4-1:0] wen;
reg [8-1:0] a, b, c, d;
wire [8-1:0] dout;
wire valid;
Round_Robin_FIFO_Arbiter rrfa(clk, rst_n, wen, a, b, c, d, dout, valid);

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc / 2) clk = !clk;

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
// initial begin
//     $dumpfile("Round_Robin_FIFO_Arbiter.vhd");
//     $dumpvars("+all");
// end

integer f, eof = 0;

initial begin
    f = $fopen("rffa.txt", "r");
    if (!f) begin
        $display("Open file failed!\n");
        $finish;
    end
    while (~eof) begin
        @(negedge clk)
        rst_n = 1;
        eof = $fscanf(f, "%b%d%d%d%d%d", wen, a, b, c, d);
    end
    
    @(negedge clk)
    $finish;
end

endmodule
