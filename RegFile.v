module RegFile(A,B,ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite,clk);

output reg [15:0]A,B;
input [3:0]ReadReg1,ReadReg2,WriteReg;
input [15:0]WriteData;
input clk, RegWrite;

reg [15:0]registers[0:15]; integer i;
initial
begin
for(i=0;i<=15;i=i+1)
registers[i]=i;
end

always @ (negedge clk)	
	begin
	if (RegWrite)
		registers[WriteReg] <= WriteData;
	end
	
always @ (*)	
	begin	
	A <= registers[ReadReg1];
	B <= registers[ReadReg2];
	end
	
endmodule

/* module tb_RegFile;

wire [15:0]A,B;
reg [3:0]ReadReg1,ReadReg2,WriteReg;
reg [15:0]WriteData; reg clk;
reg RegWrite;

initial
	begin
	$dumpfile("RegFile.vcd");
	$dumpvars;
	end
	
RegFile	uut (A,B,ReadReg1,ReadReg2,WriteReg,WriteData,RegWrite,clk);

initial 
	begin
	#0 clk = 0; forever #50 clk = ~clk;
	end

initial #00 ReadReg1= 2;
initial #00 ReadReg2=4;
initial #00 RegWrite=0;

initial #100 RegWrite =1;
initial #100 WriteReg = 2;
initial #100 WriteData = 1;
initial #25 ReadReg1= 1;	
initial #105 RegWrite =0;
	
initial #125 ReadReg1= 2;
	
initial #2000 $stop;
		
endmodule
	 */