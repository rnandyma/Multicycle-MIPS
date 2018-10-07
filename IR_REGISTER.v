module IR_REGISTER(out, in, rst, clk, IRWrite);

output reg [15:0] out;
input [15:0] in;
input clk,IRWrite,rst;

always@ (posedge clk) begin
if(rst) out = 0;
else if(IRWrite) out = in;
end

endmodule