`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:03:37 07/14/2009 
// Design Name: 
// Module Name:    memoryTest 
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
module ROMen_v2(clock, address, enable, dataOut); // synthesis attribute bram_map of ROMen is "no"


parameter blockLength = 12;
parameter memDepth = 100;
parameter addressBitWidth = 7;
parameter file = "alpha.txt";


    input  clock,enable; 
    input  [addressBitWidth-1:0] address; 
    output reg [blockLength-1:0] dataOut=0; 
    reg [blockLength-1:0] ram [0:memDepth-1]; 
	 
	 reg [blockLength-1:0] temp[0:totalAmount-1];
	 integer i;
    initial
    begin
		$readmemb(file,temp);
	 end
	  
    always @(posedge clock) 
    begin 
		if(enable)
       	dataOut <= ram[address];
    end
   
endmodule

