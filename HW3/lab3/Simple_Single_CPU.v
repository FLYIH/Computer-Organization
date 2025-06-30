// 112550194

`include "ProgramCounter.v"
`include "Instr_Memory.v"
`include "Reg_File.v"
`include "Data_Memory.v"
`include "Adder.v"
`include "ALU.v"
`include "ALU_Ctrl.v"
`include "Decoder.v"
`include "MUX_2to1.v"
`include "MUX_3to1.v"
`include "Sign_Extend.v"
`include "Shift_Left_Two_32.v"

module Simple_Single_CPU(
        clk_i,
        rst_i
);
		
// I/O ports
input         clk_i;
input         rst_i;

// Internal Signals
wire [31:0] pc_cur, pc_next, pc_plus4, instr;
wire [5:0] opcode, funct;
wire [4:0] rs, rt, rd;
wire [31:0] rs_data, rt_data;
wire [1:0] ALUOp, RegDst, MemtoReg, Branch;
wire ALUSrc, RegWrite, Jump, MemRead, MemWrite;
wire [31:0] sign_extended;
wire [3:0] ALUCtrl;
wire [31:0] ALU_src2, ALU_result;
wire ALU_zero, ALU_overflow;
wire [31:0] mem_read_data;
wire [31:0] write_data;
wire [31:0] branch_target, shifted_branch;
wire [31:0] jump_addr;
wire [31:0] pc_branch;
wire [31:0] pc_after_branch;
wire [31:0] pc_after_jump;
wire [4:0] write_reg_addr;
wire branch_taken;
wire Jr;

wire [31:0] ALU_src1;
wire shift_fixed;

// Components
ProgramCounter PC(
        .clk_i(clk_i),      
        .rst_i(rst_i),     
        .pc_in_i(pc_next),   
        .pc_out_o(pc_cur) 
);

Instr_Memory IM(
        .pc_addr_i(pc_cur),  
        .instr_o(instr)    
);

Decoder Decoder(
        .instr_op_i(instr[31:26]),
        .ALU_op_o(ALUOp),
        .ALUSrc_o(ALUSrc),
        .RegWrite_o(RegWrite),
        .RegDst_o(RegDst),
        .Branch_o(Branch),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
        .MemtoReg_o(MemtoReg),
        .Jr_o(Jr)
);

Sign_Extend Sign_Extend(
        .data_i(instr[15:0]),
        .data_o(sign_extended)
);

Reg_File Registers(
        .clk_i(clk_i),
        .rst_i(rst_i),     
        .RSaddr_i(instr[25:21]),  // rs
        .RTaddr_i(instr[20:16]),  // rt
        .RDaddr_i(write_reg_addr),
        .RDdata_i(write_data),
        .RegWrite_i(RegWrite),
        .RSdata_o(rs_data),  
        .RTdata_o(rt_data)
);

MUX_3to1 #(.size(5)) MUX_RegDst(
        .data0_i(instr[20:16]),  // rt
        .data1_i(instr[15:11]),  // rd
        .data2_i(5'd31),         // $ra = 31
        .select_i(RegDst),
        .data_o(write_reg_addr)
);

MUX_2to1 #(.size(32)) MUX_ALUSrc(
        .data0_i(rt_data),
        .data1_i(sign_extended),
        .select_i(ALUSrc),
        .data_o(ALU_src2)
);


assign shift_fixed = (ALUCtrl == 4'b1000) || (ALUCtrl == 4'b1001);

MUX_2to1 #(.size(32)) MUX_ALUSrc1(
        .data0_i(rs_data),
        .data1_i({27'b0, instr[10:6]}),
        .select_i(shift_fixed),
        .data_o(ALU_src1)
);

ALU_Ctrl ALU_Ctrl(
        .funct_i(instr[5:0]),
        .ALUOp_i(ALUOp),
        .ALUCtrl_o(ALUCtrl)
);

ALU ALU(
        .src1_i(ALU_src1),
        .src2_i(ALU_src2),
        .ctrl_i(ALUCtrl),
        .result_o(ALU_result),
        .zero_o(ALU_zero),
        .overflow(ALU_overflow)
);

Data_Memory Data_Memory(
	.clk_i(clk_i), 
	.addr_i(ALU_result), 
	.data_i(rt_data), 
	.MemRead_i(MemRead), 
	.MemWrite_i(MemWrite), 
	.data_o(mem_read_data)
);

MUX_3to1 #(.size(32)) MUX_MemtoReg(
        .data0_i(ALU_result),
        .data1_i(mem_read_data),
        .data2_i(pc_plus4),
        .select_i(MemtoReg),
        .data_o(write_data)
);

Adder Adder_PCplus4(
        .src1_i(pc_cur),
        .src2_i(32'd4),
        .sum_o(pc_plus4)
);

Shift_Left_Two_32 Shift_Left_Two(
        .data_i(sign_extended),
        .data_o(shifted_branch)
);

Adder Adder_Branch(
        .src1_i(pc_plus4),
        .src2_i(shifted_branch),
        .sum_o(pc_branch)
);

// Branch Taken logic
assign branch_taken = (Branch == 2'b01 && ALU_zero) || (Branch == 2'b10 && ~ALU_zero);

// Choose branch target
MUX_2to1 #(.size(32)) MUX_Branch(
        .data0_i(pc_plus4),
        .data1_i(pc_branch),
        .select_i(branch_taken),
        .data_o(pc_after_branch)
);

// Calculate jump address
assign jump_addr = {pc_plus4[31:28], instr[25:0], 2'b00};

// Choose jump target
MUX_2to1 #(.size(32)) MUX_Jump(
        .data0_i(pc_after_branch),
        .data1_i(jump_addr),
        .select_i(Jump),
        .data_o(pc_after_jump)
);

MUX_2to1 #(.size(32)) MUX_Jr(
        .data0_i(pc_after_jump),
        .data1_i(rs_data),
        .select_i(Jr),
        .data_o(pc_next)
);

endmodule
