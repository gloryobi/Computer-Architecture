`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:12:53 02/07/2017
// Design Name:   ripple_carry_four_bit
// Module Name:   /home/kartik/Xilinx/14.7/ISE_DS/ALU_1_bit/tb_ripple_carry_4_bit.v
// Project Name:  ALU_1_bit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ripple_carry_four_bit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_ripple_carry_4_bit;

	// Inputs
	reg [3:0] A;
	reg [3:0] B;
	reg Cin;
	reg [2:0] control;

	// Outputs
	wire Cout;
	wire [3:0] result;

	// Instantiate the Unit Under Test (UUT)
	ripple_carry_four_bit uut (
		.A(A), 
		.B(B), 
		.Cin(Cin), 
		.control(control), 
		.Cout(Cout), 
		.result(result)
	);

	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		Cin = 0;
		control = 2;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
      #5 A=4'b0000 ; B=4'b0001;
      #1 $display("The result : %d, Cout : %d\n", result, Cout);		
      #5 A=4'b1111; B=4'b0010;
		#1 $display("The result : %d, Cout : %d\n", result, Cout);
      #5 A=4'b1111; B=4'b1111;
      #1 $display("The result : %d, Cout : %d\n", result, Cout);
		
	end
      
endmodule

