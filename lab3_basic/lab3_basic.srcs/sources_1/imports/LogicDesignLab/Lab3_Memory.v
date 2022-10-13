`timescale 1ns/1ps

module Memory (clk, ren, wen, addr, din, dout);
input clk;
input ren, wen;
input [7-1:0] addr;
input [8-1:0] din;
output reg [8-1:0] dout;

parameter M = 128, N = 8;
reg [N-1:0] mem [M-1:0];

always @(posedge clk) begin
    if (ren) begin
        dout <= mem[addr];
    end
    else if (wen) begin
        dout <= 0;
        mem[addr] <= din;
    end
    else
        dout <= 0;
end

endmodule
