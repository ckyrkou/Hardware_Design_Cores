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
module GenericSubtractor(A,B,sum);

parameter Abitwidth=21;
parameter Bbitwidth=21;
parameter Sbitwidth=22;

input[Abitwidth-1:0] A;
input[Bbitwidth-1:0] B;

output reg[Sbitwidth-1:0] sum;

always@(A or B)begin

	sum = A - B;

end

endmodule
