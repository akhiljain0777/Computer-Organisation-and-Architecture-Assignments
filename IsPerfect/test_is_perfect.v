`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:00:21 08/04/2016
// Design Name:   IsPerfect
// Module Name:   C:/Users/student/Desktop/COA 2016 asj/LAB3/test_is_perfect.v
// Project Name:  LAB3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: IsPerfect
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_is_perfect;

	// Inputs
	reg [15:0] N;
	reg go;
	reg clk;

	// Outputs
	wire over;
	wire IsPer;

	// Instantiate the Unit Under Test (UUT)
	IsPerfect uut (
		.N(N), 
		.go(go), 
		.clk(clk), 
		.over(over), 
		.IsPer(IsPer)
	);

	initial begin
		// Initialize Inputs
		N = 0;
		go = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end

	always
	#0.01 clk=~clk;
	always
	#0.05 go=~go;  
   always 
	begin
	if(N<65536)#0.1 N=N+1;
	end
      
endmodule

