`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:59:59 02/07/2017 
// Design Name: 
// Module Name:    ripple_carry_four_bit 
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
module ripple_carry_four_bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
	 input [2:0] control,						//control should always equal 2 because that is the ADD operation in the ALU
    output Cout,
	 output [3:0] result
    );
	 
	 wire [2:0] carry;				//internal carry wires

	 one_bit_ALU A1 (A[0], B[0], Cin, control, carry[0], result[0]);			//call the first 1-bit ALU
	 one_bit_ALU A2 (A[1], B[1], carry[0], control, carry[1], result[1]);	//call the second 1-bit ALU
	 one_bit_ALU A3 (A[2], B[2], carry[1], control, carry[2], result[2]);	//call the third 1-bit ALU
	 one_bit_ALU A4 (A[3], B[3], carry[2], control, Cout, result[3]);			//call the fourth 1-bit ALU

endmodule
