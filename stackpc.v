module stackpc(clk,SPWrite,updatestack,stack);
input clk,SPWrite;
input[9:0]updatestack;
output[9:0]stack;
reg[9:0]stack;
always@(posedge clk,SPWrite)
begin
/*if (rst==1'b1)
pc<=4'b00000;
else*/
stack<=updatestack;
end
endmodule