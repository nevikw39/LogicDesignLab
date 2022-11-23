`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/22 17:22:46
// Design Name: 
// Module Name: Lab5_Team30_Traffic_Light_Controller_t
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


module Lab5_Team30_Traffic_Light_Controller_t();
reg clk = 1'b1, rst_n = 1'b1, lr_has_car = 1;
wire [2:0] hw_light, lr_light;
// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
Traffic_Light_Controller TLC(clk, rst_n, lr_has_car, hw_light, lr_light);

//parameter cyc = 10;

always#1clk = !clk;

always @(negedge clk) begin
lr_has_car = ~ lr_has_car;
end

initial begin
#3
rst_n = ~ rst_n;
#2
rst_n = ~ rst_n;
#77
rst_n = ~rst_n;
#2
rst_n = ~ rst_n;
#1000
$finish;
end

endmodule
