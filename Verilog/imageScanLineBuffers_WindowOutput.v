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

module imageScanLineBuffers_WindowOutput(clock,reset,enable,dataIn,dataOut);

parameter winRow=16;
parameter imCol=700;
parameter winCol=16;
parameter bitwidth=8;

localparam numOfOutputs = winCol*winRow;

/*

Output 3x3 window from scan-line buffers
 __ __ __ __     __ __ __
|__|__|__|__|...|0_|1_|2_|  
|__|__|__|__|...|3_|4_|5_| 
|__|__|__|__|...|5_|6_|7_|   
              
*/

input clock,reset,enable;

input[bitwidth-1:0] dataIn;

output[numOfOutputs*bitwidth-1:0] dataOut;

wire[bitwidth-1:0] window[0:winRow*winCol-1];


wire[bitwidth-1:0] data[0:winRow*imCol];



generate
genvar row,col;

assign data[0] = dataIn;

for(row=0;row<winRow;row=row+1)begin: rowRegs
	for(col=0;col<imCol;col=col+1)begin: columnRegs
		RegisterEn #(bitwidth) winReg(
			.clk(clock),
			.reset(reset),
			.enable(enable),
			.dataIn(data[row*imCol+col]),
			.dataOut(data[row*imCol+col+1])
		);
	end
end

for(row=0;row<winRow;row=row+1)begin: rowWin
	for(col=0;col<winCol;col=col+1)begin: columnWin
		assign window[row*winCol+col]=data[row*imCol+(imCol-winCol+col)+1];
	end
end

for(row=0;row<winRow;row=row+1)begin: rowOut
	for(col=0;col<winCol;col=col+1)begin: columnOut
		assign dataOut[(row*winCol+col)*bitwidth+bitwidth-1:(row*winCol+col)*bitwidth]=window[row*winCol+col];
	end
end

endgenerate

endmodule

