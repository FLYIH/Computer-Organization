// 112550194
module Shift_Left_Two_32(
    data_i,
    data_o
    );

// I/O ports                    
input [32-1:0] data_i;

output [32-1:0] data_o;

// Internal Signals
reg   [31:0] data_o;

// Main function
always @(*) begin
    data_o = data_i << 2;
end
     
endmodule
