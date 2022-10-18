`timescale 1ns/1ps

module Parameterized_Ping_Pong_Counter (clk, rst_n, enable, flip, max, min, direction, out);
input clk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg direction;
output reg [4-1:0] out;

always @ (posedge clk) begin
    if(rst_n) begin     
       if(enable & max > min & out <= max & out >= min) begin
            if( ((out == max & direction) | (out == min & !direction))) assign direction = ~direction;
            else if( (out < max | out > min) & flip) assign direction = ~direction;  
            
            assign out = (direction)? (out+1'b1) : (out-1'b1);
       end 
    end
    else begin
        assign out = min;
        assign direction = 1'b1;
    end
end
endmodule
