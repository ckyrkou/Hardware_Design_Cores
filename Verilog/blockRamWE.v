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
module blockRamWE(clock, writeEnable, address, dataIn, dataOut); 

parameter blockLength = 8;
parameter memDepth = 1444;
parameter addressBitWidth = 11;
parameter file = "memory.mem";

    input  clock; 
    input  [addressBitWidth-1:0] address; 
	 input writeEnable;
    input  [blockLength-1:0] dataIn; 
    output reg [blockLength-1:0] dataOut; 
    reg [blockLength-1:0] ram [0:memDepth-1]; 
	
	 // synthesis attribute bram_map of blockRamWE is yes
	
    initial
    begin
        $readmemb(file,ram);
    end
	 
    always @(posedge clock) 
    begin 
        if (writeEnable) 
            ram[address] <= dataIn; 
        dataOut <= ram[address];
    end
   
endmodule

