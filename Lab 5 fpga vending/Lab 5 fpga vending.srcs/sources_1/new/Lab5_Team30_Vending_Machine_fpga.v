`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/23 15:47:27
// Design Name: 
// Module Name: Lab5_Team30_Vending_Machine_fpga
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


module Lab5_Team30_Vending_Machine_fpga(PS2Clk, PS2Data, CLK100MHZ, btnL, btnC, btnR, btnU, btnD, an, seg, LED);
input CLK100MHZ, btnL, btnC, btnR, btnU, btnD;
inout PS2Clk, PS2Data;
output [3:0] an;
output [0:6] seg;
wire clk, five, ten, fifty, rst, cancel;
assign clk = CLK100MHZ,
       five = btnL,
       ten = btnC,
       fifty = btnR,
       rst = btnU,
       cancel = btnD;
wire five_debounced, ten_debounced, fifty_debounced, rst_debounced, cancel_debounced; 
wire five_one_pulse, ten_one_pulse, fifty_one_pulse, rst_one_pulse, cancel_one_pulse;
debounce df(five, clk, five_debounced);
debounce dt(ten, clk, ten_debounced);
debounce dft(fifty, clk, fifty_debounced);
debounce dr(rst, clk, rst_debounced);
debounce dc(cancel, clk, cancel_debounced);

onepulse of(five_debounced, clk, five_one_pulse);
onepulse ot(ten_debounced, clk, ten_one_pulse);
onepulse oft(fifty_debounced, clk, fifty_one_pulse);
onepulse onr(rst_debounced, clk, rst_one_pulse);
onepulse oc(cancel_debounced, clk, cancel_one_pulse);


parameter INSERT = 0,
          MAKECHANGE = 1;
          
reg state, next_state;
reg one_sec;

reg [26:0] one_sec_counter;
wire [26:0] next_one_counter;
wire next_one_sec;
always @(posedge clk) begin
    if(state == MAKECHANGE) begin
        one_sec_counter <= next_one_counter;
        one_sec <= next_one_sec;
    end
    else begin
        one_sec_counter <= 27'd0;
        one_sec <= 1'd0;
    end
end
assign next_one_counter = (one_sec_counter == 27'd99999999)? 27'd0 : one_sec_counter + 27'd1;
assign next_one_sec = (one_sec_counter == 27'd99999999)? 1'b1 : 1'b0;

reg [7:0] next_money, money;
always @(posedge clk) begin
    if(rst_one_pulse) begin
        money <= 8'd0;
        state <= INSERT;
    end
    else begin
        state <= next_state;
        if(state == MAKECHANGE) begin
            if(one_sec) money <= next_money;
            else money <= money;
        end
        else money <= next_money;
    end
end


wire key_valid;
wire [8:0] last_change;
wire [511:0] key_down;
KeyboardDecoder kd (
        .key_down(key_down),
        .last_change(last_change),
        .key_valid(key_valid),
        .PS2_DATA(PS2Data),
        .PS2_CLK(PS2Clk),
        .rst(rst__one_pulse),
        .clk(CLK100MHZ)
    );

always @(*) begin
    case(state)
        INSERT: begin
            if(five_one_pulse) begin
                if(money + 8'd5 <= 8'd100) next_money = money + 8'd5;
                else next_money = money;
                next_state = INSERT;
            end
            else if (ten_one_pulse) begin
                if(money + 8'd10 <= 8'd100) next_money = money + 8'd10;
                else next_money = money;
                next_state = INSERT;
            end
            else if (fifty_one_pulse) begin
                if(money + 8'd50 <= 8'd100) next_money = money + 8'd50;
                else next_money = money;
                next_state = INSERT;
            end
            else if (cancel_one_pulse) begin
                next_money = money;
                if(money == 8'd0) next_state = INSERT;
                else next_state = MAKECHANGE;
            end
            else if (key_valid && key_down[last_change] == 1'b1) begin
                if(last_change == 9'h1C) begin
                    if(money >= 8'd80) begin
                        next_money = money - 8'd80;
                        next_state = MAKECHANGE;
                    end
                    else begin
                        next_money = money;
                        next_state = INSERT;
                    end
                end
                else if(last_change == 9'h1B) begin
                    if(money >= 8'd30) begin
                        next_money = money - 8'd30;
                        next_state = MAKECHANGE;
                    end
                    else begin
                        next_money = money;
                        next_state = INSERT;
                    end
                end
                else if(last_change == 9'h23) begin
                    if(money >= 8'd25) begin
                        next_money = money - 8'd25;
                        next_state = MAKECHANGE;
                    end
                    else begin
                        next_money = money;
                        next_state = INSERT;
                    end
                end
                else if(last_change == 9'h2B) begin
                    if(money >= 8'd20) begin
                        next_money = money - 8'd20;
                        next_state = MAKECHANGE;
                    end
                    else begin
                        next_money = money;
                        next_state = INSERT;
                    end
                end
                else begin
                    next_money = money;
                    next_state = INSERT;
                end
            end
            else begin
                next_money = money;
                next_state = INSERT;
            end
        end
        MAKECHANGE: begin
            if(money > 0) begin
                next_money = money - 8'd5;
                next_state = MAKECHANGE;
            end
            else begin
                next_money = 8'd0;
                next_state = INSERT;
            end
        end
    endcase
end

sevensegment s(clk, rst_one_pulse, money, seg, an);

output reg [3:0] LED;
always @(*) begin
    if(state == INSERT) begin
        if(money >= 8'd80) LED = 4'b1111;
        else if(money >= 8'd30) LED = 4'b0111;
        else if(money >= 8'd25) LED = 4'b0011;
        else if(money >= 8'd20) LED = 4'b0001;
        else LED = 4'b0000;
    end
    else LED = 4'b0000;
end

endmodule

module sevensegment(clk, rst, money, seg, an);
input clk, rst;
input [7:0] money;
output reg [0:6] seg;
output reg [3:0] an;

reg [18:0] clk_div;
reg [7:0] display;
wire [1:0] active;
always @(posedge clk) begin
    if(rst) clk_div <= 19'd0;
    else clk_div <= clk_div + 19'd1;
end
assign active = clk_div[18:17];
always @(*) begin
    case(active)
        2'b00 : an = 4'b1110;
        2'b01 : an = 4'b1101;
        2'b10 : an = 4'b1011;
        2'b11 : an = 4'b0111;
    endcase
end

always @(*) begin
    case(an)
        4'b1110: begin
            if(money == 8'd100) display = 8'd0;
            else if(money >= 8'd90) display = money - 8'd90;
            else if(money >= 8'd80) display = money - 8'd80;
            else if(money >= 8'd70) display = money - 8'd70;
            else if(money >= 8'd60) display = money - 8'd60;
            else if(money >= 8'd50) display = money - 8'd50;
            else if(money >= 8'd40) display = money - 8'd40;
            else if(money >= 8'd30) display = money - 8'd30;
            else if(money >= 8'd20) display = money - 8'd20;
            else if(money >= 8'd10) display = money - 8'd10;
            else display = money;
        end
        4'b1101: begin
            if(money == 7'd100) display = 8'd0;
            else if(money >= 7'd90) display = 8'd9;
            else if(money >= 7'd80) display = 8'd8;
            else if(money >= 7'd70) display = 8'd7;
            else if(money >= 7'd60) display = 8'd6;
            else if(money >= 7'd50) display = 8'd5;
            else if(money >= 7'd40) display = 8'd4;
            else if(money >= 7'd30) display = 8'd3;
            else if(money >= 7'd20) display = 8'd2;
            else if(money >= 7'd10) display = 8'd1;
            else display = 8'd10;
        end
        4'b1011: begin
            if(money == 7'd100) display = 8'd1;
            else display = 8'd10;
        end
        4'b0111: begin
            display = 8'd10;
        end
        default : begin
            display = 8'd10;
        end
    endcase
end

always @(*) begin
    case(display)
        8'd9: seg = 7'b0000100;
        8'd8: seg = 7'b0000000;
        8'd7: seg = 7'b0001111;
        8'd6: seg = 7'b0100000;
        8'd5: seg = 7'b0100100;
        8'd4: seg = 7'b1001100;
        8'd3: seg = 7'b0000110;
        8'd2: seg = 7'b0010010;
        8'd1: seg = 7'b1001111;
        8'd0: seg = 7'b0000001;
        default : seg = 7'b1111111;
    endcase
end

endmodule

module debounce (pb, clk, pb_debounced);
input pb;
input clk; 
output pb_debounced;

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