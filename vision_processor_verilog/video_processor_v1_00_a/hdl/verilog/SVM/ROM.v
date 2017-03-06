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
module ROM(clock, address, dataOut); // synthesis attribute bram_map of ROM is yes
function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

parameter blockLength = 8;
parameter memDepth = 26*26;
parameter file = "pos.txt";

localparam addressBitWidth=log2(memDepth-1);

    input  clock; 
    input  [addressBitWidth-1:0] address; 
    output reg [blockLength-1:0] dataOut; 
    reg [blockLength-1:0] ram [0:memDepth-1]; 
   	
	 
    initial
    begin
		  $readmemb(file,ram);
	 end
	 
	 
    always @(posedge clock) 
    begin 
        dataOut <= ram[address];
    end
   
endmodule

