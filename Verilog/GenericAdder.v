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

module GenericAdder(A,B,sum);

function integer max;
  input integer valueA;
  input integer valueB;
  begin
    if(valueA > valueB)
		max = valueA;
	else
		max = valueA;
	end
endfunction

parameter Abitwidth=28;
parameter Bbitwidth=28;
localparam Sbitwidth=max(Abitwidth,Bbitwidth)+1;

input signed[Abitwidth-1:0] A;
input signed[Bbitwidth-1:0] B;

output signed[Sbitwidth-1:0] sum;

assign sum = A + B; 

endmodule



