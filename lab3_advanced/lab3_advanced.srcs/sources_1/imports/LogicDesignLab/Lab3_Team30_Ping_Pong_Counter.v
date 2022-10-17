`timescale 1ns/1ps

module Ping_Pong_Counter (clk, rst_n, enable, direction, out);
input clk, rst_n;
input enable;
output reg direction;
output reg [4-1:0] out;

parameter max = 4'b1111;
parameter min = 4'b0000;

always @ (posedge clk) begin
    if(rst_n) begin
       if( (out == max & direction) | (out == min & !direction) ) assign direction = ~direction;
       
       if(enable) begin
            assign out = (direction)? (out+1'b1) : (out-1'b1);
       end 
    end
    else begin
        assign out = 4'b0000;
        assign direction = 1'b1;
    end
end

endmodule
