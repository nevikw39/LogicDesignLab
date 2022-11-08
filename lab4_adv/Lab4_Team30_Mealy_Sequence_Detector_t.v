`timescale 1ns/1ps

module Mealy_Sequence_Detector_t;
reg clk = 0, rst_n = 0, in = 0;
wire out;

// specify duration of a clock cycle.
parameter cyc = 10;

// generate clock.
always #(cyc/2) clk = ~clk;

Mealy_Sequence_Detector msd(clk, rst_n, in, out);

// uncommment and add "+access+r" to your nverilog command to dump fsdb waveform on NTHUCAD
initial begin
    $dumpfile("MSD.vcd");
    $dumpvars("+all");
end

initial begin
    @(negedge clk)
    rst_n = 1'b1;
end

integer i;

initial begin

    // @(negedge clk)
    // rst_n = 1'b1;
    // in = 1'b0;
    // @(negedge clk)
    // in = 1'b1;
    // @(negedge clk);
    // @(negedge clk);

    // @(negedge clk)
    // in = 1'b0;
    // @(negedge clk)
    // in = 1'b1;
    // @(negedge clk);
    // @(negedge clk)
    // in = 1'b0;
    
    // @(negedge clk)
    // in = 1'b1;
    // @(negedge clk);
    // @(negedge clk)
    // in = 1'b0;
    // @(negedge clk)
    // in = 1'b1;
    
    // @(negedge clk)
    // in = 1'b0;
    // @(negedge clk)
    // in = 1'b1;
    // @(negedge clk)
    // in = 1'b0;
    // @(negedge clk);

    for (i = 0; i < 16; i = i + 1) begin
        @(negedge clk)
        // rst_n = 1'b1;
        in = i[0];
        @(negedge clk)
        in = i[1];
        @(negedge clk)
        in = i[2];
        @(posedge clk)
        #1 if (out != (i[2:0] == 3'b110 || i[2:0] == 3'b101 || i[2:0] == 3'b011)) begin
            $display("WA!!", i[2], i[1], i[0]);
            $finish;
        end
        @(negedge clk)
        in = i[3];
        #1 if (out != (i[3:0] == 4'b1110 || i[3:0] == 4'b1101 || i[3:0] == 4'b0011)) begin
            $display("WA!!", i[3], i[2], i[1], i[0]);
            $finish;
        end
        // rst_n = 1'b0;
    end

    @(negedge clk)
    $display("AC!!");
    $finish;
end

endmodule
