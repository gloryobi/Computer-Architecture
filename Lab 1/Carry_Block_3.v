`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:51:13 01/22/2017 
// Design Name: 
// Module Name:    Carry_Block_3 
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
module Carry_Block_3(
    output Cout,
    input [3:0] p,
    input [3:0] g,
    input Cin
    );
	 
	 assign Cout = g[2] | 
			(p[2] & (g[1] | 
			(p[1] & (g[0] | (p[0] & Cin)))));			//c3 = g2 + (p2*g1) + (p2*p1*g0) + (p2*p1*p0*c0)

endmodule
