module tb_Project;
reg [3:0]opcode,func;
reg clk,rst;
wire MemRead,MemWrite,AluSrcA,AluSrcC,IorD,IRWrite,PCWrite,SPWrite,PCMUX,PCWriteCond,RegSrc,RegWrite,MemToReg,RegDst;
wire [1:0]AluOp,AluSrcB,PCSrc;
wire [4:0] cs,ns;
integer i = 0;

PROJECT uut(cs,ns,MemRead,MemWrite,AluSrcA,AluSrcB,AluSrcC,AluOp,IorD,IRWrite,PCSrc,PCWrite,SPWrite,PCMUX,PCWriteCond,RegSrc,RegWrite,MemToReg,RegDst,opcode,func,clk,rst);

initial
begin
$dumpfile("Project_test.vcd");
$dumpvars;
end

initial begin 
clk = 0;
opcode = 0;
#5 opcode = 4'b0100;
func = 0;
rst = 0;
#100 rst = 1;
#100 rst = 0;
#100 clk =0;
for(i = 0;i<20;i=i+1)
#100 clk = ~clk;
opcode = 4'b0101;
func = 0001;
for(i = 0;i<20;i=i+1)
#100 clk = ~clk;

#5 rst = 1;
for(i = 0;i<20;i=i+1)
#100 clk = ~clk;
end

endmodule

