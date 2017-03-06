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
module blockRamWEInitFile(clock, writeEnable, address, dataIn, dataOut); 

parameter blockLength = 32;
parameter memDepth = 64;
parameter addressBitWidth = 6;
parameter file = "meminit.data";

    input  clock; 
    input  [addressBitWidth-1:0] address; 
	 input writeEnable;
    input  [blockLength-1:0] dataIn; 
    output reg [blockLength-1:0] dataOut; 
    reg [blockLength-1:0] ram [0:memDepth-1]; 
	reg ready = 0;
    initial
    begin
        $readmemb("meminit.data",ram);
    end
	 
    always @(posedge clock) 
    begin 
        if (writeEnable) 
            ram[address] <= dataIn; 
		ready = 1;
        dataOut <= ram[address];
    end
   
endmodule

