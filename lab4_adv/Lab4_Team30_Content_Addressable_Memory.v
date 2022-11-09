`timescale 1ns/1ps

module Priority_Encoder(pre_encoder, next_dout, next_hit);
input [15:0] pre_encoder;
output reg [3:0] next_dout;
output reg next_hit;

always@(*)begin
    casex(pre_encoder)    
        16'b1000000000000000:begin
            next_dout = 4'b1111;
            next_hit = 1'b1;
        end
        16'bx100000000000000:begin
            next_dout = 4'b1110;
            next_hit = 1'b1;
        end
        16'bxx10000000000000:begin
            next_dout = 4'b1101;
            next_hit = 1'b1;
        end
        16'bxxx1000000000000:begin
            next_dout = 4'b1100;
            next_hit = 1'b1;
        end
        16'bxxxx100000000000:begin
            next_dout = 4'b1011;
            next_hit = 1'b1;
        end
        16'bxxxxx10000000000:begin
            next_dout = 4'b1010;
            next_hit = 1'b1;
        end
        16'bxxxxxx1000000000:begin
            next_dout = 4'b1001;
            next_hit = 1'b1;
        end
        16'bxxxxxxx100000000:begin
            next_dout = 4'b1000;
            next_hit = 1'b1;
        end
        16'bxxxxxxxx10000000:begin
            next_dout = 4'b0111;
            next_hit = 1'b1;
        end
        16'bxxxxxxxxx1000000:begin
            next_dout = 4'b0110;
            next_hit = 1'b1;
        end
        16'bxxxxxxxxxx100000:begin
            next_dout = 4'b0101;
            next_hit = 1'b1;
        end
        16'bxxxxxxxxxxx10000:begin
            next_dout = 4'b0100;
            next_hit = 1'b1;
        end
        16'bxxxxxxxxxxxx1000:begin
            next_dout = 4'b0011;
            next_hit = 1'b1;
        end
        16'bxxxxxxxxxxxxx100:begin
            next_dout = 4'b0010;
            next_hit = 1'b1;
        end
        16'bxxxxxxxxxxxxxx10:begin
            next_dout = 4'b0001;
            next_hit = 1'b1;
        end
        16'bxxxxxxxxxxxxxxx1:begin
            next_dout = 4'b0000;
            next_hit = 1'b1;
        end
        16'b0000000000000000:begin
            next_dout = 4'd0;
            next_hit = 1'b0;
        end
    endcase
end
endmodule

module Comparator(a, b, out);
input [7:0] a, b;
output out;
assign out = (a == b) ? 1'b1 : 1'b0;
endmodule

module Content_Addressable_Memory(clk, wen, ren, din, addr, dout, hit);
input clk;
input wen, ren;
input [7:0] din;
input [3:0] addr;
output reg [3:0] dout;
output reg hit;

wire [3:0] next_dout;
wire next_hit;

reg [7:0]CAM[15:0];
wire [15:0] pre_encoder;

always@(posedge clk)begin
    if(ren) begin
        dout <= next_dout;
        hit <= next_hit;
    end
    else if(wen) begin
        CAM[addr] <= din;
        dout <= 4'd0;
        hit <= 1'b0;
    end
    else begin
        dout <= 4'd0;
        hit <= 1'd0;
    end
end

Comparator a(din, CAM[0], pre_encoder[0]);
Comparator b(din, CAM[1], pre_encoder[1]);
Comparator c(din, CAM[2], pre_encoder[2]);
Comparator d(din, CAM[3], pre_encoder[3]);
Comparator e(din, CAM[4], pre_encoder[4]);
Comparator f(din, CAM[5], pre_encoder[5]);
Comparator g(din, CAM[6], pre_encoder[6]);
Comparator h(din, CAM[7], pre_encoder[7]);
Comparator i(din, CAM[8], pre_encoder[8]);
Comparator j(din, CAM[9], pre_encoder[9]);
Comparator k(din, CAM[10], pre_encoder[10]);
Comparator l(din, CAM[11], pre_encoder[11]);
Comparator m(din, CAM[12], pre_encoder[12]);
Comparator n(din, CAM[13], pre_encoder[13]);
Comparator o(din, CAM[14], pre_encoder[14]);
Comparator p(din, CAM[15], pre_encoder[15]);
Priority_Encoder q(pre_encoder, next_dout, next_hit);

endmodule
