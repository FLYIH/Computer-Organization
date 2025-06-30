// 112550194
module Hazard_Detection(
    memread,
    instr_i,
    idex_regt,
    branch,
    pcwrite,
    ifid_write,
    ifid_flush,
    idex_flush,
    exmem_flush
);

input wire memread;  // Memory read signal from ID stage
input wire [31:0] instr_i;  // Instruction in IF/ID stage
input wire [4:0] idex_regt;  // RT register in ID/EX stage
input wire branch;  // Branch signal from ID stage
output reg pcwrite;  // Control signal to write to PC
output reg ifid_write;  // Control signal to write to IF/ID register
output reg ifid_flush;  // Control signal to flush IF/ID register
output reg idex_flush;  // Control signal to flush ID/EX register
output reg exmem_flush;  // Control signal to flush EX/MEM register
wire [4:0] rs, rt;
assign rs = instr_i[25:21];  // rs of instruction in IF/ID
assign rt = instr_i[20:16];  // rt of instruction in IF/ID

always @(*) begin
    // default
    pcwrite     = 1;
    ifid_write  = 1;
    ifid_flush  = 0;
    idex_flush  = 0;
    exmem_flush = 0;

    // Load-Use Hazard
    if (memread && ((idex_regt == rs) || (idex_regt == rt))) begin
        pcwrite     = 0;
        ifid_write  = 0;
        idex_flush  = 1;
    end

    // Branch Flush
    /*if (branch) begin
        ifid_flush  = 1;
        idex_flush  = 1;
        exmem_flush = 1;
    end*/
end

endmodule