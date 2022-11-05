`timescale 1ns/1ps

module multiplier #( parameter N = 4 ) (
    input [N-1:0] a, b,
    output [2*N-1:0] p
);
    assign p = a * b;
endmodule

module SDFF (
    input clk, rst_n, d, scan_in, scan_en,
    output reg q
);
    always @(posedge clk)
        if (rst_n)
            q <= scan_en ? scan_in : d;
        else
            q <= 1'b0;
endmodule

module Scan_Chain_Design (
    input clk, rst_n, scan_in, scan_en,
    output scan_out
);

wire [7:0] p;
wire [6:0] w;

SDFF sdff[7:0]({8{clk}}, {8{rst_n}}, p, {scan_in, w[6:0]}, {8{scan_en}}, {w[6:0], scan_out});
multiplier m(w[6:3], {w[2:0], scan_out}, p);

endmodule

module Many_To_One_LFSR #(parameter N = 8) (
    input clk, rst_n,
    output out
);

reg [N-1:0] dff;

always @(posedge clk) begin
    if (rst_n)
        dff <= {dff[6:0], dff[1] ^ dff[2] ^ dff[3] ^ dff[7]};
    else
        dff <= 8'b10111101;
end

assign out = dff[7];

endmodule

module Built_In_Self_Test(clk, rst_n, scan_en, scan_in, scan_out);
input clk;
input rst_n;
input scan_en;
output scan_in;
output scan_out;

Many_To_One_LFSR fib_lfsr(clk, rst_n, scan_in);
Scan_Chain_Design scd(clk, rst_n, scan_in, scan_en, scan_out);

endmodule
