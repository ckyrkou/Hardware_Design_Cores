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
module GenericMultiplier(multiplicand,multiplier,product); // synthesis attribute use_dsp48 GenericMultiplier no; 

parameter bitwidthA=20;
parameter bitwidthB=40;

localparam multWidth = bitwidthA+bitwidthB;
input[bitwidthA-1:0] multiplicand;
input[bitwidthB-1:0] multiplier;
output reg [multWidth-1:0] product;

/*
input clk;
reg [multWidth-1:0] product1;
reg [multWidth-1:0] product2;

// MUlitplier With two pipeline stages
always @(posedge clk)
begin
		product1 <= multiplicand * multiplier;
		product2 <= product1; 
		product <= product2;
end
*/
always@(multiplicand,multiplier)begin

	product = multiplicand*multiplier;
	
end


endmodule
