`include "IR_REGISTER.v"
//`include "signextender.v"
`include "alutotalflag.v"
`include "Project.v"
`include "RAM.v"
`include "RegFile.v"
`include "pc.v"
`include "stackpc.v"
`include "mux2_1.v"
`include "mux4_1.v"
module DataPath(clk,rst);

input clk,rst;
//reg [15:0]A,B,MDR;
reg [15:0] MDR;
wire[15:0] A,B;
wire [15:0] out, WriteDataMem, WriteDataReg,addend,augend,IN_C,MemData,aluout;
wire [3:0]WriteReg,ReadReg;
//wire [8:0] jump_address,pc,stack,PCSTK,Addr,lw,sw;
wire [9:0] jump_address,PCSTK,lw,sw,Addr,updatepc,updatestack,pc,stack;
wire pcen;
wire[4:0] currentstate,nextstate;
wire [1:0] AluOp,IorD,PCSrc;
PROJECT controller(currentstate,nextstate,MemRead,MemWrite,AluSrcA,AluSrcB,AluSrcC,AluOp,IorD,IRWrite,PCSrc,PCWrite,SPWrite,PCMUX,PCWriteCond,RegSrc,RegWrite,MemToReg,RegDst,out[15:12],out[3:0],clk,rst);

assign pcen = PCWrite|(PCWriteCond&zero);
pc pc1(clk,pcen,updatepc,pc);
stackpc spc1(clk,SPWrite,updatestack,stack);
mux2_1 PC_MUX(PCSTK,pc,stack,PCMUX);
mux4_1 ID_MUX(Addr,PCSTK,B[9:0],lw,sw,IorD);

//RAM memory(MemData, WriteDataMem, Addr, MemWrite, MemRead, clk);
RAM memory(MemData, A, Addr, MemWrite, MemRead, clk);

always@(*)
begin
MDR<=MemData;
end


IR_REGISTER IREG(out, MemData, rst, clk, IRWrite);

mux2_1 ReadRegMux(ReadReg,out[7:4],out[11:8],RegSrc);

mux2_1 WriteRegMux(WriteReg,out[3:0],out[11:8],RegDst);

RegFile RegF(A,B,out[3:0],ReadReg,WriteReg, WriteDataReg, RegWrite, clk);

mux2_1 WDMUX(WriteDataReg, aluout, MDR, MemToReg);

// mux2_1 ALUMUX_D(val,out[0:7],out[4:11],AluSrcD); 

//signextender  lwsignex(lw,out[0:7]);
assign lw = {1'b1,1'b0,out[7:0]};

//signextender  swsignex(sw,out[4:11]);
assign sw = {1'b1,1'b0,out[11:4]};

mux2_1 ALUMUX_A(IN_C, pc, A, AluSrcA);

mux2_1 ALUMUX_C(addend,IN_C,out[7:4],AluSrcC);

mux2_1 ALUMUX_B(augend, B, 16'd0, AluSrcB);

alutotalflag alu(aluout,zero,carry,overflow,sign,addend,augend,AluOp,out[3:0]);

assign jump_address={PCSTK[9:8],out[11:4]};

mux4_1 PCSRC_MUX(updatepc,aluout,A[9:0],jump_address,16'd0,PCSrc);
endmodule