`timescale 1ns/1ps

module Built_In_Self_Test_t;
reg clk = 0, rst_n = 0, scan_en;
wire scan_in, scan_out;

reg [7:0] ab, p;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Built_In_Self_Test bist(clk, rst_n, scan_en, scan_in, scan_out);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
initial begin
    $dumpfile("BIST.vcd");
    $dumpvars("+all");
end

initial begin

    @(negedge clk)
    rst_n = 1'b1;
    scan_en = 1'b1;

    repeat (1 << 8) begin
        $display(".");

        @(posedge clk)
        ab[7] = scan_in;
        repeat (7) begin // scan in
            @(negedge clk)
            ab = {scan_in, ab[7:1]};
        end
        p = ab[7:4] * ab[3:0];

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
    $display("Ac!!");
    $finish;
end

endmodule
