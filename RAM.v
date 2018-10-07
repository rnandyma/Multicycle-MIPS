module RAM(MemData,WriteData,Address,MemWrite,MemRead,clk);

output reg [15:0]MemData;
input [15:0]WriteData;
input [9:0]Address;
input MemWrite,MemRead,clk;
reg [15:0]memory[0:1023];

always @ (negedge clk)
	begin
	if(MemWrite) memory[Address] <= WriteData;
	end
	
always @(posedge clk)
	begin 
	if (MemRead) MemData <= memory[Address];
	else	MemData <= 16'bzzzzzzzzzzzzzzzz;
	end

initial
	begin
	//
	end
	
endmodule
