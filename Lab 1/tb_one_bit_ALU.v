`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:55:02 02/07/2017
// Design Name:   one_bit_ALU
// Module Name:   /home/kartik/Xilinx/14.7/ISE_DS/ALU_1_bit/tb_one_bit_ALU.v
// Project Name:  ALU_1_bit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: one_bit_ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_one_bit_ALU;

	// Inputs
	reg A;
	reg B;
	reg Cin;
	reg [2:0] control;

	// Outputs
	wire Cout;
	wire result;

	// Instantiate the Unit Under Test (UUT)
	one_bit_ALU uut (
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
		control = 0;

		// Wait 100 ns for global reset to finish
		#100;
     
		// Add stimulus here
      $display("-------Now testing ADD logic ------");
      #5 A = 1 ; B = 1 ; Cin = 0; control = 2;
      #1 $display("The result is Cout: %d, result : %d \n", Cout, result);
      #5 A = 1 ; B = 0 ; Cin = 0; control = 2;
      #1 $display("The result is Cout: %d, result : %d \n", Cout, result);
      #5 A = 0 ; B = 0 ; Cin = 1; control = 2;
      #1 $display("The result is Cout: %d, result : %d \n", Cout, result);
      #5 A = 1 ; B = 1 ; Cin = 1; control = 2;
      #1 $display("The result is Cout: %d, result : %d \n", Cout, result);
      
      $display("-------Now testing AND logic------");
      #5 A = 1 ; B = 1 ; Cin = 1; control = 0;
      #1 $display("The result is Cout: %d, result : %d \n", Cout, result);
      
      $display("-------Now testing OR logic-------");
      #5 A = 0 ; B = 1 ; Cin = 1; control = 1;
      #1 $display("The result is Cout: %d, result : %d \n", Cout, result); 



	end
      
endmodule

