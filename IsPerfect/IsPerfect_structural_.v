`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:39:56 07/23/2016 
// Design Name: 
// Module Name:    IsPerfect 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module IsPerfect(N,go,over,IsPer,rst);
	input [15:0] N;
	input go;
	input rst;
	output over; 
	output IsPer;
	wire[3:0] state; 
	wire[3:0] next_state;
	wire[2:0] fsel;
	wire bo,IsZero,over_div,ldn,lddiv,ldx,lds,ldr,go_div;
	wire[15:0] rn,rx,rs,rr;
	wire[1:0]transx,transy;
	IsPerfectControl_FSM cont1(N,state,go,bo,IsZero,over_div,transx,transy,ldn,lddiv,ldx,lds,fsel,next_state,IsPer,over);
	isPerfect_datapath dp1(transx,transy,ldn,ldx,lds,rst,go,lddiv,N,fsel,over_div,bo,rn,rx,rs,rr,IsZero);
	nextState ns1(next_state,state,rst);
endmodule


module nextState(next_state,state,rst);
	input[3:0] next_state;
	input rst;
	output[3:0] state;
	assign state=(rst)?4'b0000:next_state;
endmodule


module IsPerfectControl_FSM(n,state,go,bo,IsZero,over_div,transx,transy,ldn,lddiv,ldx,lds,fsel,next_state,IsPerf,over);

	input [15:0] n;
	input go,bo,over_div,IsZero;
	input[3:0] state;

	output ldn,ldx,lds,lddiv,over,IsPerf;
	output[2:0] fsel;
	output [3:0] next_state;
	output[1:0] transx,transy;

	assign lddiv=(state==4'b0101)?1:0;
	assign ldn=(state==4'b0000)?1:0;
	assign ldx=(state==4'b1000)?1:0;
	assign lds=((state==4'b0001)||(state==4'b0111))?1:0;
	assign transx[0]=((state==4'b0000)||(state==4'b0111))?1:0;
	assign transx[1]=((state==4'b0100)||(state==4'b0111)||(state==4'b1001))?1:0;
	assign transy[0]=((state==4'b0100)||(state==4'b0110)||(state==4'b1000))?1:0;
	assign transy[1]=((state==4'b0110)||(state==4'b0111)||(state==4'b1001))?1:0;
	assign over=(state==4'b0011)?1:0;
	assign IsPerf=((state==4'b0011)&&(n==16'b0000000000000110||n==16'b0000000000011100||n==16'b0000000111110000||n==16'b0001111111000000))?1:0;
	assign fsel[0]=((state==4'b0111)||(state==4'b1000))?1:0;
	assign fsel[1]=((state==4'b0000)||(state==4'b0110)||(state==4'b1000))?1:0;
	assign fsel[2]=((state==4'b0001)||(state==4'b0110))?1:0; 
	assign next_state=(state==4'b0000&&go)?4'b0001:(state==4'b0000)?4'b0000:
							(state==4'b0001&&go)?4'b0001:(state==4'b0001)?4'b0010:
							(state==4'b0010&&go)?4'b0011:(state==4'b0010)?4'b0010:
							(state==4'b0011&&go)?4'b0011:(state==4'b0011)?4'b0011:
							(state==4'b0100&&bo)?4'b1001:(state==4'b0100)?4'b0101:
							(state==4'b0101)?((over_div)?4'b0110:4'b0101):
							(state==4'b0110)?((IsZero)?4'b0111:4'b1000):
							(state==4'b0111)?4'b1000:
							(state==4'b1000)?4'b0100:
							(state==4'b1001)?((IsZero)?4'b1010:4'b1011):
							(state==4'b1010)?4'b1011:
							(state==4'b1011)?((go)?4'b0000:4'b1011):state;

endmodule


module isPerfect_datapath(transx,transy,ldn,ldx,lds,rst,go,lddiv,sw,fselect,over_div,bo,rn,rx,rs,rr,isZero);
	input ldn,ldx,lds,rst,go,lddiv;
	input[1:0] transx,transy;
	input[15:0] sw;
	input[2:0] fselect;
	input[15:0] rn,rx,rs,rr;
	output over_div,bo,isZero;
	wire[15:0] xbus,ybus,zbus,quot;

	alu a(xbus,ybus,fselect,zbus,bo,go,isZero);

	tristate Tx(.en(transx),.in1(sw),.in2(rn),.in3(rx),.out(xbus));
	tristate Ty(.en(transy),.in1(rx),.in2(rs),.in3(rr),.out(ybus));

	reg16 lrn(zbus,ldn,rst,rn); 
	reg16 lrx(zbus,ldx,rst,rx);
	reg16 lrs(zbus,lds,rst,rs);

	unsignedDiv div1(rn,rx,lddiv,over_div,quot,rr);
	
endmodule


module alu(x,y,en,z,bo,go,IsZero);
	input [15:0] x;
   input [15:0] y;
   input [2:0] en;
	input go;
   output [15:0] z;
	output bo,IsZero;
	wire[15:0] in0,in1,in2,in3,in4,in5,in6;
	wire carry;
	assign IsZero=~(z[0] | z[1] | z[2] | z[3] | z[4] | z[5] | z[6] | z[7] | z[8] | z[9] | z[10] | z[11] | z[12] | z[13] | z[14] | z[15]);
	assign bo=(x<y)?1:0;
	assign in0=x-y;
	assign in1=x+y;
	assign in2=x;
	assign in3=y+16'b0000000000000001;
	assign in4=16'b0000000000000000;
	assign in5=16'b0000000000000001;
	assign in6=y;
	genvar i;
	generate for(i=0;i<16;i=i+1)assign z[i]=(in0[i]&((~en[0])&(~en[1])&(~en[2])))|(in1[i]&((en[0])&(~en[1])&(~en[2])))|(in2[i]&((~en[0])&(en[1])&(~en[2])))|(in3[i]&((en[0])&(en[1])&(~en[2])))|(in4[i]&((~en[0])&(~en[1])&(en[2])))|(in5[i]&((en[0])&(~en[1])&(en[2])))|(in6[i]&((~en[0])&(en[1])&(en[2])));
	endgenerate
endmodule


module tristate(en,in1,in2,in3,out);
	input [15:0] in1,in2,in3;
	output [15:0] out;
	input[1:0] en; 
	genvar i;
	generate for(i=0;i<16;i=i+1)assign out[i]=(in1[i]&((en[0])&(~en[1])))|((in2[i]&((~en[0])&(en[1]))))|(in3[i]&((~en[0])&(~en[1])));
	endgenerate
endmodule


module reg16(x,load,rst,y);
	input [15:0]x;
	input load;		
	input rst;
	output [15:0] y;
	assign y=(load)?x:y;
endmodule


module unsignedDiv(dividend,divisor,load,over,quot,rem);
	input [15:0] dividend;
	input [15:0] divisor;
	input load;
	output [15:0] quot; 
	output [15:0] rem;
	output over;
	assign rem=((rem>=divisor)&&(load))?rem-divisor:((load)?rem:dividend);
	assign quot=((rem>=divisor)&&(load))?quot+16'b0000000000000001:((load)?quot:16'b0000000000000000);
	assign over=((rem<divisor)&&(load))?1:0;
endmodule


module adder( a ,b ,sum ,carry );

	output [15:0] sum ;
	output carry ;

	input [15:0] a ;
	input [15:0] b ; 

	wire [14:0]s;

	full_adder u0 (a[0],b[0],1'b0,sum[0],s[0]);
	full_adder u1 (a[1],b[1],s[0],sum[1],s[1]);
	full_adder u2 (a[2],b[2],s[1],sum[2],s[2]);
	full_adder u3 (a[3],b[3],s[2],sum[3],s[3]);
	full_adder u4 (a[4],b[4],s[3],sum[4],s[4]);
	full_adder u5 (a[5],b[5],s[4],sum[5],s[5]);
	full_adder u6 (a[6],b[6],s[5],sum[6],s[6]);
	full_adder u7 (a[7],b[7],s[6],sum[7],s[7]);
	full_adder u8 (a[8],b[8],s[7],sum[8],s[8]);
	full_adder u9 (a[9],b[9],s[8],sum[9],s[9]);
	full_adder u10 (a[10],b[10],s[9],sum[10],s[10]);
	full_adder u11 (a[11],b[11],s[10],sum[11],s[11]);
	full_adder u12 (a[12],b[12],s[11],sum[12],s[12]);
	full_adder u13 (a[13],b[13],s[12],sum[13],s[13]);
	full_adder u14 (a[14],b[14],s[13],sum[14],s[14]);
	full_adder u15 (a[15],b[15],s[14],sum[15],carry);

endmodule


module subtractor( a ,b ,diff ,borrow );

	output [15:0] diff ;
	output borrow ;

	input [15:0] a ;
	input [15:0] b ; 

	wire [14:0] s; 
	wire [15:0] l;
	
	assign l = 16'b1111111111111111 ^ b;

	full_adder u0 (a[0],l[0],1'b1,diff[0],s[0]);
	full_adder u1 (a[1],l[1],s[0],diff[1],s[1]);
	full_adder u2 (a[2],l[2],s[1],diff[2],s[2]);
	full_adder u3 (a[3],l[3],s[2],diff[3],s[3]);
	full_adder u4 (a[4],l[4],s[3],diff[4],s[4]);
	full_adder u5 (a[5],l[5],s[4],diff[5],s[5]);
	full_adder u6 (a[6],l[6],s[5],diff[6],s[6]);
	full_adder u7 (a[7],l[7],s[6],diff[7],s[7]);
	full_adder u8 (a[8],l[8],s[7],diff[8],s[8]);
	full_adder u9 (a[9],l[9],s[8],diff[9],s[9]);
	full_adder u10 (a[10],l[10],s[9],diff[10],s[10]);
	full_adder u11 (a[11],l[11],s[10],diff[11],s[11]);
	full_adder u12 (a[12],l[12],s[11],diff[12],s[12]);
	full_adder u13 (a[13],l[13],s[12],diff[13],s[13]);
	full_adder u14 (a[14],l[14],s[13],diff[14],s[14]);
	full_adder u15 (a[15],l[15],s[14],diff[15],borrow);

endmodule


module full_adder ( a ,b ,c ,sum ,carry );

	output sum ;
	output carry ;

	input a ;
	input b ;
	input c ;
   
	assign sum = a ^ b ^ c;  
	assign carry = (a&b) | (b&c) | (c&a);

endmodule  

