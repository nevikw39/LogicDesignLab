`timescale 1ns/1ps

module Sliding_Window_Sequence_Detector_t;
reg clk = 0, rst_n, in;
wire out;

// specify duration of a clock cycle.
localparam cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Sliding_Window_Sequence_Detector swsd(clk, rst_n, in, out);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
initial begin
    $dumpfile("swsd.vcd");
    $dumpvars("+all");
end

reg [1:0] r;

integer f, eof, i;

initial begin
    rst_n = 1'b0;
    eof = 0;
    f = $fopen("swsd_sample_0.txt", "r");
    if (!f) begin
        $display("Open file failed!!\n");
        $finish;
    end
    while (~eof)
        @(negedge clk) begin
        rst_n = 1'b1;
        eof = $fscanf(f, "%b", in);
    end

    @(negedge clk)
    rst_n = 1'b0;
    eof = 0;
    f = $fopen("swsd_sample_1.txt", "r");
    if (!f) begin
        $display("Open file failed!!\n");
        $finish;
    end
    while (~eof) begin
        @(negedge clk)
        rst_n = 1'b1;
        eof = $fscanf(f, "%b", in);
    end

    @(negedge clk)
    rst_n = 1'b0;
    f = $fopen("swsd.txt", "r");
    if (!f) begin
        $display("Open file failed!!\n");
        $finish;
    end
    r = 2'b0;
    @(negedge clk)
    for (i = 0; i < 1 << 16; i = i + 1) begin
        $write(".");
        rst_n = 1'b1;
        $fscanf(f, "%b", in);
        #1
        if (out != r[0]) begin
            $display("\nWA!!\nline %d (falling): expect %b, got %b", i, r[0], out);
            $finish;
        end
        $fscanf(f, "%b", r);
        @(posedge clk) #1
        if (out != r[1]) begin
            $display("\nWA!!\nline %d (raising): expect %b, got %b", i, r[1], out);
            $finish;
        end
    end

    @(negedge clk)
    $display("\nAC!!");
    $finish;
end

endmodule
