`timescale 1ns/1ps

module Traffic_Light_Controller (clk, rst_n, lr_has_car, hw_light, lr_light);
input clk, rst_n;
input lr_has_car;
output reg [2:0] hw_light;
output reg [2:0] lr_light;

parameter s0 = 3'b000,
          s1 = 3'b001,
          s2 = 3'b010,
          s3 = 3'b011,
          s4 = 3'b100,
          s5 = 3'b101;
          
reg [3-1:0] state, next_state;
reg change;
always @(posedge clk) begin
   if(~rst_n) begin
        state <= s0;
        change <= 1;
   end
   else begin
        if(state == s0) begin
            if(lr_has_car) state <= next_state;
            else state = s0;
        end else begin
            state <= next_state;
        end
   end
end

reg [7-1:0] next_seventy;
wire [5-1:0] next_twentyfive;
reg [7-1:0] seventy;
reg [5-1:0] twentyfive;
reg bigger;
always @(posedge clk) begin
   if(~rst_n) begin
        seventy <= 0;
        twentyfive <= 0;
        bigger <= 0;
   end else begin
        seventy <= next_seventy;
        twentyfive <= next_twentyfive;
   end
end
always @(*) begin
next_seventy = (seventy == 7'd70)? 7'd0 : seventy + 7'd1;
if(seventy == 7'd69) bigger = 1;
else if(bigger == 1) bigger = 1;
else bigger = 0;
end

assign next_twentyfive = (twentyfive == 5'd25)? 5'd0 : twentyfive + 5'd1;

always @(*) begin
    case(state)
        s0: begin
                if(change) begin
                    seventy = 7'd0;
                    change = 0;
                end
                else begin
                    if(bigger) begin
                        if(lr_has_car) begin
                            next_state = s1;
                            change = 1;
                        end
                        else begin
                            next_state = s0;
                            change = 0;
                        end
                    end else begin
                            next_state = s0;
                            change = 0;
                        end
                end
            end
        s1: begin
                if(change) begin
                    twentyfive = 5'd0;
                    change = 0;
                end
                else begin
                    if(twentyfive == 5'd24) begin
                        next_state = s2;
                        change = 1;
                    end else begin
                        next_state = s1;
                        change = 0;
                    end
                end
            end
        s2: begin
            next_state = s3;
            change = 1;
            end
        s3: begin
                if(change) begin
                    seventy = 7'd0;
                    change = 0;
                end
                else begin
                     if(seventy == 7'd69) begin
                        next_state = s4;
                        change = 1;
                     end else begin
                        next_state = s3;
                        change = 0;
                    end
                end
            end
        s4: begin
                if(change) begin
                    twentyfive = 5'd0;
                    change = 0;
                end
                else begin
                    if(twentyfive == 5'd23) begin
                        next_state = s5;
                        change = 1;
                    end else begin
                        next_state = s4;
                        change = 0;
                    end
                end
            end
        default: begin
                    next_state = s0;
                    change = 1;
                    bigger = 0;
                end
    endcase
end

always @(*) begin
    case(state)
        s0: begin
            hw_light = 3'b100;
            lr_light = 3'b001;
        end
        s1: begin
            hw_light = 3'b010;
            lr_light = 3'b001;
        end
        s2: begin
            hw_light = 3'b001;
            lr_light = 3'b001;
        end
        s3: begin
            hw_light = 3'b001;
            lr_light = 3'b100;
        end
        s4: begin
            hw_light = 3'b001;
            lr_light = 3'b010;
        end
        default: begin
            hw_light = 3'b001;
            lr_light = 3'b001;
        end
    endcase
end

endmodule