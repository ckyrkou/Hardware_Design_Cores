`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:59:38 05/29/2012 
// Design Name: 
// Module Name:    testMAC 
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
module MAC(clock,reset,enable,A,B,P);

parameter Abitwidth=8;
parameter Bbitwidth=12;
parameter Pbitwidth=62;

input clock,reset,enable;

input [Abitwidth-1:0] A;
input signed[Bbitwidth-1:0] B;

output reg signed[Pbitwidth-1:0] P=0;

	
	always@(posedge clock)begin

		if(reset)
			P <= 0;
		else
			if(enable)
				P <= P + $signed({1'b0,A})*B;
	end
	

endmodule
