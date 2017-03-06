`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:51:10 05/29/2009 
// Design Name: 
// Module Name:    genericMacUnit 
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
module GenericMacUnit(clock,reset,enable,operandA,operandB,AccResult);

parameter bitwidthA=8;
parameter bitwidthB=8;
parameter AccCycles=400;
parameter bitwidthAccRes=25;

input reset;
input clock;
input enable;
input[bitwidthA-1:0] operandA; 
input[bitwidthB-1:0] operandB;
wire[bitwidthA+bitwidthB-1:0] product;
output[bitwidthAccRes-1:0] AccResult;

GenericMultiplierEn #(bitwidthA,bitwidthB) mult1(enable,operandA,operandB,product);
GenericAccumulator #(bitwidthA+bitwidthB,AccCycles,bitwidthAccRes) acc1(clock,reset,enable,product,AccResult); 

endmodule
