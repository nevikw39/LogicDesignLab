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

module Scan_Chain_Design(clk, rst_n, scan_in, scan_en, scan_out);
input clk;
input rst_n;
input scan_in;
input scan_en;
output scan_out;

wire [7:0] p;
wire [6:0] w;

// SDFF sdff0(clk, rst_n, p[0], scan_in, w[0]),
//      sdff1(clk, rst_n, p[1], w[0], w[1]),
//      sdff2(clk, rst_n, p[2], w[1], w[2]);
// ...

SDFF sdff[7:0]({8{clk}}, {8{rst_n}}, p, {scan_in, w[6:0]}, {8{scan_en}}, {w[6:0], scan_out});
multiplier m(w[6:3], {w[2:0], scan_out}, p);

endmodule
