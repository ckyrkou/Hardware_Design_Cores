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
module GenericMacUnitDSP48E(reset,newData,operandA,operandB,AccResult);

parameter bitwidthA=8;
parameter bitwidthB=8;
parameter AccCycles=400;
parameter bitwidthAccRes=25;

input reset;
input newData;
input[bitwidthA-1:0] operandA; 
input[bitwidthB-1:0] operandB;
wire[bitwidthA+bitwidthB-1:0] product;
output[bitwidthAccRes-1:0] AccResult;

GenericMultiplierDSP48E #(bitwidthA,bitwidthB) mult1(operandA,operandB,product);
GenericAccumulatorDSP48E #(bitwidthA+bitwidthB,AccCycles,bitwidthAccRes) acc1(reset,newData,product,AccResult); 

endmodule
