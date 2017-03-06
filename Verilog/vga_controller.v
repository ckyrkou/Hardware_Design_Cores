`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:25:30 11/29/2007 
// Design Name: 
// Module Name:    vga_controller 
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
module vga_controller(redIN, greenIN, blueIN, clock25Mhz, vSync, hSync, Sync, blank, redOUT, greenOUT, blueOUT, column, row);

input clock25Mhz;
input[7:0] redIN,greenIN,blueIN;

output[7:0] redOUT,greenOUT,blueOUT;
output vSync,hSync,Sync,blank;
output[9:0] column,row;
reg[9:0] column= 10'b0000000000,row= 10'b0000000000;
reg[7:0] redOUT=8'b00000000,greenOUT=8'b00000000,blueOUT=8'b00000000;
reg vSync=0,hSync=0,Sync=1,blank=1;
reg [9:0] Hcount= 10'b0000000000, Vcount= 10'b0000000000;


always@(negedge clock25Mhz)
begin	
	
	if (Hcount == 799) 
		begin
			Hcount = 10'b0000000000;
		end
	else 
		begin
			Hcount = Hcount + 1;
		end
		
	if (Hcount >= 661 && Hcount <= 756) 
		hSync = 0;
	else 
		hSync = 1;
		
	if (Vcount >= 525 && Hcount >= 756) 
		begin
			Vcount = 10'b0000000000;
		end
	else if (Hcount == 756) 
		begin
			Vcount = Vcount + 1;
		end
		
	if (Vcount >= 491 && Vcount <= 493)
		vSync = 0;
	else 
		vSync = 1;
		
	if(Hcount <= 640)
		column = Hcount;
	
	if(Hcount <= 480)
		row = Vcount;

	if (Hcount <= 680 && Vcount <= 480) 
		begin
			redOUT = redIN;
			blueOUT = blueIN;
			greenOUT = greenIN;
		end
	else
		begin
			redOUT=8'b00000000;
			greenOUT=8'b00000000;
			blueOUT=8'b00000000;
		end
	blank = 1;
	Sync = 1;

end



endmodule
