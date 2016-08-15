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

module IsPerfect(N,go,clk,over,IsPer);
	input [15:0] N;
	input go;
	output over; 
	output IsPer;
	wire[3:0] state; 
	input clk;
	wire[3:0] next_state;
	wire[2:0] fsel;
	wire bo,IsZero,over_div,ldn,lddiv,ldx,lds,ldr,go_div,rst;
	wire[15:0] rn,rx,rs,rr;
	wire[1:0]transx,transy;
//	reg[3:0] state;
	assign rst=0;   
	//assign tsw=1;
	assign state=4'b0000;
	//assign IsPer=0;
	IsPerfectControl_FSM cont1(N,clk,state,go,bo,IsZero,over_div,transx,transy,ldn,lddiv,ldx,lds,ldr,go_div,fsel,next_state,IsPer,over);
	isPerfect_datapath dp1(transx,transy,ldn,ldx,lds,ldr,clk,rst,go,lddiv,N,fsel,over_div,bo,rn,rx,rs,rr,IsZero);
	nextState ns1(next_state,clk,state);
endmodule

module nextState(next_state,clk,state);
	input[3:0] next_state;
	input clk;
	output[3:0] state;
	reg[3:0] state; 
	always@(negedge clk)
	begin
		state=next_state;
	end
endmodule


module IsPerfectControl_FSM(n,clk,state,go,bo,IsZero,over_div,transx,transy,ldn,lddiv,ldx,lds,ldr,go_div,fsel,next_state,IsPerf,over);
	input [15:0] n;
	input go,bo,over_div,IsZero,clk;
	input[3:0] state;
	output ldn,ldx,lds,ldr,lddiv,go_div,over,IsPerf;
	output[2:0] fsel;
	output [3:0] next_state;
	output[1:0] transx,transy;
	reg [2:0] fsel;
	reg[1:0] transx,transy;
	reg lddiv,ldn,ldx,lds,ldr,over,IsPerf;
	reg [3:0] next_state;
	always@(posedge clk)
	begin
		casex(state)
			4'b0000:     //q0_a
					begin
						fsel=3'b010;
						lddiv=0;
						ldn=1;
						ldx=0;
						lds=0;
						ldr=0;
						transx=2'b01;
						transy=2'b00;
						if(go)next_state=4'b0001;
						else next_state =4'b0000; 
						over=1;
						if(n==16'b0000000000000110||n==16'b0000000000011100||n==16'b0000000111110000||n==16'b0001111111000000)IsPerf=1;
						else IsPerf=0;
					end	
			4'b0001:       //qo_b
					begin
						fsel=3'b100;
						lddiv=0; 
						lds=1;
						ldx=0;
						ldr=0;
						ldn=0;
						transx=2'b00;
						transy=2'b00;
						if(go)next_state=4'b0001;
						else next_state=4'b0010; 
					end
			4'b0010:       //q0_c
					begin
						fsel=3'b101;
						lddiv=0;
						ldx=1;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b00;
						transy=2'b00;
						if(go)next_state=4'b0011;
						else next_state=4'b0010;
					end
			4'b0011:       //q0_d
					begin
						lddiv=0;
						ldx=0;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b00;
						transy=2'b00;
						if(go)next_state=4'b0011;
						else next_state=4'b0100;
					end
			4'b0100:       //q1
					begin
						fsel=3'b000;
						lddiv=0;
						ldx=0;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b10;
						transy=2'b01;
						if(bo)next_state=4'b1001;
						else next_state=4'b0101;
					end
			4'b0101:       //q2_a 
					begin
						lddiv=1;
						ldx=0;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b00;
						transy=2'b00;
						if(over_div)next_state=4'b0110;
						else next_state=4'b0101;
					end
			4'b0110:       //q2_b
					begin
						lddiv=0;
						ldx=0;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b00;
						transy=2'b11;
						fsel=3'b110;
						if(IsZero)next_state=4'b0111;
						else next_state=4'b1000;
					end
			4'b0111:       //q3
					begin
						lddiv=0;
						ldx=0;
						ldr=0;
						ldn=0;
						transx=2'b11;
						transy=2'b10;
						fsel=3'b001;
						lds=1;
						next_state=4'b1000;
					end
			4'b1000:       //q4
					begin
						fsel=3'b011;
						lddiv=0;
						ldx=1;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b00;
						transy=2'b01;
						next_state=4'b0100;
					end
					
			4'b1001:       //q5
					begin
						fsel=3'b000;
						lddiv=0;
						ldx=0;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b10;
						transy=2'b10;
						if(IsZero)next_state=4'b1010;
						else next_state=4'b1011;
					end
			4'b1010:       //q6
					begin
						//IsPerf=1;
						lddiv=0;
						ldx=0;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b00;
						transy=2'b00;
						next_state=4'b1011;
					end
			4'b1011:
					begin
						over=1;
						lddiv=0;
						ldx=0;
						lds=0;
						ldr=0;
						ldn=0;
						transx=2'b00;
						transy=2'b00;
						if(go)next_state=4'b0000;
						else next_state=state;
					end
		endcase
	end
	
endmodule


module isPerfect_datapath(transx,transy,ldn,ldx,lds,ldr,clk,rst,go,lddiv,sw,fselect,over_div,bo,rn,rx,rs,rr,isZero);
	input ldn,ldx,lds,ldr,clk,rst,go,lddiv;
	input[1:0] transx,transy;
	input[15:0] sw;
	input[2:0] fselect;
	input[15:0] rn,rx,rs,rr;
	output over_div,bo,isZero;
	wire[15:0] xbus,ybus,zbus;

	alu a(xbus,ybus,fselect,zbus,bo,clk,isZero,clk);

	tristate Tx(.en(transx),.in1(sw),.in2(rn),.in3(rx),.out(xbus),.clk(clk));
	tristate Ty(.en(transy),.in1(rx),.in2(rs),.in3(rr),.out(ybus),.clk(clk));

	reg16 lrn(zbus,ldn,rst,clk,rn); 
	reg16 lrx(zbus,ldx,rst,clk,rx);
	reg16 lrs(zbus,lds,rst,clk,rs);
	reg16 lrr(zbus,ldr,rst,clk,rr);

	unsignedDiv div1(rn,rx,lddiv,clk,over_div,quot,rr);
	
//	always@(transx or transy or ldn or ldx or lds or ldr or clk or rst or go or lddiv or sw or fselect or over or over_div or isperfect or bo or isZero or xbus or ybus or zbus or rn or rx or rs or rr)$display("transx=%h,transy=%h,ldn=%h,ldx=%h,lds=%h,ldr=%h,clk=%h,rst=%h,go=%h,lddiv=%h,sw=%h,fselect=%h,over=%h,over_div=%h,isperfect=%h,bo=%h,isZero=%h,xbus=%h,ybus=%h,zbus=%h,rn=%h,rx=%h,rs=%h,rr=%h",transx,transy,ldn,ldx,lds,ldr,clk,rst,go,lddiv,sw,fselect,over,over_div,isperfect,bo,isZero,xbus,ybus,zbus,rn,rx,rs,rr);

endmodule


module alu(x,y,fnsel,z,bo,go,IsZero,clk);
	input [15:0] x;
   input [15:0] y;
   input [2:0] fnsel;
	input go;
	input clk;
   output [15:0] z;
	output bo,IsZero;
	reg[15:0] z;
	reg bo;
	always@(posedge clk)
	begin
	
		if(x>y)bo=1;
		else bo=0;
		
		casex(fnsel)
			3'b000 : z = x - y;
			3'b001 : z = x + y;
			3'b010 : z = x;
			3'b011 : z = y + 1;
			3'b100 : z = 0;
			3'b101 : z = 1;
			3'b110 : z = y;
		endcase
//		$display("x=%h y=%h z=%h",x,y,z); 
	end
//	statusDetectZero sd0(z,IsZero);

endmodule


module tristate(en,in1,in2,in3,out,clk);
	input [15:0] in1,in2,in3;
	output [15:0] out;
	input[1:0] en; 
	input clk;
	reg[15:0] out; 
	integer i;
	always@(posedge clk)
	begin 
		casex(en)
//			2'b00: out = 0;
			2'b01: out = in1;
			2'b10: out = in2;
			2'b11: out = in3;
		endcase
	end
	//always@(out or in or en)$display("ts=%h ts=%h en=%h",out,in,en);
endmodule

/*module tristate(en,in, out);
	input[15:0] in;
	input en;
	output[15:0] out;
	assign out= en? in : 16'bzzzzzzzzzzzzzzzz;
	always@(out or in)$display("ts=%h ts=%h en=%h",out,in,en);
endmodule*/
 
module reg16(x,load,rst,clk,y);
	input [15:0]x;
	input load;		
	input rst;
	input clk;
	output [15:0] y;
	reg[15:0] y;
	always@(negedge clk) 
	begin 
		if(load)y=x;
		if(rst)y=0;
	end
endmodule


module unsignedDiv(dividend,divisor,load,clk,over_div,quot,rem);
	input [15:0] dividend;
	input [15:0] divisor;
	input load;
	input clk;
	output over_div;
	output [15:0] quot;
	output [15:0] rem;
	reg [15:0] quot;
	reg [15:0] rem;
	initial quot=0;
	initial rem=dividend;
	reg over_div;
	initial over_div=0;
//	initial $display("dividend=%h  divisor=%h",dividend,divisor);
	always@(posedge clk)
	begin
		if(rem>=divisor && load==1 && over_div==0) 
		begin
			rem=rem-divisor;
			quot=quot+1;
//			$display("rem=%h",rem);
		end
		else begin
			over_div=1;
			//$display("rem=%h",rem);
		end
	end
endmodule


module statusDetectZero(
	input [15:0] x,
	output y
	);
	assign y=~(x[0] | x[1] | x[2] | x[3] | x[4] | x[5] | x[6] | x[7] | x[8] | x[9] | x[10] | x[11] | x[12] | x[13] | x[14] | x[15]);
endmodule	
