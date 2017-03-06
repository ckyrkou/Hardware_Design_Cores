`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:20:02 06/01/2009 
// Design Name: 
// Module Name:    2to1Mux 
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
module Mux2to1(inA,inB,sel,out);

parameter bitwidth=25;

input[bitwidth-1:0] inA;
input[bitwidth-1:0] inB;
input sel;
output[bitwidth-1:0] out;

assign out = ( sel == 0 )? inA : inB;

endmodule
