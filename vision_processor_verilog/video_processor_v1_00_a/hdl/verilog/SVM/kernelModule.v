`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:56:22 07/31/2012 
// Design Name: 
// Module Name:    kernelModule 
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
(* USE_DSP48="NO" *)module kernelModule(clock,reset,enable,dot,alpha,P);

localparam cutOff=0;

parameter bitwidth=26;
localparam squareBitwidth=2*bitwidth;
parameter alphaBitwidth=8;
parameter Pbitwidth=64;

input clock,reset,enable;

(* KEEP="TRUE" *)input signed[bitwidth-1:0] dot;
(* KEEP="TRUE" *)input signed[alphaBitwidth-1:0] alpha;

(* KEEP="TRUE" *)reg [squareBitwidth-1:0] dotSquare=0;

(* KEEP="TRUE" *)reg signed[Pbitwidth-1:0] Pstage1=0;
//reg signed[Pbitwidth-1:0] Pstage2=0;
wire signed[Pbitwidth-1:0] Pstage2=0;
(* KEEP="TRUE" *)output reg signed[Pbitwidth-1:0] P=0;
	assign Pstage2=dot;
	always@(posedge clock)begin
			
		if(reset)begin
			dotSquare <= 0;
			Pstage1 <= 0;
			P <= 0;
		end
		else
			if(enable)begin
				dotSquare <= dot*dot;
				Pstage1 <= $signed({1'b0,dotSquare})*alpha;
				//Pstage1 <= dotSquare*alpha;
				//Pstage2 <= Pstage1;
				P <= $signed(P) +  $signed(Pstage1);
				//P <= P +  Pstage1;
			end
	end

endmodule
