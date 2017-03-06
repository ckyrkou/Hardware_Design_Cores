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
(* USE_DSP48="YES" *)module GenericMultiplierDSP48E(clock,enable,reset,A,B,P);

parameter Abitwidth=25;
parameter Bbitwidth=18;
parameter Pbitwidth=48;
parameter signedVectorInputs=0;

input clock,enable,reset;

input[Abitwidth-1:0] A;
input[Bbitwidth-1:0] B;

output[Pbitwidth-1:0] P;

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

DSP48Emac #(Abitwidth,Bbitwidth,Pbitwidth) mac(clock,reset,enable,A,B,P);

endmodule
