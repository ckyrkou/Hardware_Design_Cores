`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:57 05/29/2009 
// Design Name: 
// Module Name:    nBitGenericMultiplier 
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
module GenericMultiplierRstClk(clock,reset,multiplicand,multiplier,product);

parameter bitwidthA=8;
parameter bitwidthB=8;

input clock,reset;
input[bitwidthA-1:0] multiplicand;
input[bitwidthB-1:0] multiplier;

output reg[bitwidthA+bitwidthB-1:0] product;

always@(posedge clock, posedge reset)begin

	if(reset)
		product = 0;
	else
		product = multiplicand*multiplier;
	
end

endmodule
