`timescale 1ns/1ps

module Booth_Multiplier_4bit_t;
reg clk = 1'b0, rst_n, start;
reg signed [3:0] a, b;
reg signed [7:0] prod;
wire signed [7:0] p;

// specify duration of a clock cycle.
localparam cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Booth_Multiplier_4bit bm(clk, rst_n, start, a, b, p);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
initial begin
    $dumpfile("bm.vcd");
    $dumpvars("+all");
end

integer f, eof;

initial begin
    rst_n = 1'b0;
    start = 1'b0;
    eof = 0;
    f = $fopen("bm.txt", "r");
    if (!f) begin
        $display("Open file failed!!\n");
        $finish;
    end
    repeat (256) begin
        @(negedge clk)
        rst_n = 1'b1;
        eof = $fscanf(f, "%d%d%d", a, b, prod);
        start = 1'b1;
        repeat(4) begin
            @(negedge clk)
            a = 4'bx;
            b = 4'bx;
            start = 1'b0;
        end
        @(negedge clk)
        if (p != prod) begin
            $display("WA!!\na = %d, b = %d; expected: %d, got: %d", a, b, prod, p);
            $finish;
        end
        @(negedge clk);
    end

    @(negedge clk)
    $display("AC!!");
    $finish;
end

endmodule
