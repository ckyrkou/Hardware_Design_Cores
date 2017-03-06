`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:24:35 05/29/2009 
// Design Name: 
// Module Name:    nBitGenericAccumulator 
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

module GenericAccumulator(reset,C,enable,dataIn,Sum); // synthesis attribute use_dsp48 of GenericAccumulator is "no"; 

parameter inBitwidth=15;
parameter sumBitwidth=25;

input C;
input reset;
input enable;
input[inBitwidth-1:0] dataIn;
wire[sumBitwidth-1:0] signedInput;
output reg[sumBitwidth-1:0] Sum=0;

assign signedInput = {{sumBitwidth-inBitwidth{dataIn[inBitwidth-1]}},dataIn};

always@(posedge C,posedge reset)begin
	
	if(reset)begin
		Sum = 0;
	end
	else begin
		if(enable  == 1)
			Sum = Sum + signedInput;
		else
			Sum = Sum;
	end

end

endmodule
