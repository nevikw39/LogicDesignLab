`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg direction;
output reg [4-1:0] out;

reg next_dir;
wire [3:0] next_out;

assign next_out = (next_dir)? (out + 1'b1) : (out - 1'b1);

always @ (posedge clk) begin
    if(rst_n) begin     
       if(enable & max > min & out <= max & out >= min) begin
            direction <= next_dir;
            out <= next_out;
       end 
    end
    else begin
        out <= min;
        direction <= 1'b1;
    end
end

always @(*) begin
    if(flip & max > min & out <= max & out >= min) next_dir = ~direction;

    if(!flip) begin
        if(out == max & direction) next_dir = 0;
        else if(out == min & !direction) next_dir = 1;
        else next_dir = direction;
    end
//else if(!flip & max > min & out <= max & out >= min) next_dir = direction;
end

endmodule
