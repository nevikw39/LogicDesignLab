`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output reg [8-1:0] dout;
output reg error;

reg[7:0] queue[2:0];
reg[2:0] front = 0, back = 0;

assign full = (back + 1 & 7) == front;
assign empty = !full && front == back;

always @(posedge clk) begin
    if (rst_n) begin
        if (ren) begin
            if (empty) begin
                error <= 1;
                dout <= 8'bxxxxxxxx;
            end
            else begin
                error <= 0;
                dout <= queue[front + 1 & 7];
                front <= front + 1 & 7;
            end
        end
        else if (wen) begin
            if (full) begin
                error <= 1;
                dout <= 8'bxxxxxxxx;
            end
            else begin
                error <= 0;
                dout <= 8'bxxxxxxxx;
                queue[back + 1 & 7] <= din;
                back <= back + 1 & 7;
            end
        end
        else
            dout <= 8'bxxxxxxxx;
     end
     else begin
        front <= 0;
        back <= 0;
        dout <= 0;
        error <= 0;
     end
end

endmodule
