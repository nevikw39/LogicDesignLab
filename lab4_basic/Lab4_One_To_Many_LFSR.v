`timescale 1ns/1ps

module One_TO_Many_LFSR(clk, rst_n, out);
input clk;
input rst_n;
output reg [8-1:0] out;

wire [3-1:0] w;
assign w = out[3:1] ^ {3{out[7]}};

always @(posedge clk) begin
    if (rst_n)
        out <= {out[6:4], w, out[0], out[7]};
    else
        out <= 8'b10111101;
end

endmodule
