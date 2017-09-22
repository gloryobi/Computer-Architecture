`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:54:25 01/22/2017 
// Design Name: 
// Module Name:    Carry_Block_4 
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
module Carry_Block_4(
    output Cout,
    input [3:0] p,
    input [3:0] g,
    input Cin
    );
	 
	 assign Cout = g[3] | 
			(p[3] & (g[2] | 
			(p[2] & (g[1] | 
			(p[1] & (g[0] | (p[0] & Cin)))))));			//c4 = g3 + (p3*g2) + (p3*p2*g1) + (p3*p2*p1*g0) + (p3*p2*p1*p0*c0)

endmodule
