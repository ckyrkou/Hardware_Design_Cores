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

(* USE_DSP48="NO" *)module GenericMultiplier(multiplicand,multiplier,product);
parameter bitwidthA=8;
parameter bitwidthB=8;

parameter signedVectorInputs = 1;

	//2 - both are signed
	//1 - multiplier is signed
	//0 - unsigned

localparam multWidth = bitwidthA+bitwidthB;
input[bitwidthA-1:0] multiplicand;
input[bitwidthB-1:0] multiplier;
output [multWidth-signedVectorInputs-1:0] product;

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

generate

if(signedVectorInputs == 2)begin

	xor(sign,multiplicand[bitwidthA-1],multiplier[bitwidthB-1]);
	wire[multWidth-3:0] productMult;
	
	assign productMult = multiplicand[bitwidthA-2:0]*multiplier[bitwidthB-2:0];

	assign product = (sign) ? ~(productMult)+1 : productMult;	
	
end

if(signedVectorInputs == 1)begin

	wire[multWidth-2:0] productMult;
	wire[bitwidthB-2:0] multiplierPosNum;
	assign multiplierPosNum=(multiplier[bitwidthB-2:0]);
	assign productMult = multiplicand*multiplierPosNum;

	assign product = (multiplier[bitwidthB-1]) ? ~(productMult)+1 : productMult;	
	
end

if(signedVectorInputs == 0)begin
	
	assign product = multiplicand*multiplier;	
	
end

	

endgenerate

endmodule
