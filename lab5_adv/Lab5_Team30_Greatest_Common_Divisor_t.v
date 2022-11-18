`timescale 1ns/1ps

module Greatest_Common_Divisor_t;
reg clk = 1'b0, rst_n, start;
reg [15:0] a, b, g;
wire done;
wire [15:0] gcd;

// specify duration of a clock cycle.
localparam cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Greatest_Common_Divisor GCD(clk, rst_n, start, a, b, done, gcd);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
initial begin
    $dumpfile("gcd.vcd");
    $dumpvars("+all");
end

integer f, eof;

initial begin
    rst_n = 1'b0;
    start = 1'b0;
    eof = 0;
    f = $fopen("gcd.txt", "r");
    if (!f) begin
        $display("Open file failed!!\n");
        $finish;
    end
    while (~eof) begin
        @(negedge clk)
        rst_n = 1'b1;
        eof = $fscanf(f, "%d%d%d", a, b, g);
        start = 1'b1;
        @(negedge clk)
        a = 16'bx;
        b = 16'bx;
        @(done) #1
        if (g != gcd) begin
            $display("WA!!\na = %d, b = %d; expected: %d, got: %d", a, b, g, gcd);
            $finish;
        end
        @(!done);
    end

    @(negedge clk)
    $display("AC!!");
    $finish;
end

endmodule
