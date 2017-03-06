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

module WindowBuffer(clock,reset,enable,valid,dataIn,dataOut);

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

parameter winRow=24;
parameter imCol=1024;
parameter winCol=24;
parameter bitwidth=8;

localparam numOfOutputs = winCol*winRow;
localparam leftBound=(winCol/2);
localparam rightBound=(imCol-(2*(winCol/2)));


/*

Output 3x3 window from scan-line buffers


First PIxel Enters
|	       __ __ __ __     __ __ __
 ---->	|__|__|__|__|...|0_|1_|2_|  
	   	|__|__|__|__|...|3_|4_|5_| 
	   	|__|__|__|__|...|6_|7_|8_|   --> First Pixel Enters , So last Pixel of the window is [0]
						  
*/

input clock,reset,enable;

input[bitwidth-1:0] dataIn;

output[numOfOutputs*bitwidth-1:0] dataOut;

output valid;
reg validWindow,bufferFull;

wire[bitwidth-1:0] window[0:winRow*winCol-1];

wire[bitwidth-1:0] data[0:winRow*imCol];

reg enable_reg;
localparam buffBits = log2(imCol*winCol);
reg[buffBits-1:0] buffer_count;
localparam colBits = log2(imCol);
reg[colBits-1:0] col_count;
reg[colBits-1:0] counter;

always@(posedge clock)begin

	if(reset)begin
		col_count <= {colBits{1'b0}};
		buffer_count <= {buffBits{1'b0}};
		validWindow <= 1'b0;
		bufferFull <= 1'b0;
	end
	else begin
		
		if(enable)begin
	
	
			if(col_count == (imCol-1))
				col_count <= {colBits{1'b0}};
			else
				col_count <= col_count + 1'b1;		
					
			if(col_count == rightBound || col_count == (rightBound-1))
				validWindow <= 1'b0;
			else
				validWindow <= 1'b1;

			if(buffer_count <= (winCol*imCol-1))
				buffer_count <= buffer_count + 1'b1;
			
			if(buffer_count == (winCol*imCol-1))
				bufferFull <= 1'b1;			
			
		end
		
		
		
	end
end


/*

	if(enable)begin
			if(buffer_count >= (winCol*imCol-1))begin
				bufferFull<=1;
			end
			else begin
				bufferFull<=0;
				buffer_count <= buffer_count + 1;
			end

			if(col_count < (imCol-1))begin
				if(col_count < (rightBound-1))
					validWindow <= 1;
				else
					validWindow <= 0;
				col_count <= col_count + 1'b1;
			end
			else begin
				col_count <= 0;
				validWindow <= 1;
			end	
		end

		
*/

assign valid = validWindow & bufferFull;

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
	for(col=winCol-1;col>=0;col=col-1)begin: columnWin
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

