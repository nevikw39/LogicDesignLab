`timescale 1ns/1ps


module FIFO_8(
    input clk,
    input rst_n,
    input wen,
    input ren,
    input [8-1:0] din,
    output reg [8-1:0] dout,
    output reg error
);

reg[7:0] queue[8:0];
reg[3:0] front, back;

wire[3:0] next_front, next_back;
assign next_front = front != 8 ? front + 1 : 0,
       next_back = back != 8 ? back + 1 : 0;
assign full = next_back == front,
       empty = front == back;

always @(posedge clk) begin
    if (rst_n) begin
        if (ren) begin
            if (empty) begin
                error <= 1;
                dout <= 8'bxxxxxxxx;
            end
            else begin
                error <= 0;
                dout <= queue[next_front];
                front <= next_front;
            end
        end
        else if (wen) begin
            if (full) begin
                error <= 1;
                dout <= 8'bxxxxxxxx;
            end
            else begin
                error <= 0;
                dout <= 8'bxxxxxxxx;
                queue[next_back] <= din;
                back <= next_back;
            end
        end
        else begin
            error <= 0;
            dout <= 8'bxxxxxxxx;
        end
     end
     else begin
        front <= 0;
        back <= 0;
        dout <= 0;
        error <= 0;
     end
end

endmodule

module Round_Robin_FIFO_Arbiter(clk, rst_n, wen, a, b, c, d, dout, valid);
input clk;
input rst_n;
input [4-1:0] wen;
input [8-1:0] a, b, c, d;
output reg [8-1:0] dout;
output reg valid;

reg ra = 0, rb = 0, rc = 0, rd = 0;
wire [7:0] outa, outb, outc, outd;
wire erra, errb, errc, errd;
FIFO_8 qa(clk, rst_n, wen[0], ra, a, outa, erra),
       qb(clk, rst_n, wen[1], rb, b, outb, errb),
       qc(clk, rst_n, wen[2], rc, c, outc, errc),
       qd(clk, rst_n, wen[3], rd, d, outd, errd);

reg [1:0] cnt; // not init so it will be xx at begin
reg [3:0] dwen;
always @(posedge clk)
    if (rst_n) begin
        cnt <= cnt + 1;
        dwen <= wen;
    end
    else begin
        cnt <= 0;
        dwen <= 4'b1111;
    end

always @(*) begin
    ra = cnt == 0 && !wen[0];
    rb = cnt == 1 && !wen[1];
    rc = cnt == 2 && !wen[2];
    rd = cnt == 3 && !wen[3];
    case (cnt ? cnt - 1 : 3)
        0: begin
            if (erra || dwen[0]) begin
                valid = 0;
                dout = 0;
            end
            else begin
                valid = 1;
                dout = outa;
            end
        end
        1: begin
            if (errb || dwen[1]) begin
                valid = 0;
                dout = 0;
            end
            else begin
                valid = 1;
                dout = outb;
            end
        end
        2: begin
            if (errc || dwen[2]) begin
                valid = 0;
                dout = 0;
            end
            else begin
                valid = 1;
                dout = outc;
            end
        end
        3: begin
            if (errd || dwen[3]) begin
                valid = 0;
                dout = 0;
            end
            else begin
                valid = 1;
                dout = outd;
            end
        end
    endcase
end

endmodule
