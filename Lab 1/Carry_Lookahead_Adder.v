`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:50:53 01/22/2017 
// Design Name: 
// Module Name:    Carry_Lookahead_Adder 
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
module Carry_Lookahead_Adder(
    input [3:0] A,
    input [3:0] B,
    output Cout,
    output [3:0] S,
    input Cin
    );

wire [3:0] P; //propagate values are stored here
wire [3:0] G; //generate values are stores 
wire [3:0] C; //carry for each bit position

reg [3:0] res;	//register to store sum values at each bit position

//instantiate modules for carry lookahead adder
PG_Block pg(A, B, P, G);							//find the propagate and generate values
Carry_Block_1 C1(C[0], P, G, Cin);				//find the carryout for bit position 1
Carry_Block_2 C2(C[1], P, G, C[0]);				//find the carryout for bit position 2
Carry_Block_3 C3(C[2], P, G, C[1]);				//find the carryout for bit position 3
Carry_Block_4 C4(C[3], P, G, C[2]);				//find the carryout for bit position 4 aka Cout

//Calculate the result
assign Cout = C[3];									//output Cout = c3
assign S = res;										//output sum = res

always @(*) 
begin
	res[0] <= A[0] ^ B[0] ^ Cin;					//Sum = A^B^Carry (compute for each bit position)
	res[1] <= A[1] ^ B[1] ^ C[0];					//and store values in register 'res'
	res[2] <= A[2] ^ B[2] ^ C[1];
	res[3] <= A[3] ^ B[3] ^ C[2];
end

endmodule
