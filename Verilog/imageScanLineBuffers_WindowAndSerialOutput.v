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

module imageScanLineBuffers_WindowAndSerialOutput(clock,reset,enable,mode,dataIn,serialOut,parallelOut);

parameter winCol=42;
parameter winRow=42;
parameter imCol=60;
parameter bitwidth=6*5;

localparam numOfOutputs = winCol*winRow;

/*

Output 3x3 window from scan-line buffers
 __ __ __ __     __ __ __
|__|__|__|__|...|0_|1_|2_|  
|__|__|__|__|...|3_|4_|5_| 
|__|__|__|__|...|5_|6_|7_|   

Two modes of operation:

1) Normal shifting operation - Parallel Window Output - Mode=0

				       
				<------Win Row--------->
_		_		   Parallel Outputs
		          _|     _|     _|
|		|     -> |_| -> |_| -> |_|
|		|    |_______________________
|		|         _|     _|     _|   |
imCol	|     -> |_| -> |_| -> |_| ->
|	 winCol |_______________________
|     |		    _|     _|     _|   |
|		_     -> |_| -> |_| -> |_| ->
|		     |_______________________
|			       _      _      _    |
_	         -> |_| -> |_| -> |_| ->
			  |_______________________
				    _      _      _    |
Input Pixel -> |_| -> |_| -> |_| ->
 
 
 2) Serial Window Output - Loop Around - Mode=1
 _________________________                        
|	_	  _      _      _   |
| |_|  |_| -> |_| -> |_|->  -> output
|	       |________________
|	_    _      _      _    |
| |_|  |_| -> |_| -> |_| ->
|	       |________________ 
|	_    _      _      _    |
| |_|	 |_| -> |_| -> |_| ->
|__________|	 
              
*/

input clock,reset,enable,mode;

input[bitwidth-1:0] dataIn;

output[numOfOutputs*bitwidth-1:0] parallelOut;
output[bitwidth-1:0] serialOut;

wire[bitwidth-1:0] window[0:winRow*winCol-1];


wire[bitwidth-1:0] data[0:winRow*imCol];

wire[bitwidth-1:0] muxData;


generate
genvar row,col;

assign data[0] = dataIn;
assign serialOut = data[imCol*winRow-1];

for(row=0;row<winRow;row=row+1)begin: rowRegs
	for(col=0;col<imCol;col=col+1)begin: columnRegs
	
		// Multiplixers used to change mode
	
		if(col == (imCol - winCol) && row == 0)begin
			
			Mux2to1 #(bitwidth) mux(data[row*imCol+col],data[imCol*winRow-1],mode,muxData);
				
			RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(muxData),
				.dataOut(data[row*imCol+col+1])
			);
			
		end
		else begin
		
			if(col < (imCol - winCol))begin
				// Other Registers
				RegisterEn #(bitwidth) winReg(
					.clk(clock),
					.reset(reset),
					.enable(~mode),
					.dataIn(data[row*imCol+col]),
					.dataOut(data[row*imCol+col+1])
				);
			
			end
			else begin
				// Window Registers have a different enable signal
				(* KEEP_HIERARCHY="TRUE" *)RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(data[row*imCol+col]),
				.dataOut(data[row*imCol+col+1])
			);
			
			end
		
		end
	
	end
end

for(row=0;row<winRow;row=row+1)begin: rowWin
	for(col=0;col<winCol;col=col+1)begin: columnWin
		assign window[row*winCol+col]=data[row*imCol+(imCol-winCol+col)+1];
	end
end

for(row=0;row<winRow;row=row+1)begin: rowOut
	for(col=0;col<winCol;col=col+1)begin: columnOut
		assign parallelOut[(row*winCol+col)*bitwidth+bitwidth-1:(row*winCol+col)*bitwidth]=window[row*winCol+col];
	end
end

endgenerate

endmodule

