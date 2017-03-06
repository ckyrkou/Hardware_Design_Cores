`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:39:30 06/24/2011 
// Design Name: 
// Module Name:    alphaUnit 
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
module alphaUnit(clock,reset,enable,processedScalars,lastScalar,address);
function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction



parameter maxColumn=100;
parameter alphaWidth=12;
parameter alphaMemDepth=100;
parameter alphaFile = "alpha.txt";


localparam max = maxColumn-1;
localparam alphaAddrWidth = log2(alphaMemDepth);

input enable;
input clock;
input reset;

reg [alphaAddrWidth:0] counter=0;
reg [alphaAddrWidth-1:0] colCounter=0;
output reg [alphaAddrWidth-1:0] address=0;

//output [alphaWidth-1:0] alpha;
output reg processedScalars; 
output reg lastScalar; 

always@(posedge clock)begin
	if(reset == 1)begin
		counter=0;
		address=0;
		processedScalars = 0;
		lastScalar = 0;
		colCounter = 0;
	end
	else begin
		if(enable == 1)begin
		
			address = counter;
			
			case(colCounter)
			
			max:begin
				colCounter = 0;
				processedScalars = 0;
			end
			
			(max-1):begin
				colCounter = colCounter + 1;
				processedScalars = 1;
			end
			
			default:begin
				colCounter = colCounter + 1;
				processedScalars = 0;
			end
			
			endcase

			if(counter == alphaMemDepth-1)begin
				lastScalar = 1;
				counter = counter;
			end
			else begin
				lastScalar = 0;
				counter = counter + 1;
			end

		end
		else begin
			processedScalars = 0;
			lastScalar = lastScalar;
			address = address;
			counter = counter;
			colCounter = colCounter;
		end
	end
	
end



endmodule
