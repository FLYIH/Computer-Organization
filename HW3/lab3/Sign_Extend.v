// 112550194
module Sign_Extend(
    data_i,
    data_o
    );
               
// I/O ports
input   [16-1:0] data_i;

output  [32-1:0] data_o;

// Internal Signals
reg [31:0] data_o;

// Main function
always @(*) begin
    data_o = { {16{data_i[15]}}, data_i };
end
          
endmodule      
     