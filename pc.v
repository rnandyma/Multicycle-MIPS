module pc(clk,pcen,updatepc,pc);
input clk,pcen;
input[9:0]updatepc;
output[9:0]pc;
reg[9:0]pc;
always@(posedge clk,pcen)
begin
/*if (rst==1'b1)
pc<=4'b00000;
else*/
pc<=updatepc;
end
endmodule