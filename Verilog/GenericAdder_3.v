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

module GenericAdder_3(A,B,C,sum);

function integer max;

  input integer valueA;
  input integer valueB;
  input integer valueC;
  begin
  
    if(valueA >= valueB)
		if(valueA >= valueC)
			max = valueA;
			
	if(valueB >= valueA)
		if(valueB >= valueC)
			max = valueB;

	if(valueC >= valueA)
		if(valueC >= valueB)
			max = valueC;	
	end	
endfunction

parameter Abitwidth=29;
parameter Bbitwidth=29;
parameter Cbitwidth=29;
localparam Sbitwidth=max(Abitwidth,Bbitwidth,Cbitwidth)+2;

input signed[Abitwidth-1:0] A;
input signed[Bbitwidth-1:0] B;
input signed[Cbitwidth-1:0] C;

output signed[Sbitwidth-1:0] sum;

assign sum = A + B  + C; 

endmodule



