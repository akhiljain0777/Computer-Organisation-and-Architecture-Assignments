`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:29:08 08/15/2016
// Design Name:   radix_4booth
// Module Name:   D:/lab5/radix_booth/radix_tst.v
// Project Name:  radix_booth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: radix_4booth
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module radix_tst;

	// Inputs
	reg [7:0] mplier;
	reg [7:0] mpcand;
	reg go;
	reg clk;
	reg reset;

	// Outputs
	wire [15:0] pdt;
	wire over;

	// Instantiate the Unit Under Test (UUT)
	radix_4booth uut (
		.mplier(mplier), 
		.mpcand(mpcand), 
		.go(go), 
		.clk(clk), 
		.pdt(pdt), 
		.over(over), 
		.reset(reset)
	);

	initial begin
		mplier = 13;
		mpcand = 27;
		go = 0;
		clk = 0;
		reset = 1;
		#2 reset = 0;
		
		#25 mplier = 25;
		mpcand = -7;
		reset = 1;
		#2 reset = 0;

		#25 mplier = -18;
		mpcand = 17;
		reset = 1;
		#2 reset = 0;

		#25 mplier = -19;
		mpcand = -33;
		reset = 1;
		#2 reset = 0;

		#25 mplier = 0;
		mpcand = 5;
		reset = 1;
		#2 reset = 0;

		#25 mplier = 18;
		mpcand = -8;
		reset = 1;
		#2 reset = 0;

	end

	always #1 clk=~clk;      
	always #6 go=~go;      

endmodule

