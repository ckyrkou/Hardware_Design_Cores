`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:07 05/29/2009 
// Design Name: 
// Module Name:    nBitRegister 
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

module WindowBuffer(clock,reset,enable,dataIn,dataOut);

parameter maxRow=20;
parameter maxCol=20;
parameter numOfOutputs=1;
parameter bitwidth=8;
localparam numOfBlocks = maxRow/numOfOutputs;

/*
 _ _     _ _
|_|_|...|_|_| <----> Stream 0
|_|_|...|_|_| _ |
|_|_|...|_|_| _ |  
 .
 .
 .
 _ _     _ _
|_|_|...|_|_| <----> Stream 1
|_|_|...|_|_| _ |
|_|_|...|_|_| _ | 
.
.
.
 _ _     _ _
|_|_|...|_|_| <----> Stream 2
|_|_|...|_|_| _ |
|_|_|...|_|_| _ | 
.
.
.
 _ _     _ _
|_|_|...|_|_| <----> Stream 3
|_|_|...|_|_| _ |
|_|_|...|_|_| _ | 

*/


/*

Output 3x3 window from scan-line buffers


First PIxel Enters
|	     __ __ __ __     __ __ __
 ---->	|__|__|__|__|...|0_|1_|2_|  
	   	|__|__|__|__|...|3_|4_|5_| 
	   	|__|__|__|__|...|6_|7_|8_|   --> First Pixel Enters , So last Pixel of the window is [0]
						  
*/



input clock,reset,enable;

input[bitwidth-1:0] dataIn;

output[numOfOutputs*bitwidth-1:0] dataOut;

wire[bitwidth-1:0] data[0:maxRow*maxCol];

generate
genvar row,col;

assign data[0] = dataIn;

for(row=0;row<maxRow;row=row+1)begin: rowWise
	for(col=0;col<maxCol;col=col+1)begin: columnWise
		RegisterEn #(bitwidth) winReg(
			.clk(clock),
			.reset(reset),
			.enable(enable),
			.dataIn(data[row*maxCol+col]),
			.dataOut(data[row*maxCol+col+1])
		);
	end
end

for(row=0;row<numOfOutputs;row=row+1)begin: outputAssignment
	assign dataOut[row*bitwidth+bitwidth-1:row*bitwidth]=data[(numOfBlocks*maxCol)*(numOfOutputs-row)];
end



endgenerate

endmodule

