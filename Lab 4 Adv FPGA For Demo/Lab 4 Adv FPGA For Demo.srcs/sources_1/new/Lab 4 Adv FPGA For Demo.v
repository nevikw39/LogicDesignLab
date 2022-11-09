`timescale 1ns/1ps

module FPGA(/*sw,enter,start,rst_n,Led,seg,AN,clk*/ sw, CLK100MHZ, btnU, btnC, btnR, LED, an, seg);
//input [3:0]sw;
input [15:12] sw;
input CLK100MHZ;
input btnU;
input btnC;
input btnR;
output reg [15:0] LED;
output reg [3:0] an;
/*input*/  wire enter,start,rst_n,clk;
///*output*/ reg [15:0]Led;
output reg [6:0]seg;
///*output*/ reg [3:0]AN;

assign clk = CLK100MHZ;
assign rst_n = btnU;
assign start = btnC;
assign enter = btnR;

reg [2:0] state,nextstate;
reg correct;
reg [3:0] num1,num2,num3,num4,nextnum1,nextnum2,nextnum3,nextnum4,value;
reg [3:0] ans [3:0];
reg [3:0] nextans [3:0];
reg [3:0] a,b,nexta,nextb;//1a2b
reg cnt2;

parameter S0 = 3'b000;//initial
parameter S1 = 3'b001;//0000
parameter S2 = 3'b010;//00x0
parameter S3 = 3'b011;//0xx0
parameter S4 = 3'b100;//xxx0
parameter S5 = 3'b101;//?a?b

wire one_enter,one_start,one_rst_n,de_enter,de_start,de_rst_n;
wire clk25,clk17;
wire [3:0] tmpnum1,tmpnum2,tmpnum3,tmpnum4,tmp_a,tmp_b;

//onepulse and debounce
debounce E1(enter, de_enter, clk);
debounce SS1(start, de_start, clk);
debounce R1(rst_n, de_rst_n, clk);

onepulse E2(de_enter, clk, one_enter);
onepulse SS2(de_start, clk, one_start);
onepulse R2(de_rst_n, clk, one_rst_n);

//divided clk
clk_divider_17 c17(clk,clk17,one_rst_n);
clk_divider_25 c25(clk,clk25,one_rst_n);

//state
always @(posedge clk) begin
    if(one_rst_n) begin
        state <= S0;
    end
    else begin
        state <= nextstate;
    end
end


always @(*) begin
    case(state)
        S0:
            if(one_start) nextstate = S1;
            else nextstate = S0;
        S1:
            if(one_enter) nextstate = S2;
            else nextstate = S1;
        S2:
            if(one_enter) nextstate = S3;
            else nextstate = S2;
        S3:
            if(one_enter) nextstate = S4;
            else nextstate = S3;
        S4:
            if(one_enter) nextstate = S5;
            else nextstate = S4;
        S5:
            if(one_enter && correct) nextstate = S0;
            else if(one_enter && !correct)nextstate = S1;
            else nextstate = S5;
    endcase
end

//game
One_TO_Many_LFSR_1 o1(clk, one_rst_n, tmpnum1);
One_TO_Many_LFSR_2 o2(clk, one_rst_n, tmpnum2);
One_TO_Many_LFSR_3 o3(clk, one_rst_n, tmpnum3);
One_TO_Many_LFSR_4 o4(clk, one_rst_n, tmpnum4);

always @(posedge clk) begin
    if(one_rst_n) begin
        num1 <= 4'd0;
        num2 <= 4'd0;
        num3 <= 4'd0;
        num4 <= 4'd0;
    end
    else begin
        num1 <= nextnum1;
        num2 <= nextnum2;
        num3 <= nextnum3;
        num4 <= nextnum4;
    end
end

always @(*) begin
    if(state == S0) begin
        nextnum1 = tmpnum1;
        nextnum2 = tmpnum2;
        nextnum3 = tmpnum3;
        nextnum4 = tmpnum4;
        
        if(nextnum4 == nextnum3 || nextnum4 == nextnum2 || nextnum4 == nextnum1) nextnum4 = 8;
                
        if(nextnum3 == nextnum2 || nextnum3 == nextnum1) nextnum3 = 9;
                
        if(nextnum1 == nextnum2) nextnum1 = 7;
    end
    else begin
        nextnum1 = num1;
        nextnum2 = num2;
        nextnum3 = num3;
        nextnum4 = num4;
    end
end

always @(*) begin
    case(state)
        S0: begin
            LED = 16'd0;
        end 
        S1: begin //led correct finish a,b
            LED[15:12] = num4;
            LED[11:8] = num3;
            LED[7:4] = num2;
            LED[3:0] = num1;
            correct = 0;
        end
        S2: begin
            LED[15:12] = num4;
            LED[11:8] = num3;
            LED[7:4] = num2;
            LED[3:0] = num1;
        end
        S3: begin
            LED[15:12] = num4;
            LED[11:8] = num3;
            LED[7:4] = num2;
            LED[3:0] = num1;
        end
        S4:begin
            LED[15:12] = num4;
            LED[11:8] = num3;
            LED[7:4] = num2;
            LED[3:0] = num1;
        end 
        S5:
            if(a == 4 && b == 0) correct = 1;
            else correct = 0;
    endcase
end

always @(posedge clk) begin
    if(one_rst_n) begin
        a <= 0;
        b <= 0;
    end
    else begin
        a <= nexta;
        b <= nextb;
    end
end

always @(*) begin
    if(state == S5) begin
        nexta = tmp_a;
        nextb = tmp_b;
    end
    else begin
        nexta = a;
        nextb = b;
    end
end

always @(posedge clk) begin
    if(one_rst_n) begin
        ans[3] <= 0;
        ans[2] <= 0;
        ans[1] <= 0;
        ans[0] <= 0;
    end
    else begin
        ans[3] <= nextans[3];
        ans[2] <= nextans[2];
        ans[1] <= nextans[1];
        ans[0] <= nextans[0];
    end
end

always @(*) begin
    case(state)
        S0:
        ;
        S1:begin
            if(one_enter) nextans[3] = sw;
            else nextans[3] = 0;

            nextans[2] = ans[2];
            nextans[1] = ans[1];
            nextans[0] = ans[0];
        end
        S2:begin
            if(one_enter) nextans[2] = sw;
            else nextans[2] = ans[2];

            nextans[3] = ans[3];
            nextans[1] = ans[1];
            nextans[0] = ans[0];
        end
        S3:begin
            if(one_enter) nextans[1] = sw;
            else nextans[1] = ans[1];

            nextans[2] = ans[2];
            nextans[3] = ans[3];
            nextans[0] = ans[0];
        end
        S4:begin
            if(one_enter) nextans[0] = sw;
            else nextans[0] = ans[0];

            nextans[2] = ans[2];
            nextans[1] = ans[1];
            nextans[3] = ans[3];
        end
        S5:begin
        end
    endcase
end

play1A2B play(ans[3],ans[2],ans[1],ans[0],num4,num3,num2,num1,tmp_a,tmp_b);

//display
reg [1:0] cnt3;

always @(posedge clk ) begin
    if(one_rst_n) cnt3 <= 0;
    else begin
        if(!clk17) cnt3 <= cnt3;
        else cnt3 <= cnt3 + 1;
    end
end

//7 seg
always @(posedge clk) begin
    case(cnt3)
            2'd0: begin
                /*AN*/ an <= 4'b1110;
                if(state == S0 || state == S5) begin
                    value <= 4'd11;//b
                end
                else begin
                    if(cnt2) value <= sw;
                    else value <= 4'd12;
                end
            end
            2'd1: begin
                /*AN*/ an <= 4'b1101;
                if(state == S0) begin
                    value <= 4'd2;
                end
                else if(state == S5) begin
                    value <= b;
                end
                else if(state == S1) begin
                    value <= 4'd0;
                end
                else if(state == S2) begin
                    value <= ans[3];
                end
                else if(state == S3) begin
                    value <= ans[2];
                end
                else if(state == S4) begin
                    value <= ans[1];
                end
            end
            2'd2: begin
                /*AN*/ an <= 4'b1011;
                if(state == S0 || state == S5) begin
                    value <= 4'd10;//A
                end
                else if(state == S1 || state == S2) begin
                    value <= 4'd0;
                end
                else if(state == S3) begin
                    value <= ans[3];
                end
                else if(state == S4) begin
                    value <= ans[2];
                end
            end
            2'd3: begin
                /*AN*/ an <= 4'b0111;
                if(state == S0) begin
                    value <= 4'd1;
                end
                else if(state == S1 || state == S2 || state == S3) begin
                    value <= 4'd0;
                end
                else if(state == S4) begin
                    value <= ans[3];
                end
                else if(state == S5) begin
                    value <= a;
                end
            end
        endcase        
end

always @(*) begin
    case (value)
        4'd0: seg = 7'b100_0000;
        4'd1: seg = 7'b111_1001;
        4'd2: seg = 7'b010_0100;
        4'd3: seg = 7'b011_0000;
        4'd4: seg = 7'b001_1001;
        4'd5: seg = 7'b001_0010;
        4'd6: seg = 7'b000_0010;
        4'd7: seg = 7'b111_1000;
        4'd8: seg = 7'b000_0000;
        4'd9: seg = 7'b001_0000;
        4'd10: seg = 7'b000_1000;
        4'd11: seg = 7'b000_0011;
        4'd12: seg = 7'b111_1111;
   endcase
end

always @(posedge clk) begin
    if(clk25) cnt2 <= cnt2 + 1;
end

endmodule

module play1A2B(ans_1,ans_2,ans_3,ans_4,g_1,g_2,g_3,g_4,a,b);
input [3:0] ans_1,ans_2,ans_3,ans_4,g_1,g_2,g_3,g_4;
output reg [3:0] a,b;

//a
always @(*) begin
    a = 0;

    if(ans_1 == g_1) a = a + 1;

    if(ans_2 == g_2) a = a + 1;

    if(ans_3 == g_3) a = a + 1;

    if(ans_4 == g_4) a = a + 1;
end

//b
always @(*) begin
    b = 0;

    if(ans_2 == g_1 || ans_3 == g_1 || ans_4 == g_1) b = b + 1;

    if(ans_1 == g_2 || ans_3 == g_2 || ans_4 == g_2) b = b + 1;

    if(ans_1 == g_3 || ans_2 == g_3 || ans_4 == g_3) b = b + 1;

    if(ans_1 == g_4 || ans_2 == g_4 || ans_3 == g_4) b = b + 1;
end

endmodule

module clk_divider_25(clk,clk_div,rst_n);//25
input clk,rst_n;
output clk_div;

reg [24:0] cnt;

always @(posedge clk) begin
    if(rst_n || cnt == 16777216) cnt <= 0;
    else cnt <= cnt + 1;
end

assign clk_div = (cnt == 16777216)?1'b1:1'b0;

endmodule

module clk_divider_17(clk,clk_div,rst_n);//17
input clk,rst_n;
output clk_div;

reg [16:0] cnt;

always @(posedge clk) begin
    if(rst_n || cnt == 65536) cnt <= 0;
    else cnt <= cnt + 1;
end

assign clk_div = (cnt == 65536)?1'b1:1'b0;

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

module debounce (pb, pb_debounced, clk);
output pb_debounced; // signal of a pushbutton after being debounced
input pb; // signal from a pushbutton
input clk;

reg [3:0] DFF; // use shift_reg to filter pushbutton bounce

always @(posedge clk)
begin
    DFF[3:1] <= DFF[2:0];
    DFF[0] <= pb;
end

assign pb_debounced = ((DFF == 4'b1111) ? 1'b1 : 1'b0);

endmodule

module One_TO_Many_LFSR_1(clk, rst_n, dout);//generate random number
input clk;
input rst_n;
output wire [2:0] dout;

reg [7:0] out;
reg [2:0] cout;

always @(posedge clk) begin
    if(rst_n) begin
        out <= 8'b10111101;
    end
    else begin
        out[0] <= out[7];
        out[1] <= out[0];
        out[2] <= out[1] ^ out[7];
        out[3] <= out[2] ^ out[7];
        out[4] <= out[3] ^ out[7];
        out[7:5] <= out[6:4];
    end
end

always@(*)begin
    if(out[4:2] > 6) cout[2:0] = out[4:2] - 6;
    else cout[2:0] = out[4:2];
end

assign dout[2:0] = cout[2:0];

endmodule

module One_TO_Many_LFSR_2(clk, rst_n, dout);//generate random number
input clk;
input rst_n;
output wire [2:0] dout;

reg [7:0] out;
reg [2:0] cout;

always @(posedge clk) begin
    if(rst_n) begin
        out <= 8'b10111101;
    end
    else begin
        out[0] <= out[7];
        out[1] <= out[0];
        out[2] <= out[1] ^ out[7];
        out[3] <= out[2] ^ out[7];
        out[4] <= out[3] ^ out[7];
        out[7:5] <= out[6:4];
    end
end

always@(*)begin
    if(out[5:3] > 6) cout[2:0] = out[5:3] - 6;
    else cout[2:0] = out[5:3];
end

assign dout[2:0] = cout[2:0];

endmodule

module One_TO_Many_LFSR_3(clk, rst_n, dout);//generate random number
input clk;
input rst_n;
output wire [2:0] dout;

reg [7:0] out;
reg [2:0] cout;

always @(posedge clk) begin
    if(rst_n) begin
        out <= 8'b10111101;
    end
    else begin
        out[0] <= out[7];
        out[1] <= out[0];
        out[2] <= out[1] ^ out[7];
        out[3] <= out[2] ^ out[7];
        out[4] <= out[3] ^ out[7];
        out[7:5] <= out[6:4];
    end
end

always@(*)begin
    if(out[3:1] > 6) cout[2:0] = out[3:1] - 6;
    else cout[2:0] = out[3:1];
end

assign dout[2:0] = cout[2:0];

endmodule

module One_TO_Many_LFSR_4(clk, rst_n, dout);//generate random number
input clk;
input rst_n;
output wire [2:0] dout;

reg [7:0] out;
reg [2:0] cout;

always @(posedge clk) begin
    if(rst_n) begin
        out <= 8'b10111101;
    end
    else begin
        out[0] <= out[7];
        out[1] <= out[0];
        out[2] <= out[1] ^ out[7];
        out[3] <= out[2] ^ out[7];
        out[4] <= out[3] ^ out[7];
        out[7:5] <= out[6:4];
    end
end

always@(*)begin
    if(out[6:4] > 6) cout[2:0] = out[6:4] - 6;
    else cout[2:0] = out[6:4];
end

assign dout[2:0] = cout[2:0];

endmodule