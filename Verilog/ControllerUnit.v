`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:17:47 03/23/2008 
// Design Name: 
// Module Name:    controller 
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
module ControllerUnit(clock,userReset,reset);

parameter statesBitwidth=4;

input clock;
input userReset;

output reg reset;

reg[statesBitwidth-1:0] currentState=0;
reg[statesBitwidth-1:0] nextState=0;

always@(currentState,userReset)begin

		if(userReset == 0)begin   // Reset
			nextState = 0;
			reset = 1;
		end
		else begin
			case(currentState)

				//Reset State
				0:begin
				  nextState = 1;
				  reset = 1;
				end
				
				1:begin
				  nextState = 1;
				  reset = 0;
				end

			endcase
		
		end

end

always@(negedge clock or negedge userReset)begin

	if(userReset == 0)begin
		currentState = 0;
	end
	else begin
		currentState = nextState;
	end

end

endmodule
