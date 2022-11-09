`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/08 11:54:00
// Design Name: 
// Module Name: 1A2B_fpga
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

module LFSR(clk, rst_n, start, random);
input clk, rst_n, start;
output reg [15:0] random;

reg [3:0] out0, out1, out2, out3;
reg [3:0] next_out0, next_out1, next_out2, next_out3;
reg [3:0] DFF;
reg [1:0] counter;
reg [1:0] next_counter;
always @(posedge clk) begin
    if(!rst_n)begin
        DFF <= 4'b1000;
        counter <= 2'b00;
        out0 <= 4'd0;
        out1 <= 4'd0;
        out2 <= 4'd0;
        out3 <= 4'd0;
    end
    else begin
        DFF[0] <= DFF[3];
        DFF[1] <= DFF[0] ^ DFF[3];
        DFF[2] <= DFF[1];
        DFF[3] <= DFF [2];
        out0 <= next_out0;
        out1 <= next_out1;
        out2 <= next_out2;
        out3 <= next_out3;
        counter <= next_counter;
        if(start) begin
            random[15:0] <= {out3, out2, out1, out0};
        end
        else random <= random;
    end
end

always @(*) begin
    case(counter)
        2'b00: begin
            next_out1 = out1;
            next_out2 = out2;
            next_out3 = out3;
            if(DFF != out1) begin
                if(DFF != out2)begin
                    if(DFF != out3)begin
                        if(DFF <= 4'd9) begin
                            next_out0 = DFF;
                            next_counter = counter + 1'b1;
                        end
                        else next_out0 = out0;
                    end
                    else next_out0 = out0;
                end
                else next_out0 = out0;
            end
            else next_out0 = out0;
        end
        2'b01: begin
            next_out0 = out0;
            next_out2 = out2;
            next_out3 = out3;
            if(DFF != out0) begin
                if(DFF != out2)begin
                    if(DFF != out3)begin
                        if(DFF <= 4'd9) begin
                            next_out1 = DFF;
                            next_counter = counter + 1'b1;
                        end
                        else next_out1 = out1;
                    end
                    else next_out1 = out1;
                end
                else next_out1 = out1;
            end
            else next_out1 = out1;
        end
         2'b10: begin
            next_out0 = out0;
            next_out1 = out1;
            next_out3 = out3;
            if(DFF != out0) begin
                if(DFF != out1)begin
                    if(DFF != out3)begin
                        if(DFF <= 4'd9) begin
                            next_out2 = DFF;
                            next_counter = counter + 1'b1;
                        end
                        else next_out2 = out2;
                    end
                    else next_out2 = out2;
                end
                else next_out2 = out2;
            end
            else next_out2 = out2;
        end
        default: begin
            next_out0 = out0;
            next_out1 = out1;
            next_out2 = out2;
            if(DFF != out0) begin
                if(DFF != out1)begin
                    if(DFF != out2)begin
                        if(DFF <= 4'd9) begin
                            next_out3 = DFF;
                            next_counter = counter + 1'b1;
                        end
                        else next_out3 = out3;
                    end
                    else next_out3 = out3;
                end
                else next_out3 = out3;
            end
            else next_out3 = out3;
        end
    endcase
end

endmodule

module seven_seg(clk, rst_n, in, state, an, seg);
input clk, rst_n;
input [15:0]in;
input [1:0] state;
output reg [3:0] an;
output reg [0:6] seg;

parameter s0 = 2'b00;
parameter s1 = 2'b01;
parameter s2 = 2'b10;

reg [27-1:0] counter, next_counter;
reg second, next_second;
always @(posedge clk) begin
    if(!rst_n) begin
        counter <= 27'd0;
        second <= 1'b0;
    end
    else begin
        counter <= next_counter;
        second <= next_second;
    end
end

always @(*) begin
    if(counter == 27'd49999999) begin
        next_second = ~second;
        next_counter = 27'd0;
    end
    else begin
        next_second = second;
        next_counter = counter + 27'd1;
    end
end

reg [18:0] one_ms_counter;
wire [18:0] next_ms_counter;
wire [1:0] active;

always @ (posedge clk) begin
    if(rst_n==1'b0) one_ms_counter <= 19'd0;
    else one_ms_counter <= next_ms_counter;
end
assign next_ms_counter = one_ms_counter + 19'd1;
assign active = one_ms_counter[18:17];

always @ (*)begin
    case(state)
        s0, s2: begin
            case(active)
                2'b00: an = 4'b1110;
                2'b01: an = 4'b1101;
                2'b10: an = 4'b1011;
                2'b11: an = 4'b0111;
            endcase
        end
        s1: begin
            case(active)
                2'b00: begin
                    if(second) an = 4'b1110;
                    else an = 4'b1111;
                end
                2'b01: an = 4'b1101;
                2'b10: an = 4'b1011;
                2'b11: an = 4'b0111;
            endcase
        end
     endcase
end

always @(*) begin
    if(an == 4'b0111) begin
        case(in[15:12])
            4'd0: seg = 7'b0000001;
            4'd1: seg = 7'b1001111; 
            4'd2: seg = 7'b0010010;
            4'd3: seg = 7'b0000110;
            4'd4: seg = 7'b1001100;
            4'd5: seg = 7'b0100100;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b0001101;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0000100;
            4'd10: seg = 7'b0001000;
            4'd11: seg = 7'b1100000;
            default: seg = 7'b0000001;
        endcase
    end
    else if(an == 4'b1011) begin
        case(in[11:8])
            4'd0: seg = 7'b0000001;
            4'd1: seg = 7'b1001111; 
            4'd2: seg = 7'b0010010;
            4'd3: seg = 7'b0000110;
            4'd4: seg = 7'b1001100;
            4'd5: seg = 7'b0100100;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b0001101;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0000100;
            4'd10: seg = 7'b0001000;
            4'd11: seg = 7'b1100000;
            default: seg = 7'b0000001;
        endcase
    end
    else if(an == 4'b1101) begin
        case(in[7:4])
            4'd0: seg = 7'b0000001;
            4'd1: seg = 7'b1001111; 
            4'd2: seg = 7'b0010010;
            4'd3: seg = 7'b0000110;
            4'd4: seg = 7'b1001100;
            4'd5: seg = 7'b0100100;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b0001101;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0000100;
            4'd10: seg = 7'b0001000;
            4'd11: seg = 7'b1100000;
            default: seg = 7'b0000001;
        endcase
    end
    else if(an == 4'b1110) begin
        case(in[3:0])
            4'd0: seg = 7'b0000001;
            4'd1: seg = 7'b1001111; 
            4'd2: seg = 7'b0010010;
            4'd3: seg = 7'b0000110;
            4'd4: seg = 7'b1001100;
            4'd5: seg = 7'b0100100;
            4'd6: seg = 7'b0100000;
            4'd7: seg = 7'b0001101;
            4'd8: seg = 7'b0000000;
            4'd9: seg = 7'b0000100;
            4'd10: seg = 7'b0001000;
            4'd11: seg = 7'b1100000;
            default: seg = 7'b0000001;
        endcase
    end
    else seg = 7'b1111111;
end

endmodule

module _1A2B_fpga(sw, CLK100MHZ, btnU, btnC, btnR, LED, an, seg, dp);
input [15:12] sw;
input CLK100MHZ;
input btnU;
input btnC;
input btnR;
output [15:0] LED;
output [3:0] an;
output [0:6] seg;
output dp;

reg [15:0] in;
reg [1:0] state;
parameter s0 = 2'b00;
parameter s1 = 2'b01;
parameter s2 = 2'b10;

wire clk, pb_reset, pb_start, pb_enter;
wire [3:0] quess;
assign clk = CLK100MHZ;
assign pb_reset = btnU;
assign pb_start = btnC;
assign pb_enter = btnR;

wire reset_debounced;
wire reset_one_pulse;
wire rst_n;
debounce reset_db(reset_debounced, pb_reset, clk);
onepulse reset_op(reset_debounced, clk, reset_one_pulse);
assign rst_n = ~reset_one_pulse;

wire start_debounced;
wire start_one_pulse;
debounce start_db(start_debounced, pb_start, clk);
onepulse start_op(start_debounced, clk, start_one_pulse);

wire enter_debounced;
wire enter_one_pulse;
debounce enter_db(enter_debounced, pb_enter, clk);
onepulse enter_op(enter_debounced, clk, enter_one_pulse);

wire [15:0] ans;
LFSR random(clk, rst_n, start_one_pulse, ans);
seven_seg s(clk, rst_n, in, state, an, seg);

assign dp = 1'b1;
assign LED = (state == s0)? 16'd0 : ans;

reg [3:0] A, B, next_A, next_B;
reg [1:0] counter, next_counter;
reg [1:0] next_state;
reg [15:0] next_in, real_in;
always @(posedge clk) begin
    if(!rst_n) begin
        state <= s0;
        counter <= 2'd0;
        A <= 4'd0;
        B <= 4'd0;
    end
    else begin
        state <= next_state;
        counter <= next_counter;
        in = next_in;
        A <= next_A;
        B <= next_B;
    end
end

always @(*) begin
    case(state)
        s0: begin
            next_in = {4'd1, 4'd10, 4'd2, 4'd11};
            next_A = A;
            next_B = B;
            if(start_one_pulse) begin
                next_state = s1;
                next_counter = 2'd0;
            end
            else next_state = s0;
        end
        s1:begin
            case(counter)
                2'b00: begin
                    next_in = {12'd0, sw[15:12]};
                    if(enter_one_pulse) begin
                        next_counter = counter + 2'b01;
                        next_state = s1;
                        real_in[15:12] = sw[15:12];
                        if(sw[15:12] == ans[15:12]) begin
                            next_A = A + 4'd1;
                            next_B = B;
                        end
                        else if(sw[15:12] == ans[11:8]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else if(sw[15:12] == ans[7:4]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else if(sw[15:12] == ans[3:0]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else begin
                            next_A = A;
                            next_B = B;
                        end
                    end
                end
                2'b01: begin
                    next_in = {8'd0, real_in[15:12], sw[15:12]};
                    if(enter_one_pulse) begin
                        next_counter = counter + 2'b01;
                        next_state = s1;
                        real_in[11:8] = sw[15:12];
                        if(sw[15:12] == ans[11:8]) begin
                            next_A = A + 4'd1;
                            next_B = B;
                        end
                        else if(sw[15:12] == ans[15:12]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else if(sw[15:12] == ans[7:4]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else if(sw[15:12] == ans[3:0]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else begin
                            next_A = A;
                            next_B = B;
                        end
                    end
                end
                2'b10: begin
                    next_in = {4'd0, real_in[15:8], sw[15:12]};
                    if(enter_one_pulse) begin
                        next_counter = counter + 2'b01;
                        next_state = s1;
                        real_in[7:4] = sw[15:12];
                        if(sw[15:12] == ans[7:4]) begin
                            next_A = A + 4'd1;
                            next_B = B;
                        end
                        else if(sw[15:12] == ans[15:12]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else if(sw[15:12] == ans[11:8]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else if(sw[15:12] == ans[3:0]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else begin
                            next_A = A;
                            next_B = B;
                        end
                    end
                end
                default: begin
                    next_in = {real_in[15:4], sw[15:12]};
                    if(enter_one_pulse) begin
                        next_counter = counter + 2'b01;
                        next_state = s2;
                        real_in[3:0] = sw[15:12];
                        if(sw[15:12] == ans[3:0]) begin
                            next_A = A + 4'd1;
                            next_B = B;
                        end
                        else if(sw[15:12] == ans[15:12]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else if(sw[15:12] == ans[11:8]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else if(sw[15:12] == ans[7:4]) begin
                            next_A = A;
                            next_B = B + 4'd1;
                        end
                        else begin
                            next_A = A;
                            next_B = B;
                        end
                    end
                end
            endcase
        end
        s2: begin
            next_in = {A, 4'd10, B, 4'd11};
            if(enter_one_pulse) begin
                real_in = 16'd0;
                next_A = 4'd0;
                next_B = 4'd0;
                if(A == 4'd4) next_state = s0;
                else next_state = s1;
            end
            else begin
                next_state = s2;
                next_A = A;
                next_B = B;
            end
        end
    endcase
end
endmodule
