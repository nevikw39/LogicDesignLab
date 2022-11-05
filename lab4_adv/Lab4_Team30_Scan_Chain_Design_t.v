`timescale 1ns/1ps

module Scan_Chain_Design_t;
reg clk = 0, rst_n = 0, scan_en = 0;
wire scan_in, scan_out;

reg [7:0] ab, p;

assign scan_in = ab[0];

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Scan_Chain_Design scd(clk, rst_n, scan_in, scan_en, scan_out);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
initial begin
    $dumpfile("SCD.vcd");
    $dumpvars("+all");
end

integer f, eof = 0;

initial begin
    // f = $fopen("scd.txt", "r");
    // if (!f) begin
    //     $display("Open file failed!\n");
    //     $finish;
    // end

    @(negedge clk)
    rst_n = 1'b1;
    scan_en = 1'b1;

    // while (~eof) begin
    repeat (1 << 8) begin
        $display(".");
        // eof = $fscanf(f, "%b%d", ab, p);
        ab = $random;
        p = ab[7:4] * ab[3:0];

        repeat (7) begin // scan in
            @(negedge clk)
            ab = ab >> 1;
        end

        @(posedge clk) #1 // capture
        scan_en = 1'b0;
        @(posedge clk) #1
        scan_en = 1'b1;

        repeat (8) begin // scan out
            @(negedge clk)
            if (scan_out != p[0]) begin
                $display("WA!!");
                $finish;
            end
            p = p >> 1;
        end
    end
    
    @(negedge clk)
    $display("AC!!");
    $finish;
end

endmodule
