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
module GenericAdderEn(A,B,enable,sum);

parameter Abitwidth=21;
parameter Bbitwidth=21;
parameter Sbitwidth=22;

input[Abitwidth-1:0] A;
input[Bbitwidth-1:0] B;
input enable;
output reg[Sbitwidth-1:0] sum;

always@(enable or A or B)begin

	if(enable == 1)begin
		sum = A + B;
	end
	else begin
		sum = 0;
	end
end

endmodule
