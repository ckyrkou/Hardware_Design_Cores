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
module ROMen(clock, address, enable, dataOut); // synthesis attribute bram_map of ROMen is "yes"
function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

parameter blockLength = 9;
parameter memDepth = 400;
parameter file = "sv.txt";
parameter offset = 0;
parameter totalAmount=40;


localparam addressBitWidth=log2(memDepth-1);

    input  clock,enable; 
    input  [addressBitWidth-1:0] address; 
    output reg [blockLength-1:0] dataOut=0; 
    reg [blockLength-1:0] ram [0:memDepth-1]; 
	 reg [blockLength-1:0] temp[0:totalAmount-1];
	 
	 integer i;
    initial
    begin
		$readmemb(file,temp);
		for(i=0;i<memDepth;i=i+1)begin
			ram[i]=temp[i+offset];
		end
	 end
	  
    always @(posedge clock) 
    begin 
		if(enable)
       	dataOut <= ram[address];
		else
			dataOut <= 0;
    end
   
endmodule

