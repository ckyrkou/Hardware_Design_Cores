`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:43 03/03/2009 
// Design Name: 
// Module Name:    adder 
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
module GenericAdderHandshake(clock,reset,A,B,enable,sum,ready);

parameter Abitwidth=21;
parameter Bbitwidth=21;
parameter Sbitwidth=22;

input clock;
input reset;
input[Abitwidth-1:0] A;
input[Bbitwidth-1:0] B;
input enable;
output reg[Sbitwidth-1:0] sum=0;
output reg ready=0;

always@(posedge clock or posedge reset)begin
	
	if(reset == 1)begin
		sum = 0;
		ready = 0;
	end
	else begin
		if(enable == 1)begin
			sum = A + B;
			ready = 1;
		end
		else begin
			sum = sum;
			ready = ready;
		end
	end
	
end

endmodule
