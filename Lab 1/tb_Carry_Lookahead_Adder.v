`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:43:54 01/23/2017
// Design Name:   Carry_Lookahead_Adder
// Module Name:   /home/kartik/Xilinx/14.7/ISE_DS/Carry_Lookahead_Adder/tb_Carry_Lookahead_Adder.v
// Project Name:  Carry_Lookahead_Adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Carry_Lookahead_Adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_Carry_Lookahead_Adder;

	// Inputs
	reg [3:0] A;
	reg [3:0] B;
	reg Cin;

	// Outputs
	wire Cout;
	wire [3:0] S;

	// Instantiate the Unit Under Test (UUT)
	Carry_Lookahead_Adder uut (
		.A(A), 
		.B(B), 
		.Cout(Cout), 
		.S(S), 
		.Cin(Cin)
	);

	initial begin
		// Initialize Inputs
		A = 4'b1111;
		B = 4'b1111;
		Cin = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		$display("----Beginning simulation ! ---\n");
		
		#5 $display("The result is %d, Carry out is %d  \n ", S, Cout);
	
	   // Wait 
      
      #5
		A = 4'b1001;
		B = 4'b0001;
		Cin = 1;
		#5 $display("The result is %d, Carry out is %d  \n ", S, Cout);

		// Add stimulus here

	end
      
endmodule