`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:35:23 11/29/2007 
// Design Name: 
// Module Name:    VGAclockDivider 
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
module ClockDivider(sysClock, newClock);
parameter max=2;
parameter bitwidth=2;
input sysClock;
output reg newClock=0;
reg[bitwidth-1:0] counter=3'b000; 

always@(posedge sysClock)
begin

	counter=counter+1;
	
	if(counter == max)
		begin
			newClock = 0;
			counter = 3'b000;
		end
	else
		begin
			newClock = 1;
			counter = counter;
		end
end

endmodule
