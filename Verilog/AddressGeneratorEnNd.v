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
module AddressGeneratorEnNd(clock,reset,enable,address,nd);
	 
parameter MaxAddress=20;
parameter bitwidth=5;

reg[bitwidth-1:0] counter=0;

output reg nd=0;

output reg[bitwidth-1:0] address=0;

input enable;
input clock;
input reset;

always@(posedge clock or posedge reset)begin

	if(reset == 1)begin
		counter=0;
		address=0;
		nd = 0;
	end
	else begin
		if(enable == 1)begin
			address = counter;
			counter = counter + 1;
			nd = 1;
			if(counter == MaxAddress)begin
				counter = 0;
			end
			else begin
				counter = counter;
			end
		end
		else begin
			nd = 0;
			address = address;
			counter = counter;
		end
	end
	
end



endmodule
