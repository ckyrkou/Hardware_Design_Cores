`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:07 05/29/2009 
// Design Name: 
// Module Name:    nBitRegister 
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
module RegisterAccChain(clk,reset,dataIn,dataOut);

parameter n=8;

input clk,reset;
input[n-1:0] dataIn;
output reg[n-1:0] dataOut=0;

always@(posedge clk)begin

	if(reset)
		dataOut <= 1;
	else
	   dataOut <= dataIn;

end

endmodule

