`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:41 07/23/2012 
// Design Name: 
// Module Name:    shifter 
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
module arithmetic_shifter(dataIn,amount,dir,dataOut);

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

   parameter data_width_in = 8;
	parameter shiftAmount = 16;
	localparam shiftBits = log2(shiftAmount);	
	parameter data_width_out = shiftAmount+data_width_in;
	
	input dir;
	input signed[data_width_in-1:0] dataIn;
	input[shiftBits-1:0] amount;
	output signed[data_width_out-1:0] dataOut;

	
	assign dataOut = (dir) ? (dataIn <<< amount) : (dataIn >>> amount); //1 - left shift 0 - right shift
			
endmodule
