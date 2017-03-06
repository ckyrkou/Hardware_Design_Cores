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
module GenericMultiplierEn(multiplicand,multiplier,product);

parameter bitwidthA=8;
parameter bitwidthB=8;

input enable;
input[bitwidthA-1:0] multiplicand;
input[bitwidthB-1:0] multiplier;

output reg[bitwidthA+bitwidthB-1:0] product;

always@(enable,multiplicand,multiplier)begin
	
	if(enable)
		product = multiplicand*multiplier;
	else
		product = 0;
	
end

endmodule
