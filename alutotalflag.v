`include "alucontrol.v"
module alutotalflag(aluout,zero,carry,overflow,sign,addend,augend,aluop,functcode);
input signed[15:0] addend, augend;
input[1:0] aluop;
input[3:0] functcode;
parameter add=3'b000,subtract=3'b001, nanornot=3'b010, neg=3'b100, sar=3'b101, shr=3'b110, shl=3'b111,sal=3'b011;
output signed [15:0] aluout;
reg signed[15:0] aluout;
reg [15:0] one = 16'd1;
reg [16:0] extra;
wire[2:0] alucont;
output  reg zero,carry,overflow,sign;
alucontrol ac1(aluop,functcode,alucont);
always@ (*)
begin
case(alucont)
add:begin 
	aluout<= addend+augend;
	extra<= aluout;
	overflow<=((addend[15]^~augend[15])&(aluout[15]^addend[15]));
	if(extra[16]==1)
	carry<=1;
	else 
	carry<=0;
	end
subtract:begin
		aluout<= addend-augend;
		extra<= aluout;
		overflow<=((addend[15]^~augend[15])&(aluout[15]^addend[15]));
		if(extra[16]==1)
		carry<=1;
		else 
		carry<=0;
		end
nanornot:begin 
		aluout<= ~(addend&augend);
		overflow<=0;
		carry<=0;
		end
neg: begin 
		aluout<= ~addend+one;
		overflow<=((addend[15]^~one[15])&(aluout[15]^addend[15]));
		carry<=0;
		end
sar: begin 
		aluout<= augend >>> addend;
		overflow<=0;
		carry<=0;
		end
shr:begin 
		aluout<= augend>>addend;
		overflow<=0;
		carry<=0;
		end
shl:begin 
		aluout<= augend<<addend;
		overflow<=0;
		carry<=0;
		end
sal:begin 
		aluout<=augend<<<addend;
		overflow<=0;
		carry<=0;
		end
default:aluout<=16'bxxxxxxxxxxxxxxxx;
endcase
//extra<= aluout;
if(aluout == 0)
zero<=1;
else
zero<=0;
if (aluout[15]==1)
sign<=1;
else 
sign<=0;
/*if(extra[16]==1)
carry<=1;
else 
carry<=0;*/
end
endmodule

module tb_alutotalflag();
wire signed[15:0]aluout1;
wire zero,carry,overflow,sign;
reg signed[15:0]addend1,augend1;
reg [1:0] aluop;
reg[3:0] functcode;
alutotalflag uut(aluout1,zero,carry,overflow,sign,addend1,augend1,aluop,functcode);
initial $monitor("t=%3d, aluout1=%b, addend1=%b, augend1=%b,aluop=%b, functcode=%b, zero=%b, sign = %b, carry = %b, overflow=%b",$time,aluout1,addend1,augend1,aluop,functcode,zero,sign, carry, overflow);
initial
begin
//#0000 alucont1 = 3'b101;
#0000 addend1 = 16'b1111111111111111;
#0000 augend1 = 16'b0000000000000001;
#000 functcode=4'b0000;
#000 aluop=2'b00;
end
endmodule