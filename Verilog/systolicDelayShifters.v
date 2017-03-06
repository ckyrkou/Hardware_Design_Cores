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

module systolicDelayShifters(clock,reset,enable,dataIn,dataOut);

parameter numOfOutputs=4;
parameter bitwidth=8;



/*
				_
dataIn0 -> |_| -> dataOut0    

				_    _
dataIn1 -> |_|->|_| -> dataOut1   

				_    _    _
dataIn2 -> |_|->|_|->|_| -> dataOut2   

				_    _    _    _
dataIn3 -> |_|->|_|->|_|->|_| -> dataOut3   
.
.
.
				_          _    _
dataIn7 -> |_|->....->|_|->|_| -> dataOut7

*/



function [31:0]  myfunction;
	input[31:0] a;
	reg[31:0] i,c;
	begin
		c=0;
		for(i=a-1;i>0;i=i-1)begin  c = c + i;  end
		myfunction = c;
	end
endfunction

localparam wireNumber=myfunction(numOfOutputs);



input clock,reset,enable;

input[numOfOutputs*bitwidth-1:0] dataIn;

output[numOfOutputs*bitwidth-1:0] dataOut;

wire[bitwidth-1:0] dataWires[0:wireNumber-1];

generate
genvar row, col;

for(row=0;row<numOfOutputs;row=row+1)begin: rowWise
			/*if(row == 0)begin
				assign dataOut[row*bitwidth+bitwidth-1:row*bitwidth] = dataIn[row*bitwidth+bitwidth-1:row*bitwidth];
			end*/
			
			if(row == 0)begin
				RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataIn[row*bitwidth+bitwidth-1:row*bitwidth]),
				.dataOut(dataOut[row*bitwidth+bitwidth-1:row*bitwidth])
				);	
			end
			
			if(row == 1)begin
				RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataIn[row*bitwidth+bitwidth-1:row*bitwidth]),
				.dataOut(dataWires[0])
				);	
				
				RegisterEn #(bitwidth) winReg2(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[0]),
				.dataOut(dataOut[row*bitwidth+bitwidth-1:row*bitwidth])
				);		
			end

			if(row == 2)begin
				RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataIn[row*bitwidth+bitwidth-1:row*bitwidth]),
				.dataOut(dataWires[1])
				);	
				
				RegisterEn #(bitwidth) winReg2(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[1]),
				.dataOut(dataWires[2])
				);		
				
				RegisterEn #(bitwidth) winReg3(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[2]),
				.dataOut(dataOut[row*bitwidth+bitwidth-1:row*bitwidth])
				);		
			end	
			
			if(row == 3)begin
				RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataIn[row*bitwidth+bitwidth-1:row*bitwidth]),
				.dataOut(dataWires[3])
				);	
				
				RegisterEn #(bitwidth) winReg2(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[3]),
				.dataOut(dataWires[4])
				);		
				
				RegisterEn #(bitwidth) winReg3(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[4]),
				.dataOut(dataWires[5])
				);
				
				RegisterEn #(bitwidth) winReg4(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[5]),
				.dataOut(dataOut[row*bitwidth+bitwidth-1:row*bitwidth])
				);		
			end
			
			if(row == 4)begin
				RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataIn[row*bitwidth+bitwidth-1:row*bitwidth]),
				.dataOut(dataWires[6])
				);	
				
				RegisterEn #(bitwidth) winReg2(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[6]),
				.dataOut(dataWires[7])
				);		
				
				RegisterEn #(bitwidth) winReg3(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[7]),
				.dataOut(dataWires[8])
				);
				
				RegisterEn #(bitwidth) winReg4(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[8]),
				.dataOut(dataWires[9])
				);
				
				RegisterEn #(bitwidth) winReg5(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[9]),
				.dataOut(dataOut[row*bitwidth+bitwidth-1:row*bitwidth])
				);		
			end
			
			if(row == 5)begin
				RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataIn[row*bitwidth+bitwidth-1:row*bitwidth]),
				.dataOut(dataWires[10])
				);	
				
				RegisterEn #(bitwidth) winReg2(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[10]),
				.dataOut(dataWires[11])
				);		
				
				RegisterEn #(bitwidth) winReg3(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[11]),
				.dataOut(dataWires[12])
				);
				
				RegisterEn #(bitwidth) winReg4(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[12]),
				.dataOut(dataWires[13])
				);
				
				RegisterEn #(bitwidth) winReg5(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[13]),
				.dataOut(dataWires[14])
				);
				
				RegisterEn #(bitwidth) winReg6(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[14]),
				.dataOut(dataOut[row*bitwidth+bitwidth-1:row*bitwidth])
				);		
			end
			
			if(row == 6)begin
				RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataIn[row*bitwidth+bitwidth-1:row*bitwidth]),
				.dataOut(dataWires[15])
				);	
				
				RegisterEn #(bitwidth) winReg2(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[15]),
				.dataOut(dataWires[16])
				);		
				
				RegisterEn #(bitwidth) winReg3(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[16]),
				.dataOut(dataWires[17])
				);
				
				RegisterEn #(bitwidth) winReg4(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[17]),
				.dataOut(dataWires[18])
				);
				
				RegisterEn #(bitwidth) winReg5(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[18]),
				.dataOut(dataWires[19])
				);
				
				RegisterEn #(bitwidth) winReg6(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[19]),
				.dataOut(dataWires[20])
				);
				
				RegisterEn #(bitwidth) winReg7(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[20]),
				.dataOut(dataOut[row*bitwidth+bitwidth-1:row*bitwidth])
				);		
			end
			
			if(row == 7)begin
				RegisterEn #(bitwidth) winReg(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataIn[row*bitwidth+bitwidth-1:row*bitwidth]),
				.dataOut(dataWires[21])
				);	
				
				RegisterEn #(bitwidth) winReg2(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[21]),
				.dataOut(dataWires[22])
				);		
				
				RegisterEn #(bitwidth) winReg3(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[22]),
				.dataOut(dataWires[23])
				);
				
				RegisterEn #(bitwidth) winReg4(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[23]),
				.dataOut(dataWires[24])
				);
				
				RegisterEn #(bitwidth) winReg5(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[24]),
				.dataOut(dataWires[25])
				);
				
				RegisterEn #(bitwidth) winReg6(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[25]),
				.dataOut(dataWires[26])
				);
				
				RegisterEn #(bitwidth) winReg7(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[26]),
				.dataOut(dataWires[27])
				);				
				
				RegisterEn #(bitwidth) winReg8(
				.clk(clock),
				.reset(reset),
				.enable(enable),
				.dataIn(dataWires[27]),
				.dataOut(dataOut[row*bitwidth+bitwidth-1:row*bitwidth])
				);		
				
			end
	
end


endgenerate

endmodule

