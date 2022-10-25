`timescale 1ns/1ps

module FIFO_8(clk, rst_n, wen, ren, din, dout, error);
input clk;
input rst_n;
input wen, ren;
input [8-1:0] din;
output reg [8-1:0] dout;
output reg error;

reg[7:0] queue[8:0];
reg[3:0] front, back;

wire[3:0] next_front, next_back;
assign next_front = front != 8 ? front + 1 : 0,
       next_back = back != 8 ? back + 1 : 0;
assign full = next_back == front,
       empty = front == back;

always @(posedge clk) begin
    if (rst_n) begin
        if (ren) begin
            if (empty) begin
                error <= 1;
                dout <= 8'bxxxxxxxx;
            end
            else begin
                error <= 0;
                dout <= queue[next_front];
                front <= next_front;
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
                queue[next_back] <= din;
                back <= next_back;
            end
        end
        else begin
            error <= 0;
            dout <= 8'bxxxxxxxx;
        end
     end
     else begin
        front <= 0;
        back <= 0;
        dout <= 0;
        error <= 0;
     end
end

endmodule
