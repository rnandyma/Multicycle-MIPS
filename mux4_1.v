module mux4_1(out,in1,in2,in3,in4,sbit);

input [15:0]in1,in2,in3,in4;
input [1:0]sbit;
output [15:0]out;
//output [9:0]out1;

assign out = (sbit==0)? in1:(sbit ==1 ? in2:(sbit==2 ? in3 : in4));
//assign out1 = out;
endmodule

module tb_mux4_1();
wire [15:0] out;
//wire [9:0] out1;
reg [15:0] in1,in2,in3,in4;
reg [1:0] sbit;
mux4_1 uut(out,in1,in2,in3,in4,sbit);
initial $monitor("t=%3d, out=%b, in1=%b, in2=%b,in3=%b, in4=%b, sbit=%b",$time,out,in1,in2,in3,in4,sbit);
initial
begin
#000 sbit = 2'b00;
#000 in1 = 16'b1111111111;
#000 in2 = 16'hffff;
#000 in3 = 16'hffff;
#000 in4 = 16'hffff;
end
endmodule

