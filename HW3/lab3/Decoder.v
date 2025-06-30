// 112550194
module Decoder( 
	instr_op_i,
	ALU_op_o,
	ALUSrc_o,
	RegWrite_o,
	RegDst_o,
	Branch_o,
	Jump_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o,
	Jr_o
);

// I/O ports
input	[6-1:0] instr_op_i;
input   [5:0] instr_funct_i;
output	reg [2-1:0] ALU_op_o;
output	reg [2-1:0] RegDst_o, MemtoReg_o;
output  reg [2-1:0] Branch_o;
output	reg ALUSrc_o, RegWrite_o, Jump_o, MemRead_o, MemWrite_o;
output  reg Jr_o;
// Internal Signals

// Main function
always@(*)begin
	case(instr_op_i)
		6'b000000: begin // R-type
			ALU_op_o    = 2'b10;
			ALUSrc_o    = 0;
			RegDst_o    = 2'b01;
			Branch_o    = 2'b00;
			MemRead_o   = 0;
			MemWrite_o  = 0;
			MemtoReg_o  = 2'b00;
			if (instr_funct_i == 6'b001000) begin // jr
          Jr_o = 1;
					RegWrite_o  = 0;
      end else begin
          Jr_o = 0;
					RegWrite_o  = 1;
      end
			Jump_o      = 0;
		end

		6'b001000: begin // addi
			ALU_op_o    = 2'b00; 
			ALUSrc_o    = 1;
			RegWrite_o  = 1;
			RegDst_o    = 2'b00;
			Branch_o    = 2'b00;
			Jump_o      = 0;
			MemRead_o   = 0;
			MemWrite_o  = 0;
			MemtoReg_o  = 2'b00;
			Jr_o        = 0;
		end

		6'b101011: begin // lw
			ALU_op_o    = 2'b00;
			ALUSrc_o    = 1;
			RegWrite_o  = 1;
			RegDst_o    = 2'b00;
			Branch_o    = 2'b00;
			Jump_o      = 0;
			MemRead_o   = 1;
			MemWrite_o  = 0;
			MemtoReg_o  = 2'b01;
			Jr_o        = 0;
		end

		6'b100011: begin // sw
			ALU_op_o    = 2'b00;
			ALUSrc_o    = 1;
			RegWrite_o  = 0;
			RegDst_o    = 2'b00;
			Branch_o    = 2'b00;
			Jump_o      = 0;
			MemRead_o   = 0;
			MemWrite_o  = 1;
			MemtoReg_o  = 2'b00;
			Jr_o        = 0;
		end

		6'b000101: begin // beq
			ALU_op_o    = 2'b01;
			ALUSrc_o    = 0;
			RegWrite_o  = 0;
			RegDst_o    = 2'b00;
			Branch_o    = 2'b01;
			Jump_o      = 0;
			MemRead_o   = 0;
			MemWrite_o  = 0;
			MemtoReg_o  = 2'b00;
			Jr_o        = 0;
		end

		6'b000100: begin // bne
			ALU_op_o    = 2'b01;
			ALUSrc_o    = 0;
			RegWrite_o  = 0;
			RegDst_o    = 2'b00;
			Branch_o    = 2'b10;
			Jump_o      = 0;
			MemRead_o   = 0;
			MemWrite_o  = 0;
			MemtoReg_o  = 2'b00;
			Jr_o        = 0;
		end

		6'b000011: begin // jump (j)
			ALU_op_o    = 2'b00;
			ALUSrc_o    = 0;
			RegWrite_o  = 0;
			RegDst_o    = 2'b00;
			Branch_o    = 2'b00;
			Jump_o      = 1;
			MemRead_o   = 0;
			MemWrite_o  = 0;
			MemtoReg_o  = 2'b00;
			Jr_o        = 0;
		end

		6'b000010: begin // jump and link (jal)
			ALU_op_o    = 2'b00;
			ALUSrc_o    = 0;
			RegWrite_o  = 1;
			RegDst_o    = 2'b10;
			Branch_o    = 2'b00;
			Jump_o      = 1;
			MemRead_o   = 0;
			MemWrite_o  = 0;
			MemtoReg_o  = 2'b10;
			Jr_o        = 0;
		end

		default: begin
			ALU_op_o    = 2'b00;
			ALUSrc_o    = 0;
			RegWrite_o  = 0;
			RegDst_o    = 2'b00;
			Branch_o    = 2'b00;
			Jump_o      = 0;
			MemRead_o   = 0;
			MemWrite_o  = 0;
			MemtoReg_o  = 2'b00;
			Jr_o        = 0;
		end
	endcase
end

endmodule
