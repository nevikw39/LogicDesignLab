`timescale 1ns/1ps

module Memory #(
    parameter M = 128,
    parameter N = 8
)
(
    input clk,
    input ren,
    input wen,
    input [6:0] addr,
    input [N-1:0] din,
    output reg [N-1:0] dout
);

reg [N-1:0] mem [M-1:0];

always @(posedge clk) begin
    if (ren) begin
        dout <= mem[addr];
    end
    else if (wen) begin
        dout <= 0;
        mem[addr] <= din;
    end
    else
        dout <= 0;
end

endmodule

module Bank #( parameter N = 8 )(
    input clk,
    input ren,
    input wen,
    input [8:0] raddr,
    input [8:0] waddr,
    input [N-1:0] din,
    output reg [N-1:0] dout
);

reg ra = 0, rb = 0, rc = 0, rd = 0, wa = 0, wb = 0, wc = 0, wd = 0;
reg [8:0] addra = 0, addrb = 0, addrc = 0, addrd = 0;
wire [7:0] outa, outb, outc, outd;
Memory a(clk, ra, wa, addra, din, outa),
       b(clk, rb, wb, addrb, din, outb),
       c(clk, rc, wc, addrc, din, outc),
       d(clk, rd, wd, addrd, din, outd);

wire [1:0] rmem, wmem;
wire [6:0] rmemaddr, wmemaddr;
assign {rmem, rmemaddr} = raddr;
assign {wmem, wmemaddr} = waddr;

always @(posedge clk) begin
    if (ren) begin
        ra <= rmem == 0;
        rb <= rmem == 1;
        rc <= rmem == 2;
        rd <= rmem == 3;
        case (rmem)
            0: addra <= rmemaddr;
            1: addrb <= rmemaddr;
            2: addrc <= rmemaddr;
            3: addrd <= rmemaddr;
        endcase
    end
    if (wen) begin
        if (wmem == rmem)
            dout <= 0;
        else begin
            wa <= wmem == 0;
            wb <= wmem == 1;
            wc <= wmem == 2;
            wd <= wmem == 3;
            case (wmem)
                0: begin
                    addra <= wmemaddr;
                    dout <= outa;
                end
                01: begin
                    addrb <= wmemaddr;
                    dout <= outb;
                end
                2: begin
                    addrc <= wmemaddr;
                    dout <= outc;
                end
                3: begin
                    addrd <= wmemaddr;
                    dout <= outd;
                end
            endcase
        end
    end
    else
        dout <= 0;
end

endmodule

module Multi_Bank_Memory (clk, ren, wen, waddr, raddr, din, dout);
input clk;
input ren, wen;
input [11-1:0] waddr;
input [11-1:0] raddr;
input [8-1:0] din;
output reg [8-1:0] dout;

reg ra = 0, rb = 0, rc = 0, rd = 0, wa = 0, wb = 0, wc = 0, wd = 0;
wire [7:0] outa, outb, outc, outd;
Bank a(clk, ra, wa, raddr[8:0], waddr[8:0], din, outa),
     b(clk, rb, wb, raddr[8:0], waddr[8:0], din, outb),
     c(clk, rc, wc, raddr[8:0], waddr[8:0], din, outc),
     d(clk, rd, wd, raddr[8:0], waddr[8:0], din, outd);

assign rbank = raddr[10:9], wbank = waddr[10:9];

always @(posedge clk) begin
    if (ren) begin
        ra <= rbank == 0;
        rb <= rbank == 1;
        rc <= rbank == 2;
        rd <= rbank == 3;
    end
    if (wen) begin
        if (wbank == rbank)
            dout <= 0;
        else begin
            wa <= wbank == 0;
            wb <= wbank == 1;
            wc <= wbank == 2;
            wd <= wbank == 3;
        end
    end
    else
        dout <= 0;
end

endmodule
