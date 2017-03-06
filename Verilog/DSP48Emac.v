`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:59:38 05/29/2012 
// Design Name: 
// Module Name:    testMAC 
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
(* USE_DSP48="YES" *)module DSP48Emac(clock,reset,enable,A,B,P);

parameter Abitwidth=8;
parameter Bbitwidth=8;
parameter Pbitwidth=25;
parameter signedVectorInputs = 1;

input clock,reset,enable;

input[Abitwidth-1:0] A;
input[Bbitwidth-1:0] B;

output reg[Pbitwidth-1:0] P=0;

generate

if(signedVectorInputs == 2)begin

	wire sign;
	wire[Abitwidth-2:0] portA = A[Abitwidth-2:0];
	wire[Bbitwidth-2:0] portB = B[Bbitwidth-2:0];
	
	xor(sign,A[Abitwidth-1],B[Bbitwidth-1]);
	
	always@(posedge clock)begin

		if(reset)
			P <= 0;
		else
			if(enable)
				if(sign==0)
					P <= P + (portA*portB);
				else
					P <= P - (portA*portB);
	end
	
end

if(signedVectorInputs == 1)begin
	
	always@(posedge clock)begin

		if(reset)
			P <= 0;
		else
			if(enable)
				if(A[Abitwidth-1])
					P <= P + (A[Abitwidth-2:0]*B);
				else
					P <= P - (A[Abitwidth-2:0]*B);
	end
	
end

if(signedVectorInputs == 0)begin
	
	always@(posedge clock)begin

		if(reset)
			P <= 0;
		else
			if(enable)
				P <= P + (A*B);
	end
	
end

endgenerate

endmodule
