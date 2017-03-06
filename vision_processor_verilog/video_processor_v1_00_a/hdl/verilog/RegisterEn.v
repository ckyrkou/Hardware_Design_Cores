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
module RegisterEn(clk,enable,reset,dataIn,dataOut);

parameter n=8;

input clk,reset,enable;
input[n-1:0] dataIn;
output reg[n-1:0] dataOut = 0;

always@(posedge clk,posedge reset)begin

	if(reset)
		dataOut <= 0;
	else
		if(enable)
			dataOut <= dataIn;
		else
			dataOut <= dataOut;

end

endmodule

