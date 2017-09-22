`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:49:06 02/07/2017 
// Design Name: 
// Module Name:    one_bit_ALU 
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
module one_bit_ALU(
    input A,
    input B,
    input Cin,										//port definitions
    input [2:0] control,
    output Cout,
    output result
    );
	 
    reg reg_Cout;									//register to hold carryout
    wire reg_result;								//wire to hold the result from 4x1 mux
	 
	 reg [3:0] mux_in;							//register to hold inputs for the 4x1 mux

	 Mux_4_to_1 M1(								//Use 4x1 mux to choose result depending on control input
				.A(mux_in),
				.B(reg_result),
				.control(control)
	 );
	 	 
    assign Cout = reg_Cout;
    assign result = reg_result;
	 
	 always @(*) 
	 begin
			mux_in[0] <= A & B;					//Control = 0 corresponds to AND operation
			mux_in[1] <= A|B;						//Control = 1 corresponds to OR operation
			mux_in[2] <= A^B^Cin;				//Control = 2 corresponds to sum operation
			mux_in[3] <= 0;						//Control = 3 just outputs 0
			reg_Cout  <= (A&Cin) | (B&Cin) | (A&B);		//assingment for Carry Out --> CarryOut = (b*CarryIn)+(a*CarryIn)+(a*b)
	 end

endmodule
