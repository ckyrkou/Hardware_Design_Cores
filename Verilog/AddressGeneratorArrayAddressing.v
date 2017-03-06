`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:53:23 03/06/2009 
// Design Name: 
// Module Name:    AddressGenerator 
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
module AddressGeneratorArrayAddressing(clock,reset,enable, lastElement,lastVectorGroup,address);
`include  "functions.v" 
	 
parameter dim = 4;
parameter max=8;
localparam numOfGroups = max/dim;
localparam dimensionality = dim-1;
localparam MaxAddress = max-1;

localparam bitwidth=log2(max-1);

//reg[bitwidth:0] counter=0;
//reg[bitwidth:0] groupCounter=0;
reg[bitwidth:0] dimCounter=0;


output reg lastElement; // new group read
output reg lastVectorGroup; // 

input enable;
input clock;
input reset;
/*
output [bitwidth-1:0] address;

always@(posedge clock)begin

	if(reset == 1)begin
		counter=0;
		dimCounter=0;
		lastElement = 0;
		groupCounter = 0;
		lastVectorGroup <= 0;
	end
	else begin
		if(enable == 1)begin
		
			dimCounter = counter;
			
			if(dimCounter == dimensionality)begin
				counter = 0;
				lastElement = 1;
				if(groupCounter == numOfGroups-1)begin
					lastVectorGroup <= 1;
					groupCounter = groupCounter;
				end
				else begin
					lastVectorGroup <= 0;
					groupCounter = groupCounter + 1;
				end
			end
			else begin
				counter = counter + 1;
				groupCounter = groupCounter;
				lastVectorGroup <= lastVectorGroup;
				lastElement = 0;
			end
		end	
		else begin
			lastElement = 0;
			dimCounter = dimCounter;
			lastVectorGroup <= lastVectorGroup;
			counter = counter;
			groupCounter = groupCounter;
		end
	end
	
end


assign address = groupCounter*dimensionality + dimCounter;
*/

output reg[bitwidth-1:0] address;

always@(posedge clock)begin

	if(reset == 1)begin
		dimCounter <= 0;
		lastElement <= 0;
		lastVectorGroup <= 0;
		address <= 0;
	end
	else begin
		if(enable == 1)begin
			
			address <= address + 1;
			dimCounter <= dimCounter + 1;
			if(address == MaxAddress)begin
				lastVectorGroup <= 1;
				address <= 0;
			end
				
			if(dimCounter == dimensionality-1)begin
				dimCounter <= 0;
				lastElement <= 1;
			end
			else
				lastElement <= 0;

			/*
			if(address == MaxAddress)begin
				lastVectorGroup = 1;
				counter = counter;
			end
			else begin
				lastVectorGroup = 0;
				address <= address + 1;
			end	
			*/
		end
		else begin
			lastElement <= 0;
			dimCounter <= dimCounter;
			lastVectorGroup <= lastVectorGroup;
			address <= address;
		end
	end
	
end

endmodule
