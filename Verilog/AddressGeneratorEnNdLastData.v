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
module AddressGeneratorEnNdLastData(clock,reset,enable,address,nd,lastData);
	 
parameter MaxAddress=20;
parameter bitwidth=5;

reg[bitwidth-1:0] counter=0;

output reg nd=0;
output reg lastData=0;
output reg[bitwidth-1:0] address=0;

input enable;
input clock;
input reset;

always@(posedge clock or posedge reset)begin

	if(reset == 1)begin
		counter=0;
		address=0;
		nd = 0;
		lastData = 0;
	end
	else begin
		if(enable == 1)begin
			address = counter;
			counter = counter + 1;
			nd = 1;
			if(counter == MaxAddress)begin
				counter = 0;
				lastData = 1;
			end
			else begin
				counter = counter;
				lastData = 0;
			end
		end
		else begin
			nd = 0;
			lastData = lastData;
			address = address;
			counter = counter;
		end
	end
	
end

endmodule
