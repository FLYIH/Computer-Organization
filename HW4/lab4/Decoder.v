// 112550194
module Decoder( 
	instr_op_i, 
	ALUOp_o, 
	ALUSrc_o,
	RegWrite_o,	
	RegDst_o,
	Branch_o,
	MemRead_o, 
	MemWrite_o, 
	MemtoReg_o
);
     
// Instruction Format		 
parameter OP_R_TYPE = 6'b000000;
parameter OP_ADDI = 6'b001000;
parameter OP_BEQ = 6'b000101;
parameter OP_LW = 6'b101011;
parameter OP_SW = 6'b100011;
parameter OP_BNE = 6'b000100;
//ALU OP
parameter ALU_OP_R_TYPE = 2'b10;
parameter ALU_ADD = 2'b00;
parameter ALU_SUB = 2'b01;
parameter ALU_ADDI = 2'b11; 
// IO Port
input  [5:0] instr_op_i;
output reg [1:0] ALUOp_o;
output reg       ALUSrc_o;
output reg       RegWrite_o;
output reg       RegDst_o;
output reg       Branch_o;
output reg       MemRead_o; 
output reg       MemWrite_o; 
output reg       MemtoReg_o;  
// TO DO
always @(*) begin
    case (instr_op_i)
        OP_R_TYPE: begin // R-type
            ALUOp_o     = 2'b10;
            ALUSrc_o    = 0;
            RegWrite_o  = 1;
            RegDst_o    = 1;
            Branch_o    = 0;
            MemRead_o   = 0;
            MemWrite_o  = 0;
            MemtoReg_o  = 0;
        end
        OP_ADDI: begin // addi
            ALUOp_o     = 2'b11;
            ALUSrc_o    = 1;
            RegWrite_o  = 1;
            RegDst_o    = 0;
            Branch_o    = 0;
            MemRead_o   = 0;
            MemWrite_o  = 0;
            MemtoReg_o  = 0;
        end
        OP_LW: begin // lw
            ALUOp_o     = 2'b00;
            ALUSrc_o    = 1;
            RegWrite_o  = 1;
            RegDst_o    = 0;
            Branch_o    = 0;
            MemRead_o   = 1;
            MemWrite_o  = 0;
            MemtoReg_o  = 1;
        end
        OP_SW: begin // sw
            ALUOp_o     = 2'b00;
            ALUSrc_o    = 1;
            RegWrite_o  = 0;
            RegDst_o    = 0; // don't care
            Branch_o    = 0;
            MemRead_o   = 0;
            MemWrite_o  = 1;
            MemtoReg_o  = 0; // don't care
        end
        OP_BEQ: begin // beq
            ALUOp_o     = 2'b01;
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 0; // don't care
            Branch_o    = 1;
            MemRead_o   = 0;
            MemWrite_o  = 0;
            MemtoReg_o  = 0; // don't care
        end
        OP_BNE: begin // bne
            ALUOp_o     = 2'b01;
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 0; // don't care
            Branch_o    = 1;
            MemRead_o   = 0;
            MemWrite_o  = 0;
            MemtoReg_o  = 0; // don't care
        end
        default: begin // default safe values
            ALUOp_o     = 2'b00;
            ALUSrc_o    = 0;
            RegWrite_o  = 0;
            RegDst_o    = 0;
            Branch_o    = 0;
            MemRead_o   = 0;
            MemWrite_o  = 0;
            MemtoReg_o  = 0;
        end
    endcase
end

endmodule