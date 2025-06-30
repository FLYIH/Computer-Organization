// 112550194
module Forwarding_Unit(
    regwrite_mem, //RegWrite_s4_i,
    regwrite_wb, // RegWrite_s5_i
    idex_regs, // RSaddr_i
    idex_regt, // RTaddr_i,
    exmem_regd, //  RDaddr_s4_i,
    memwb_regd, // RDaddr_s5_i
    forwarda,
    forwardb
);

// I/O ports
input [4:0] idex_regs, idex_regt, exmem_regd, memwb_regd;
input regwrite_mem, regwrite_wb;
output wire [1:0] forwarda, forwardb;

// Main function
assign forwarda = (regwrite_mem && (exmem_regd != 0) && (exmem_regd == idex_regs)) ? 2'b10 :
                  (regwrite_wb  && (memwb_regd != 0) && (memwb_regd == idex_regs)) ? 2'b01 :
                  2'b00;

assign forwardb = (regwrite_mem && (exmem_regd != 0) && (exmem_regd == idex_regt)) ? 2'b10 :
                  (regwrite_wb  && (memwb_regd != 0) && (memwb_regd == idex_regt)) ? 2'b01 :
                  2'b00;

endmodule