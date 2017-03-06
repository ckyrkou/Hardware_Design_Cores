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
module LogicShiftRegister(clk,reset,dataIn,dataOut,dir);

parameter bitwidth=8;
parameter shiftAmount=1;
parameter startingPoint = bitwidth -1 - shiftAmount;

input clk,reset;
input dir;
input[bitwidth-1:0] dataIn;
output reg[bitwidth-1:0] dataOut;

always@(posedge clk,posedge reset)begin
	
	if(reset)begin
		dataOut <= 0;
	end
	else begin
	   if(dir) begin // Right shift
		   dataOut[startingPoint:0] <= dataIn[bitwidth-1:1];
		   dataOut[bitwidth-1:startingPoint+1] <= 0;
		end
		else begin // Left shift
		   dataOut[bitwidth-1:shiftAmount] <= dataIn[startingPoint:0];
		   dataOut[shiftAmount-1:0] <= 0;
		end
	end
	
end

endmodule

