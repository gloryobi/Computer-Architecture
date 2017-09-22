`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:56 01/22/2017 
// Design Name: 
// Module Name:    PG_Block_1 
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
module PG_Block(
    input [3:0] A,
    input [3:0] B,
    output [3:0] P,
    output [3:0] G
    );
	 
	 //pi = ai + bi
	 assign P[0] = A[0] | B[0];
	 assign P[1] = A[1] | B[1];
	 assign P[2] = A[2] | B[2];
	 assign P[3] = A[3] | B[3];
	 
	 //gi = ai * bi
	 assign G[0] = A[0] & B[0];
	 assign G[1] = A[1] & B[1];
	 assign G[2] = A[2] & B[2];
	 assign G[3] = A[3] & B[3];

endmodule
