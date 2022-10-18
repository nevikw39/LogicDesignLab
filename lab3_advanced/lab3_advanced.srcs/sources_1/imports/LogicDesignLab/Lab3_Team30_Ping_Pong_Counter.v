`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output reg direction;
output reg [4-1:0] out;

parameter max = 4'b1111;
parameter min = 4'b0000;

reg next_dir;
wire [3:0] next_out;

assign next_out = (next_dir)? (out + 1'b1) : (out - 1'b1);

always @ (posedge clk) begin
    if(rst_n) begin
       if(enable) begin
            direction <= next_dir;
            out <= next_out;
       end 
    end
    else begin
        out <= 4'b0000;
        direction <= 1'b1;
    end
end

always @(*) begin
if(out == max & direction) next_dir = 0;
else if(out == min & !direction) next_dir = 1;
else next_dir = direction;
end

endmodule
