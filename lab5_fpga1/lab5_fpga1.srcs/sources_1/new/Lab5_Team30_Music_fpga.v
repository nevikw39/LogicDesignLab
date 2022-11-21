`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Team30
// Engineer: nevikw39
// 
// Create Date: 11/21/2022 08:19:52 PM
// Design Name: Music FPGA
// Module Name: fpga1
// Project Name: Lab 5 Adv.
// Target Devices: Basys 3
// Tool Versions: Vivado 2020.2
// Description: KeyboardDecoder, PWM_gen
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Modified Audio Decoder
module Decoder (
	input [4:0] tone,
	output [31:0] freq 
);

reg [31:0] w;

always @*
	case (tone - tone / 7 * 7)
		5'd0: w = 32'd262;	  // C4
		5'd1: w = 32'd294;	  // D4
		5'd2: w = 32'd330;	  // E4
		5'd3: w = 32'd349;    // F4
		5'd4: w = 32'd392;	  // G4
		5'd5: w = 32'd440;	  // A4
		5'd6: w = 32'd494;	  // B4
		default: w = 32'd0;
	endcase

assign freq = w << (tone / 7);

endmodule

// Clock of 0.5 sec period
module divided_clock(
    input clk,
    output dclk
);

reg [25:0] cnt = 26'b0;
wire [25:0] next_cnt = cnt + 26'b1 != 26'd50_000_000 ? cnt + 26'b1 : 26'b0;

always @(posedge clk)
    cnt <= next_cnt;

assign dclk = cnt == 26'b0;

endmodule

module fpga1(
    input CLK100MHZ,
    inout PS2Clk,
    inout PS2Data,
    input btnC,
    output [3:0] JB
    );
    
    reg [4:0] tone = 5'b0, next_tone;
    wire [31:0] freq;
    assign JB[3:1] = 3'b1z1; // no gain (6dB), turn-on
        
    Decoder dec (
        .tone(tone),
        .freq(freq)
    );
    
    PWM_gen pwm ( 
        .clk(CLK100MHZ), 
        .reset(btnC), 
        .freq(freq),
        .duty(10'd512), 
        .PWM(JB[0])
    );
    
    wire [511:0] key_down;
    wire [8:0] last_change;
    wire key_valid;
    
    KeyboardDecoder kd (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .PS2_DATA(PS2Data),
        .PS2_CLK(PS2Clk),
        .rst(btnC),
        .clk(CLK100MHZ)
    );
    
    // nevikw39
    
    localparam [8:0] KEY_ENTER = 9'h5A,
                     KEY_W = 9'h1D,
                     KEY_S = 9'h1B,
                     KEY_R = 9'h2D;
    
    reg dir = 1'b1, pace = 1'b1, cnt = 1'b0, next_dir, next_pace;
    wire next_cnt = cnt + 1'b1;
    wire dclk;
    divided_clock dc(CLK100MHZ, dclk);
    
    always @*
        if (dir)
           next_tone = tone != 5'd29 ? tone + 5'b1 : tone;
        else
           next_tone = tone ? tone - 5'b1 : tone;
    
    always @*
        if (key_valid && key_down[last_change]) begin
            if (last_change == KEY_W) begin
                next_dir = 1'b1;
                next_pace = pace;
            end
            else if (last_change == KEY_S) begin
                next_dir = 1'b0;
                next_pace = pace;
            end
            else if (last_change == KEY_R) begin
                next_dir = dir;
                next_pace = !pace;
            end
            else begin
                next_dir = dir;
                next_pace = pace;
            end
        end
        else begin
            next_dir = dir;
            next_pace = pace;
        end
    
    wire rst = key_valid && key_down[last_change] && last_change == KEY_ENTER || btnC;
    
    always @(posedge CLK100MHZ, posedge rst)
        if (rst) begin
            dir <= 1'b1;
            pace <= 1'b1;
            cnt <= 1'b0;
            tone <= 1'b0;
        end
        else begin
            dir <= next_dir;
            pace <= next_pace;
            if (dclk) begin
                cnt <= next_cnt;
                if (pace && cnt || !pace)
                    tone <= next_tone;
                else
                    tone <= tone;
            end
            else begin
                cnt <= cnt;
                tone <= tone;
            end
        end
    
endmodule
