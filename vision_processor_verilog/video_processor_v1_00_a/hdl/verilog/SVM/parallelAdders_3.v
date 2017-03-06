`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:26:46 07/23/2012 
// Design Name: 
// Module Name:    parallelAdders 
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
module parallelAdders_3(inData,outData);

localparam parfactor=3;

parameter inWidth=5;
localparam outWidth = (inWidth%parfactor == 0) ? (inWidth/3) : (inWidth/3)+1;
localparam numelPad_in = (outWidth)*parfactor;
parameter inBitwidth=18;
parameter outBitwidth=20;

input [inWidth*inBitwidth-1:0] inData;
output[outWidth*outBitwidth-1:0] outData;

wire[3*inBitwidth-1:0] temp[0:outWidth-1];

wire [numelPad_in*inBitwidth-1:0] paddedInData;

assign paddedInData = {{((numelPad_in-inWidth)*inBitwidth){1'b0}},inData};

wire [inBitwidth-1:0] A[0:outWidth-1];
wire [inBitwidth-1:0] B[0:outWidth-1];
wire [inBitwidth-1:0] C[0:outWidth-1];
wire [outBitwidth-1:0] sum[0:outWidth-1];

//////MAKE ADDER STAGES 

generate
genvar i,j;

//for(i=0;i<inWidth;i=i+1)begin: assignInput1
//		assign A[i] = inData[(2*i)*inBitwidth+inBitwidth-1:(2*i)*inBitwidth];
//end

for(i=0;i<outWidth;i=i+1)begin: assignInput2
		assign temp[i] = paddedInData[(i)*3*inBitwidth+3*inBitwidth-1:(i)*3*inBitwidth];
		assign A[i] = temp[i][inBitwidth-1:0];
		assign B[i] = temp[i][2*inBitwidth-1:inBitwidth];
		assign C[i] = temp[i][3*inBitwidth-1:2*inBitwidth];
end

		for(i=0;i<outWidth;i=i+1)begin: makeAdditions
				GenericAdder_3 #(inBitwidth,inBitwidth,inBitwidth) ADDER(
					.A(A[i]),
					.B(B[i]),
					.C(C[i]),
					.sum(sum[i])
				);
		end
	
for(i=0;i<outWidth;i=i+1)begin: assignOutput
	assign  outData[(i)*outBitwidth+outBitwidth-1:(i)*outBitwidth] = sum[i];
end


endgenerate

endmodule
