module PROJECT(currentstate,nextstate,MemRead,MemWrite,AluSrcA,AluSrcB,AluSrcC,AluOp,IorD,IRWrite,PCSrc,PCWrite,SPWrite,PCMUX,PCWriteCond,RegSrc,RegWrite,MemToReg,RegDst,opcode,func,clk,rst);

input [3:0]opcode,func;
input clk,rst;
output reg MemRead,MemWrite,AluSrcA,AluSrcB,AluSrcC,IRWrite,PCWrite,SPWrite,PCMUX,PCWriteCond,RegSrc,RegWrite,MemToReg,RegDst;
output reg [1:0]AluOp,PCSrc,IorD;

parameter IF = 5'b11111, ID = 5'b11110, LWSW = 5'b11010, LW1 = 5'b11000, LW2 = 5'b11011, SW = 5'b11001, JMP = 5'b11100, BEQ1 = 5'b11101, BEQ2=5'b00100,
ADD = 5'b10000, SUB = 5'b10001, NAND = 5'b10010, SH1 = 5'b10011, SH2 = 5'b10101, RFINAL = 5'b10111, NOT = 5'b10110, PUSH1 = 5'b00010, 
PUSH2 = 5'b00011, POP_1 = 5'b00000, POP_2 = 5'b00001, OP_ADD = 4'b0000, OP_SUB = 4'b0001, OP_NAND = 4'b0010, OP_SH_NOT = 4'b0011, 
OP_LW = 4'b1000, OP_SW = 4'b1001, OP_JMP = 4'b1100, OP_BEQ = 4'b1101, OP_PUSH = 4'b0100, OP_POP = 4'b0101, FN_NOT=4'b0000, FN_SAR=4'b0001, 
FN_SHR=4'b0010, FN_SHL=4'b0011, FN_JMP=0000; 

output reg [4:0]currentstate, nextstate;

always @(posedge clk,posedge rst) begin

if(rst==1)	begin 
AluSrcA = 0;
AluSrcB = 0;
AluSrcC = 0;
MemRead = 0;
MemWrite = 0;
PCWrite = 0;
SPWrite = 0;
PCMUX = 0;
IorD = 0;
IRWrite = 0;
PCSrc = 0;
PCWriteCond = 0;
RegSrc = 0;
RegWrite = 0;
MemToReg = 0;
RegDst = 0;
AluOp = 0;
nextstate = IF;
end

else begin 
case (nextstate) 

IF : begin 
	currentstate = nextstate;
	MemRead = 1;
	AluSrcA = 0;
	AluSrcB = 1;
	AluSrcC = 0;
	PCWrite = 1;
	SPWrite = 0;
	PCWriteCond = 0;
	PCMUX = 0;
	IorD = 0;
	IRWrite = 1;
	AluOp = 0;
	PCSrc = 0;
	MemWrite = 0;
	RegWrite = 0;
	nextstate = ID;
	end
ID :   begin 
		currentstate = nextstate;
		//AluSrcA = 0;
		//AluSrcB = 3;
		//AluSrcC = 0;
		//AluOp = 0;
		RegSrc = 0;
		RegDst = 0;
		PCWrite = 0;
		IRWrite = 0;
		MemRead = 0;
		case (opcode)
			OP_LW  	  : nextstate = LW1;
			OP_SW  	  : nextstate = SW;
			OP_JMP 	  : nextstate = JMP;
			OP_BEQ 	  : nextstate = BEQ1;
			OP_ADD 	  : nextstate = ADD;
			OP_SUB    : nextstate = SUB;
			OP_NAND	  : nextstate = NAND;
			OP_PUSH   : nextstate = PUSH1;
			OP_POP    : nextstate = POP_1;
			OP_SH_NOT : begin if(func==FN_NOT) nextstate = NOT;
							else nextstate = SH1;
						end
			default	  :	nextstate = IF;
		endcase
		end
/* LWSW : begin 
		currentstate = nextstate;
		AluSrcA = 1;
		AluSrcB = 2;
		AluSrcC = 0;
		AluOp = 0;
		case (opcode)
		OP_LW  	  : begin 
					nextstate = LW1;
					end
		OP_SW  	  : begin
					nextstate = SW;
					end
		default: nextstate = IF;
		endcase
		end */
LW1 :	begin 
		 currentstate = nextstate;
		 MemRead = 1;
		 IorD = 2;
		 nextstate = LW2;
		end
LW2:	begin
		currentstate = nextstate;
		RegDst=1;  // changed
		RegWrite=1;
		MemToReg=1;
		nextstate = IF;
		end
SW :	begin 
		currentstate = nextstate;
		MemWrite = 1;
		nextstate = IF;
		IorD = 3;
		end
JMP :	begin
		currentstate = nextstate;
		PCWrite = 1;
		PCSrc   = 2;
		nextstate = IF;
		end
BEQ1 :	begin
		currentstate = nextstate;
		AluSrcA = 1;
		AluSrcB = 0;
		AluSrcC = 0;
		AluOp = 1;
		nextstate = BEQ2;
		end
BEQ2 :  begin
		RegSrc = 1;
		PCWriteCond = 1;
		PCSrc = 1;
		end
ADD :	begin
		currentstate = nextstate;
		AluSrcA = 1;
		AluSrcB = 0;
		AluSrcC = 0;
		AluOp = 0;
		nextstate = RFINAL;
		end
SUB :	begin
		currentstate = nextstate;
		AluSrcA = 1;
		AluSrcB = 0;
		AluSrcC = 0;
		AluOp = 1;
		nextstate = RFINAL;
		end
NAND:	begin
		currentstate = nextstate;
		AluSrcA = 1;
		AluSrcB = 0;
		AluSrcC = 0;
		AluOp = 2;
		nextstate = RFINAL;
		end
PUSH1:  begin
		currentstate = nextstate;
		PCWrite = 0;
		SPWrite = 1;
		AluSrcA = 0;
		AluSrcB = 1;
		AluSrcC = 0;
		AluOp = 1;
		PCSrc = 0;
		PCMUX = 1;
		nextstate = PUSH2;
		end
PUSH2:  begin
		currentstate = nextstate;
		MemWrite = 1;
		IorD = 1;
		SPWrite = 0;
		nextstate = IF;
		end
POP_1:  begin
		currentstate = nextstate;
		MemRead = 1;
		PCMUX = 1;
		IorD = 0;
		nextstate = POP_2;
		end
POP_2 :  begin
		currentstate = nextstate;
		RegDst = 0;
		RegWrite = 1;
		MemToReg = 1;
		PCWrite = 0;
		SPWrite = 1;
		AluSrcA = 0;
		AluSrcB = 1;
		AluSrcC = 0;
		AluOp = 0;
		PCSrc = 0;
		nextstate = IF;
		end
SH1  :  begin
		currentstate = nextstate;
		RegSrc = 1;
		nextstate = SH2;
		end
SH2 :   begin
		currentstate = nextstate;
		AluSrcB = 0;
		AluSrcC = 1;
		AluOp   = 3;
		nextstate = RFINAL;
		end
NOT:	begin
		currentstate = nextstate;
		AluSrcA = 1;
		AluSrcB = 1;
		AluSrcC = 0;
		AluOp = 3;
		nextstate = RFINAL;
		end
RFINAL:	begin
		currentstate = nextstate;
		RegDst = 1;
		RegWrite = 1;
		MemToReg = 0;
		nextstate = IF;
		end
default: nextstate = IF;
endcase
end
end

initial begin
AluSrcA = 0;
AluSrcB = 0;
AluSrcC = 0;
MemRead = 0;
MemWrite = 0;
PCWrite = 0;
IorD = 0;
IRWrite = 0;
PCSrc = 0;
PCWriteCond = 0;
SPWrite = 0;
PCMUX = 0;
RegSrc = 0;
RegWrite = 0;
MemToReg = 0;
RegDst = 0;
AluOp = 0;
nextstate = IF;
end

endmodule
	
		
	

		

		
		
		
						
		
	