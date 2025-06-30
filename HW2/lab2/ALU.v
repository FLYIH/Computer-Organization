// 112550194
`timescale 1ns/1ps
`include "ALU_1bit.v"
module ALU(
	input                   rst_n,         // negative reset            (input)
	input	     [32-1:0]	src1,          // 32 bits source 1          (input)
	input	     [32-1:0]	src2,          // 32 bits source 2          (input)
	input 	     [ 4-1:0] 	ALU_control,   // 4 bits ALU control input  (input)
	output reg   [32-1:0]	result,        // 32 bits result            (output)
	output reg              zero,          // 1 bit when the output is 0, zero must be set (output)
	output reg              cout,          // 1 bit carry out           (output)
	output reg              overflow       // 1 bit overflow            (output)
	);

/* Write down your code HERE */
wire [31:0] alu_result;
wire [31:0] alu_cout;
wire        less;

reg Ainvert, Binvert;
reg [1:0] operation;

always @(*) begin
    case (ALU_control)
        4'b0000: begin // AND
            Ainvert = 1'b0; Binvert = 1'b0; operation = 2'b00;
        end
        4'b0001: begin // OR
            Ainvert = 1'b0; Binvert = 1'b0; operation = 2'b01;
        end
        4'b0010: begin // add
            Ainvert = 1'b0; Binvert = 1'b0; operation = 2'b10;
        end
        4'b0110: begin // sub
            Ainvert = 1'b0; Binvert = 1'b1; operation = 2'b10;
        end
        4'b0111: begin // slt
            Ainvert = 1'b0; Binvert = 1'b1; operation = 2'b11;
        end
        4'b1100: begin // NOR
            Ainvert = 1'b1; Binvert = 1'b1; operation = 2'b00;
        end
        4'b1101: begin // NAND
            Ainvert = 1'b1; Binvert = 1'b1; operation = 2'b01;
        end
        default: begin
            Ainvert = 1'b0; Binvert = 1'b0; operation = 2'b00;
        end
    endcase
end

ALU_1bit alu0 (
    .src1(src1[0]), 
		.src2(src2[0]), 
		.less(1'b0),
    .Ainvert(Ainvert), 
		.Binvert(Binvert), 
		.cin(Binvert),
    .operation(operation), 
		.result(alu_result[0]), 
		.cout(alu_cout[0])
);

genvar i;
generate
    for (i = 1; i < 32; i = i + 1) begin : alu_gen
        ALU_1bit alu (
            .src1(src1[i]), 
						.src2(src2[i]), 
						.less(1'b0),
            .Ainvert(Ainvert), 
						.Binvert(Binvert), 
						.cin(alu_cout[i-1]),
            .operation(operation), 
						.result(alu_result[i]), 
						.cout(alu_cout[i])
        );
    end
endgenerate

assign less = (src1[31] ^ src2[31]) ? src1[31] : alu_result[31];
wire overflow_temp;
assign overflow_temp = alu_cout[30] ^ alu_cout[31];

always @(*) begin
    if (~rst_n) begin
        result = 32'b0;
        zero = 1'b0;
        cout = 1'b0;
        overflow = 1'b0;
    end else begin
        if (ALU_control == 4'b0111) begin
            result = {31'b0, less};
        end else begin
            result = alu_result;
        end
        zero = (result == 32'b0);
        cout = (ALU_control == 4'b0010 || ALU_control == 4'b0110) ? alu_cout[31] : 1'b0;
        overflow = (ALU_control == 4'b0010 || ALU_control == 4'b0110) ? overflow_temp : 1'b0;
    end
end
endmodule
