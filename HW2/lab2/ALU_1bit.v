// 112550194
`timescale 1ns/1ps
`include "MUX_2to1.v"
`include "MUX_4to1.v"

module ALU_1bit(
	input				src1,       //1 bit source 1  (input)
	input				src2,       //1 bit source 2  (input)
	input				less,       //1 bit less      (input)
	input 				Ainvert,    //1 bit A_invert  (input)
	input				Binvert,    //1 bit B_invert  (input)
	input 				cin,        //1 bit carry in  (input)
	input 	    [2-1:0] operation,  //2 bit operation (input)
	output reg          result,     //1 bit result    (output)
	output reg          cout        //1 bit carry out (output)
	);
		
/* Write down your code HERE */
	parameter AND = 2'b00;
	parameter ADD = 2'b10;
	parameter OR  = 2'b01;
	parameter SUB = 2'b11;

	wire sum;
	wire invert_src1, invert_src2;
	wire and_res, or_res;
	wire mux_res;
	wire carryout;

	MUX_2to1 muxa(
		.src1(src1),
		.src2(~src1),
		.select(Ainvert),
		.result(invert_src1)
	);
	MUX_2to1 muxb(
		.src1(src2),
		.src2(~src2),
		.select(Binvert),
		.result(invert_src2)
	);

	assign {carryout, sum} = invert_src1 + invert_src2 + cin;

	assign and_res = invert_src1 & invert_src2;
	assign or_res  = invert_src1 | invert_src2;

	MUX_4to1 mux_result (
    .src1(and_res),  // AND
    .src2(or_res),   // OR
    .src3(sum),         // ADD
    .src4(sum),        // SUB
    .select(operation),
    .result(mux_res)
	);

	always @(*) begin
		result = mux_res;
		cout = carryout;
	end
endmodule
