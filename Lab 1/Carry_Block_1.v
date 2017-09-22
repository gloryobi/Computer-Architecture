`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:01:41 01/22/2017 
// Design Name: 
// Module Name:    Carry_Block_1 
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
module Carry_Block_1(
    output Cout,
    input [3:0] p,
    input [3:0] g,
    input Cin    
    );
	 
	 assign Cout = g[0] | (p[0] & Cin);				//c1 = g0 + (p0*c0)
	 
endmodule

//get the solution for the carry lookahead adder !
