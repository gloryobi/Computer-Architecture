`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:39:40 02/07/2017 
// Design Name: 
// Module Name:    Mux_4_to_1 
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
module Mux_4_to_1(
    input [3:0] A,
    output B,
    input [1:0] control
    );

//this is an example of a 4:1 mux
reg reg_B;
assign B=reg_B;

always @(*)
begin
   //use case statement to implement the multiplexer
   case(control)
	   2'b00: begin
		         reg_B=A[0];
		       end //select the first input 
      2'b01: begin
		         reg_B=A[1];
		       end  //select the second input
	   2'b10: begin
		         reg_B=A[2];
		       end //select the third input
	   2'b11: begin
		         reg_B=A[3];
		        end //select the fourth input
    endcase
end

endmodule