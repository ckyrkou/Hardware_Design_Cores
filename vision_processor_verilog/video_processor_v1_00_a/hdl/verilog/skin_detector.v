`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:11 10/24/2013 
// Design Name: 
// Module Name:    skin_detector 
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
module skin_detector(clock, skinThreshold, red,green,blue,skin,red_out,green_out,blue_out,cb_round,cr_round);

parameter bitwidth = 8;
parameter fraction_bitwidth = 12;

input[bitwidth-1:0] red,green,blue;
input[bitwidth-1:0] skinThreshold;
wire[bitwidth-1:0] red_reg,green_reg,blue_reg;

input clock;

wire signed[bitwidth-1:0] cb,cr;
wire [bitwidth-1:0] min_col;
wire signed[bitwidth:0] col_diff,col_diff2;

output reg[bitwidth-1:0] skin,red_out,green_out,blue_out;

rgb2ycrcb #(bitwidth,fraction_bitwidth) color_space_conv(
	.clock(clock),
	.red(red),
	.green(green),
	.blue(blue),
	.cb_round(cb),
	.cr_round(cr),
	.red_out(red_reg),
	.green_out(green_reg),
	.blue_out(blue_reg)
);

/////////////////////////////-14'h1234 Signed negative number

// find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);

output signed[bitwidth-1:0] cb_round;
output signed[bitwidth-1:0] cr_round;

assign cr_round = cr;
assign cb_round = cb;

assign min_col = (blue>green) ? green : blue;

assign col_diff = red-min_col;

assign col_diff2 = red-green;


always@* begin
	//if((cb_round >= 12) && (cb_round <= 67) && (cr_round >= threshold_skin) && (cr_round <= upper_threshold_skin))begin
	//if((col_diff > skinThreshold) && (col_diff2 > skinThreshold) && (blue > 20) && (green > 40))begin	
	if((col_diff2 > 20) && (col_diff2 < 80) && (blue > 40) && (green > 20) && (red > blue) && ~(blue < (red[7:2])))begin
		skin = 255;
		red_out = red;
		green_out = green;
		blue_out = blue;
	end
	else begin
		skin = 0;
		red_out = 0;
		green_out = 0;
		blue_out = 0;
	end
end

/*
always@* begin
	if((cb_round >= 12) && (cb_round <= 67) && (cr_round >= 12) && (cr_round <= 37))begin
		skin = 255;
		red_out = red_reg;
		green_out = green_reg;
		blue_out = blue_reg;
	end
	else begin
		skin = 0;
		red_out = 0;
		green_out = 0;
		blue_out = 0;
	end
end
*/
endmodule
