`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:53:23 03/06/2009 
// Design Name: 
// Module Name:    AddressGenerator 
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


module memoryChain(clk,reset,memEn,dO);
function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

parameter maxColumn=10;
parameter wordSize = 8;
parameter memDepth = 1024;
parameter file = "SVs0.txt";

localparam addressBitwidth = log2(memDepth-1);

wire[(addressBitwidth)-1:0] addrWire[0:maxColumn-2];
input clk;
input reset;
reg[addressBitwidth-1:0] addr;
input memEn;

wire[maxColumn-2:0] enable;
wire[wordSize-1:0] memOutWires[0:maxColumn-1];
output[(wordSize)*maxColumn-1:0] dO;

always@(posedge clk)begin

	if(reset)
		addr <= 0;
	else
		if(memEn)
			addr <= addr + 1;

end

generate

genvar column;

for (column=0; column < maxColumn; column=column+1) 
begin: Columns

	
	if(column == 0)begin
		ROMen #(wordSize,memDepth,file,column*memDepth,maxColumn*memDepth)
			br(
			.clock(clk), 
			.enable(memEn), 
			.address(addr), 
			.dataOut(memOutWires[column])
		);
		Register #(addressBitwidth) 
		RegisterAddr(clk,reset,addr,addrWire[column]);
		Register #(1) 
		RegisterEnable(clk,reset,memEn,enable[column]);
	end
	else begin
		if(column == (maxColumn-1))begin
			ROMen #(wordSize,memDepth,file,column*memDepth,maxColumn*memDepth)
				br(
				.clock(clk), 
				.enable(enable[column-1]), 
				.address(addrWire[column-1]), 
				.dataOut(memOutWires[column])
			);
		end
		else begin
			ROMen #(wordSize,memDepth,file,column*memDepth,maxColumn*memDepth)
				br(
				.clock(clk), 
				.enable(enable[column-1]), 
				.address(addrWire[column-1]), 
				.dataOut(memOutWires[column])
			);
			Register #(addressBitwidth) 
			RegisterAddr(clk,reset,addrWire[column-1],addrWire[column]);
			Register #(1) 
			RegisterEnable(clk,reset,enable[column-1],enable[column]);
		end
	end
	
end

for (column=0; column < maxColumn; column=column+1) 
begin: outputWires
	assign dO[column*wordSize+wordSize-1:column*wordSize] = memOutWires[column];
end

endgenerate

endmodule
