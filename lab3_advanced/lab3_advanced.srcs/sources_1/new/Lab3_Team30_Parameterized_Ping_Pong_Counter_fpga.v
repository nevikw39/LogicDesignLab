`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/19 12:09:11
// Design Name: 
// Module Name: Parameterized_Ping_Pong_Counter_fpga
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


module Parameterized_Ping_Pong_Counter_fpga(sw, CLK100MHZ, btnU, btnD, an, seg, dp);
input [15:7] sw;
input CLK100MHZ, btnU, btnD;
wire clk, pb_reset, pb_flip;
wire enable;
wire [3:0] max;
wire [3:0] min;
output [3:0] an;
output [0:6] seg;
output dp;

assign clk = CLK100MHZ;
assign pb_reset = btnU;
assign pb_flip = btnD;
assign enable = sw[15];
assign max[3 : 0] = sw[14 : 11];
assign min[3 : 0] = sw[10 : 7];

wire [3:0] out;
wire direction;
wire reset_debounced;
wire reset_one_pulse;
wire flip_debounced;
wire flip_one_pulse;
wire rst_n;
wire dclk;
assign dp = 1'b1;
assign rst_n = ~reset_one_pulse;
one_second_clk o(clk, rst_n, dclk);

debounce reset_db(reset_debounced, pb_reset, clk);
onepulse reset_op(reset_debounced, clk, reset_one_pulse);

debounce flip_db(flip_debounced, pb_flip, clk);
onepulse flip_op(flip_debounced, clk, flip_one_pulse);

seven_segment_display SSD(clk, rst_n, out, direction, an, seg);
Parameterized_Ping_Pong_Counter_f PPPC(clk, dclk, rst_n, enable, flip_one_pulse, max, min, direction, out);
endmodule

module one_second_clk (clk, rst_n, dclk);
input clk;
input rst_n;
output dclk;

reg [26:0] one_sec_counter; 
reg [26:0] next_counter;

always @ (posedge clk) begin
    if(!rst_n) one_sec_counter <= 26'd0;
    else one_sec_counter <= next_counter;
end

always @ (*) begin
    if(one_sec_counter==27'd99999999) next_counter = 27'd0;
    else next_counter = one_sec_counter + 27'd1;
end

assign dclk = (one_sec_counter==27'd99999999)? 1'b1:1'b0;

endmodule

module debounce (pb_debounced, pb, clk);
output pb_debounced;
input pb;
input clk; 

reg [3:0] DFF;
always @(posedge clk) 
begin
    DFF[3:1] <= DFF[2:0];
    DFF[0] <= pb;
end
assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);

endmodule

module onepulse (PB_debounced, CLK, PB_one_pulse);
input PB_debounced;
input CLK;
output PB_one_pulse;
reg PB_one_pulse;
reg PB_debounced_delay;
always @(posedge CLK) begin
    PB_one_pulse <= PB_debounced & (! PB_debounced_delay);
    PB_debounced_delay <= PB_debounced;
end

endmodule

module seven_segment_display (clk, rst_n, out, direction, an, seg);
input clk;
input rst_n;
input [3:0]out;
input direction;
output reg [3:0]an;
output reg [0:6]seg;

reg [18:0] one_ms_counter;
wire [18:0] next_counter;
wire [1:0] LED;

always @ (posedge clk) begin
    if(rst_n==1'b0) one_ms_counter <= 19'd0;
    else one_ms_counter <= next_counter;
end
assign next_counter = one_ms_counter + 19'd1;
assign LED = one_ms_counter[18:17];

always @ (*)begin
    if(LED==2'b00) an = 4'b1110;
    else if(LED==2'b01) an = 4'b1101;
    else if(LED==2'b10) an = 4'b1011;
    else if(LED==2'b11) an = 4'b0111;
end

always @ (*)begin
    if(an==4'b0111)begin
        if(out>=4'd10) seg = 7'b1001111;
        else seg = 7'b0000001;
    end

    else if(an==4'b1011)begin
        if(out==4'd0 || out==4'd10) seg = 7'b0000001;
        else if(out==4'd1 || out==4'd11) seg = 7'b1001111;
        else if(out==4'd2 || out==4'd12) seg = 7'b0010010;
        else if(out==4'd3 || out==4'd13) seg = 7'b0000110;
        else if(out==4'd4 || out==4'd14) seg = 7'b1001100;
        else if(out==4'd5 || out==4'd15) seg = 7'b0100100;
        else if(out==4'd6) seg = 7'b0100000;
        else if(out==4'd7) seg = 7'b0001111;
        else if(out==4'd8) seg = 7'b0000000;
        else if(out==4'd9) seg = 7'b0000100;
    end

    else if(an==4'b1101 || an==4'b1110)begin
        if(direction==1'b1) seg= 7'b0011101;
        else seg = 7'b1100011;
    end

end

endmodule

module Parameterized_Ping_Pong_Counter_f (clk, dclk, rst_n, enable, flip, max, min, direction, out);
input clk, dclk, rst_n;
input enable;
input flip;
input [4-1:0] max;
input [4-1:0] min;
output reg direction;
output reg [4-1:0] out;

reg next_dir;
reg [3:0] next_out;

always@ (*) begin
    if(enable) begin
        if(max > min) begin
            if(out <= max & out >= min) next_out = (next_dir)? (out + 1'b1) : (out - 1'b1);
            else next_out = out;
        end
        else next_out = out;
    end
    else next_out = out;
end

always @ (posedge clk) begin
    if(rst_n) begin
        if(dclk) begin
            if(enable & max > min & out <= max & out >= min & flip) begin
                direction <= ~direction;
                out <= out;
            end
            else begin
                out <= next_out;
                direction <= next_dir;
            end 
        end
        else begin
             if(enable & max > min & out <= max & out >= min & flip) begin
                direction <= ~direction;
                out <= out;
            end
            else begin
                out <= out;
                direction <= direction;
            end 
        end          
    end
    else begin
        out <= min;
        direction <= 1'b1;
    end
end

always @(*) begin
    if(enable) begin
        if(max > min) begin
            if(out <= max & out >= min) begin
                if(flip) next_dir = ~direction;
                else if(out == max) next_dir = 1'b0;
                else if(out == min) next_dir = 1'b1;
                else next_dir = direction;               
            end
            else next_dir = direction;
        end
        else next_dir = direction;
    end
    else next_dir = direction;
end

endmodule
