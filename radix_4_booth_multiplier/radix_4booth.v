`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:29:18 08/14/2016 
// Design Name: 
// Module Name:    radix_4booth 
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
module radix_4booth(mplier,mpcand,go,clk,pdt,over,reset);

	input[7:0] mplier,mpcand;
	input go,clk,reset;

	output[15:0] pdt;
	output over;

	wire[17:0] product,next_product;
	wire[3:0] load;
	wire[2:0] count,next_count;
	wire[1:0] next_state,fnsel,state;
	wire status;

	datapath dp(load,fnsel,mplier,mpcand,product,next_product,count,next_count,status,pdt);

	controller ctrl(go,status,state,next_state,load,product[2:0],fnsel,over);
	
	next nxt(product,next_product,state,next_state,count,next_count,clk,reset);

endmodule


module controller(go,status,state,next_state,load,l3b,fsel,over);

	input go,status;
	input[1:0] state;
	input[2:0] l3b;

	output[1:0] next_state,fsel;
	output[3:0] load; 
	output over;
	
	assign load[0]=(((~state[1])&(state[0]))|((state[1])&(~state[0])&((l3b[0]&l3b[1]&l3b[2])|((~l3b[0])&(~l3b[1])&(~l3b[2]))))|(state[1]&state[0]));
	assign load[1]=((state[1])&(~state[0]));
	assign load[2]=state[0];
	assign load[3]=((state[1])&(~state[0]));
	
	assign fsel[0]=(((l3b[0])&(l3b[1]))|((~l3b[0])&(~l3b[1])));
	assign fsel[1]=l3b[2];

	assign over=state[0]&state[1];
	
	assign next_state[0]=((~state[0])&(~state[1])&(go))|((state[0])&(~state[1])&(~status))|((state[1])&(~state[0]))|((state[0])&(state[1])&(~go));
	assign next_state[1]=((state[0])&(~state[1]))|((state[0])&(state[1])&(~go));

endmodule


module datapath(load,fnsel,mplier,mpcand,product,next_product,count,next_count,status,answer);

	input[3:0] load;
	input[1:0] fnsel;
	input[7:0] mplier,mpcand; 
	input[17:0] product;
	input[2:0] count;

	output[17:0] next_product;
	output[2:0] next_count;
	output status;
	output[15:0] answer;
	
	wire[8:0] z_bus;

	alu ALU0(fnsel,product[17:9],mpcand,z_bus);

	mux2 loadpdt({9'b000000000,mplier[7:0],1'b0},product[17:0],{z_bus[8],z_bus[8],z_bus[8:0],product[8:2]},{product[17],product[17],product[17:2]},load[1:0],next_product);

	mux3 loadcnt(count,load[3:2],next_count);

	assign answer=product[16:1];
	
	status_detector sd(count,status);

endmodule


module next(product,next_product,state,next_state,count,next_count,clk,reset);

	output[17:0] product;
	output[1:0] state;
	output[2:0] count;

	input[17:0] next_product;
	input[1:0] next_state;
	input[2:0] next_count;
	input clk,reset; 
	
	reg[17:0] product;
	reg[1:0] state;
	reg[2:0] count;

	always@(posedge clk)
	begin
		if(reset)begin
			state = 2'b00;
			count = 3'b100;
		end
		else begin
			state = next_state;
			product = next_product;
			count = next_count;
			$display("product=%h  state=%h count=%h nproduct=%h  nstate=%h ncount=%h ",product,state,count,next_product,next_state,next_count);
		end
	end
	
endmodule


// status=1 if count is non-zero
module status_detector(count,status);

	input[2:0] count;
	
	output status;

	assign status=(count[0]|count[1]|count[2]);
	
endmodule

module mux3(c,load,nc);

	input[1:0] load;
	input[2:0] c; 

	output[2:0] nc;

	wire[2:0] w;

	assign w[0]=~c[0];
	assign w[1]=(((c[0])&(c[1]))|((~c[0])&(~c[1])));
	assign w[2]=1'b0;
	assign nc[0]=(((load[1])&(w[0]))|((~load[1])&(load[0])&(c[0]))|((~load[1])&(~load[0])&(1'b0)));
	assign nc[1]=(((load[1])&(w[1]))|((~load[1])&(load[0])&(c[1]))|((~load[1])&(~load[0])&(1'b0)));
	assign nc[2]=(((load[1])&(w[2]))|((~load[1])&(load[0])&(c[2]))|((~load[1])&(~load[0])&(1'b1)));

endmodule


module mux2(in0,in1,in2,in3,sel,out);

	input[17:0] in0,in1,in2,in3;
	input[1:0] sel;

	output[17:0] out;

	generate
		genvar i;
		for(i=0;i<18;i=i+1)begin
			assign out[i]=(((in0[i])&(~sel[0])&(~sel[1]))|((in1[i])&(sel[0])&(~sel[1]))|((in2[i])&(sel[1])&(~sel[0]))|((in3[i])&(sel[0])&(sel[1])));
		end
	endgenerate

endmodule


module alu(fsel,x,y,z);

	input[8:0] x;
	input[7:0] y;
	input[1:0]fsel;

	output[8:0] z;

	wire[8:0] sum,diff;
	wire[8:0] w0;
	wire w1,w2;
	
	mux1 m10(sum,diff,fsel[1],z);
	mux1 m11({y[7],y[7:0]},{y[7:0],1'b0},fsel[0],w0);
	
	adder add(x,w0,sum,w1);

	subtractor sub(x,w0,diff,w2);
	
endmodule


module mux1(a,b,sel,out);

	input[8:0] a,b;
	input sel;

	output[8:0] out;
	
	mux0 m00(a[0],b[0],sel,out[0]);
	mux0 m01(a[1],b[1],sel,out[1]);
	mux0 m02(a[2],b[2],sel,out[2]);
	mux0 m03(a[3],b[3],sel,out[3]);
	mux0 m04(a[4],b[4],sel,out[4]);
	mux0 m05(a[5],b[5],sel,out[5]);
	mux0 m06(a[6],b[6],sel,out[6]);
	mux0 m07(a[7],b[7],sel,out[7]);
	mux0 m08(a[8],b[8],sel,out[8]);

endmodule


module mux0(a,b,sel,out);

	input a,b,sel;

	output out;

	assign out=(a & (~sel)) | ( b&sel );

endmodule


module adder( a ,b ,sum ,carry );

	input [8:0] a ;
	input [8:0] b ; 

	output [8:0] sum ;
	output carry ;

	wire [7:0]s;

	full_adder u10 (a[0],b[0],1'b0,sum[0],s[0]);
	full_adder u11 (a[1],b[1],s[0],sum[1],s[1]);
	full_adder u12 (a[2],b[2],s[1],sum[2],s[2]);
	full_adder u13 (a[3],b[3],s[2],sum[3],s[3]);
	full_adder u14 (a[4],b[4],s[3],sum[4],s[4]);
	full_adder u15 (a[5],b[5],s[4],sum[5],s[5]);
	full_adder u16 (a[6],b[6],s[5],sum[6],s[6]);
	full_adder u17 (a[7],b[7],s[6],sum[7],s[7]);
	full_adder u18 (a[8],b[8],s[7],sum[8],carry);

endmodule


module subtractor( a ,b ,diff ,borrow,l );

	input [8:0] a ;
	input [8:0] b ; 

	output [8:0] diff ;
	output borrow ;
	output [8:0] l; 

	wire [7:0] s; 
	wire [8:0] l;
	
	assign l =( 9'b111111111 ^ b);

	full_adder u00 (a[0],l[0],1'b1,diff[0],s[0]);
	full_adder u01 (a[1],l[1],s[0],diff[1],s[1]);
	full_adder u02 (a[2],l[2],s[1],diff[2],s[2]);
	full_adder u03 (a[3],l[3],s[2],diff[3],s[3]);
	full_adder u04 (a[4],l[4],s[3],diff[4],s[4]);
	full_adder u05 (a[5],l[5],s[4],diff[5],s[5]);
	full_adder u06 (a[6],l[6],s[5],diff[6],s[6]);
	full_adder u07 (a[7],l[7],s[6],diff[7],s[7]);
	full_adder u08 (a[8],l[8],s[7],diff[8],borrow);

endmodule


module full_adder ( a ,b ,c ,sum ,carry );

	input a ; 
	input b ;
	input c ;
   
	output sum ;
	output carry ;

	assign sum = ((a ^ b) ^ c);  
	assign carry = (((a&b) | (b&c)) | (c&a));

endmodule  
