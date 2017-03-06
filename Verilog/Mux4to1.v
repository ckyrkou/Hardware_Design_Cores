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
module Mux4to1(input1,input2,input3,input4,sel,out);

parameter bitwidth=8;

input[bitwidth-1:0] input1,input2,input3,input4;
input[1:0] sel;
output reg[bitwidth-1:0] out;

always @*
      case (sel)
         2'b00: out = input1;
         2'b01: out = input2;
         2'b10: out = input3;
         2'b11: out = input4;
      endcase

endmodule
