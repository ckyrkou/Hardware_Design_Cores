`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:48 07/04/2013 
// Design Name: 
// Module Name:    LBP_processor 
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

(* RAM_STYLE="BLOCK"*)module Histogram_Mem(clka,clkb,ena,enb,wea,web,addressA,addressB,dataInA,dataInB,dataOutA,dataOutB);

//---------------- FUNCTIONS ----------------------------

function integer log2;
  input integer value;
  integer temp;
  begin
    temp = value-1;
    for (log2=0; temp>0; log2=log2+1)
      temp = temp>>1;
  end
endfunction



//---------------- PARAMETERS ----------------------------

	 parameter blockLength = 5;
	 parameter memDepth = 1024;


	localparam addressBitWidth=log2(memDepth-1);
	 localparam file = "zeros.txt";
    input  clka,clkb,ena,enb,wea,web;
    input  [addressBitWidth-1:0]  addressA,addressB;
    input  [blockLength-1:0] dataInA,dataInB;
    output reg[blockLength-1:0] dataOutA,dataOutB;
    (* KEEP="TRUE" *) reg    [blockLength-1:0] ram[0:memDepth-1];
	
	integer i;
    initial
    begin
			for(i=0;i<memDepth;i=i+1)begin
				ram[i]=0;
			end
	 end
	
	/*
	initial
    begin
		  $readmemb(file,ram);
	 end
	*/
    always @(posedge clka) begin
        if (ena)    
        begin
				dataOutA <= ram[addressA];
        end
    end

    always @(negedge clka) begin
        if (enb)
        begin
            if (web)begin
               ram[addressB] <= dataInB;
					dataOutB <= ram[addressB];
				end
				else begin
					dataOutB <= ram[addressB];
				end
        end
    end

endmodule


module meanThreshold(clock,reset_lbp,windowIn,lbpPattern); // 3x3 Mean Threshold Pattern Computation

	parameter inputWidth=8;
	
	input clock,reset_lbp;

	input[inputWidth*9-1:0] windowIn; 

	wire[inputWidth-1:0] win[0:8];
	wire[0:8] comparisonString;
	
	
	localparam divisionConstant = 6'b000111; //1/9 -> 0.1111 -> 0.109375

	output [7:0] lbpPattern;

	localparam add_stages_1 = 3;
	localparam add_stages_2 = 1;

	localparam AdderBitsStage1 = inputWidth+2;
	localparam AdderBitsStage2 = AdderBitsStage1+2;

	wire[AdderBitsStage2-1:-6] mean;

	wire[add_stages_1*AdderBitsStage1-1:0] outAdderStage1;
	wire[add_stages_1*AdderBitsStage1-1:0] outAdderStage1_reg;
	wire[add_stages_2*AdderBitsStage2-1:0] outAdderStage2;
	wire[add_stages_2*AdderBitsStage2-1:0] outAdderStage2_reg;

	// Mean Computation

	parallelAdders_3 #(.inWidth(9),.inBitwidth(inputWidth),.outBitwidth(AdderBitsStage1)) adderStage1(.inData(windowIn),.outData(outAdderStage1));
	Register #(add_stages_1*AdderBitsStage1) add_1_reg(clock,reset_lbp,outAdderStage1,outAdderStage1_reg);

	parallelAdders_3 #(.inWidth(3),.inBitwidth(AdderBitsStage1),.outBitwidth(AdderBitsStage2)) adderStage2(.inData(outAdderStage1_reg),.outData(outAdderStage2));
	Register #(add_stages_2*AdderBitsStage2) add_2_reg(clock,reset_lbp,outAdderStage2,outAdderStage2_reg);

	assign mean = outAdderStage2_reg*divisionConstant;

	generate

	// Make comparisons and compute LBP pattern

	genvar i;
	genvar j;		
			
		for(i=0;i<9;i=i+1)begin: winExtract
			assign win[i] = windowIn[(i*inputWidth)+inputWidth-1:(i*inputWidth)];
		end

		for(i=0;i<9;i=i+1)begin: meanComparison
			//assign comparisonString[i] = (win[i] >= win[5]) ? 1'b1 : 1'b0;
			assign comparisonString[i] = ({win[i],{6{1'b0}}} >= mean) ? 1'b1 : 1'b0;
		end

	endgenerate

	assign lbpPattern = {comparisonString[0:3],comparisonString[5:8]};

endmodule


module centerThreshold(windowIn,lbpPattern); // 3x3 Center Threshold Pattern Computation

	parameter inputWidth=8;
	
	input[inputWidth*9-1:0] windowIn; 

	wire[inputWidth-1:0] win[0:8];
	wire[8:0] comparisonString;

	output[7:0] lbpPattern;
	
	generate

	// Make comparisons and compute LBP pattern

	genvar i;
	genvar j;		
			
		for(i=0;i<9;i=i+1)begin: winExtract
			assign win[i] = windowIn[(i*inputWidth)+inputWidth-1:(i*inputWidth)];
		end

		for(i=0;i<9;i=i+1)begin: meanComparison
			assign comparisonString[i] = (win[i] >= win[4]) ? 1'b1 : 1'b0;
		end

	endgenerate

	/*
	Input Window Coordinates:
	
	8 | 7 | 6
	---------
	5 | 4 | 3
	---------
	2 | 1 | 0
	
	Setup LBP accordingly to match power of two mask
	
	    powerMat = [128 64 32; ...
                  1 0 16; ...
                  2 4 8];
	
	*/

	assign lbpPattern = {comparisonString[8],comparisonString[7],comparisonString[6],comparisonString[3],comparisonString[0],comparisonString[1],comparisonString[2],comparisonString[5]};

endmodule


module uniformLBP_LUT(clock,enable,lbpPattern,bin);
	
	parameter histBinsBits=5;
	
	input[7:0] lbpPattern;
	input clock,enable;
	reg[5:0] bin59=0;
	output[histBinsBits-1:0] bin;

	reg[8:0] i;
	reg[6:0] trans;
	reg[5:0] lbp_lut[0:255];
	integer sum;
	reg[5:0] count=1;
	localparam file="lbp_bins.txt";
	/*
    initial
    begin
			for(i=0;i<=255;i=i+1)begin
				trans[0] = i[0] ^ i[1];
				trans[1] = i[1] ^ i[2];
				trans[2] = i[2] ^ i[3];
				trans[3] = i[3] ^ i[4];
				trans[4] = i[4] ^ i[5];
				trans[5] = i[5] ^ i[6];
				trans[6] = i[6] ^ i[7];
				sum = trans[0]+trans[1]+trans[2]+trans[3]+trans[4]+trans[5]+trans[6];
				if(sum > 2)
					lbp_lut[i] = 0;
				else begin
					lbp_lut[i] = count;
					count = count + 1'b1;
				end
			end
			
		end
		*/
	initial
    begin
		  $readmemb(file,lbp_lut);
	 end
		
		
	always@(posedge clock) begin
		
		if(enable)begin
			bin59 <= lbp_lut[lbpPattern];
		end
		
	end

	assign bin = bin59[5:5-histBinsBits+1];

endmodule


(* KEEP_HIERARCHY="TRUE" *)module LBP_processor(clock,reset_lbp,enable_lbp,enable_readout_reset,windowIn,dataFeature,done_hist,serial_out_done); // 3x3 window local binary feature processor

// FUNCTIONS

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

// PARAMETERS

parameter inputWidth=8;
parameter winCol=26;
parameter winRow=26;

parameter boxPerRow = 8;
parameter boxPerCol = 4;
parameter num_of_bins = 32;

parameter lbp_type=1; // 0 - histogtam 1 - uniform 
parameter lbp_threshold=0; // 0 - center 1 -mean

localparam true_winCol = winCol-2;
localparam true_winRow = winRow-2;
localparam col_bits = log2(true_winCol);
localparam row_bits = log2(true_winRow);
localparam lbp_win_col = true_winCol/boxPerCol;
localparam lbp_win_row = true_winRow/boxPerRow;
localparam box_col_count_addr = log2(boxPerCol);
localparam box_row_count_addr = log2(boxPerRow);
localparam local_hist_bits = log2(num_of_bins);
localparam num_ofRegions = boxPerCol*boxPerRow;
localparam dim = num_ofRegions*num_of_bins;
localparam offset_bits = log2(num_ofRegions);
localparam hist_mem_bits = log2((true_winCol/boxPerCol)*(true_winRow/boxPerRow));

localparam addr_bits = log2(dim);

localparam scaledFeatureBits=hist_mem_bits+3;

// PORTS

input clock,reset_lbp,enable_lbp;
input enable_readout_reset; // When enabled the histogram memory is serially outputted to the SVM core and the values are reset in the following cycle
input [inputWidth*9-1:0] windowIn; // 3x3 input window

wire[offset_bits-1:0] Address_offset;
//reg[offset_bits-1:0] Address_offset;

reg[col_bits-1:0] col_count=0;
reg[row_bits-1:0] row_count=0;

(* KEEP="TRUE" *)reg enable_lbp_reg=0,enable_lbp_reg2=0;
(* KEEP="TRUE" *)output reg done_hist=0;

(* KEEP="TRUE" *)output reg serial_out_done=0;

(* KEEP="TRUE" *)wire[7:0] lbpPattern;
(* KEEP="TRUE" *)wire[local_hist_bits-1:0] local_histogram_Address;
(* KEEP="TRUE" *)wire[hist_mem_bits-1:0] increment,hist_mem_dataIn;

(* KEEP="TRUE" *)wire[addr_bits-1:0] histogram_address;
//reg[addr_bits-1:0] histogram_address;
(* KEEP="TRUE" *)wire[addr_bits-1:0] address_mux,address_mux_reg;

(* KEEP="TRUE" *)reg[addr_bits-1:0] serial_address=0;

(* KEEP="TRUE" *)wire hist_mem_en,hist_mem_we;

(* KEEP="TRUE" *)wire[hist_mem_bits-1:0] hist_dataA;
(* KEEP="TRUE" *)wire[hist_mem_bits+10-1:0] scaledHistValue; // Multiply with scaling value and add 
(* KEEP="TRUE" *)output[scaledFeatureBits-1:0] dataFeature;

reg[box_col_count_addr-1:0] box_col_coordinates[0:true_winCol-1];
reg[box_row_count_addr-1:0] box_row_coordinates[0:true_winRow-1];

reg[col_bits-1:0] i;
reg[row_bits-1:0] j;

initial begin
	
	// Initialize arrray of coordinates
	// Counts the blocks in the LBP image
	/*
	
		---|---|---
		0,0 0,1 0,2
		---|---|---
		1,0 1,1 1,2
		---|---|---
		2,0 2,1 2,2
	
	*/
	
	for(i=0;i<true_winCol;i=i+1)begin
		box_col_coordinates[i] = i/lbp_win_col;
	end
	
	for(j=0;j<true_winRow;j=j+1)begin
		box_row_coordinates[j] = j/lbp_win_row;	
	end
	
end

generate

if(lbp_threshold == 0)begin

	centerThreshold #(
			.inputWidth(inputWidth)
	)
	cT(
		.windowIn(windowIn),
		.lbpPattern(lbpPattern)
		);
end

if(lbp_threshold == 1)begin

	meanThreshold #(
		.inputWidth(inputWidth)
	)
	mT(
		.clock(clock),
		.reset_lbp(reset_lbp),
		.windowIn(windowIn),
		.lbpPattern(lbpPattern)
		);
end

if(lbp_type == 0)begin
	
	assign local_histogram_Address = lbpPattern[7:7-local_hist_bits];  // Get MSB of LBP Code that shows the bin that the LBP belongs to
end

if(lbp_type == 1)begin
	uniformLBP_LUT #(
		.histBinsBits(local_hist_bits)
		)
		ulut(
		.clock(clock),
		.enable(1'b1),
		.lbpPattern(lbpPattern),
		.bin(local_histogram_Address)
	);
end

endgenerate

// Serial output of histogram
// Also perform a reset of the histogram value


always@(posedge clock)begin
	
	if(reset_lbp)begin
		serial_address <= 0;
		serial_out_done <= 0;
	end
	else begin
		if(enable_readout_reset)begin
			serial_address <= serial_address + 1'b1;
			if(serial_address == dim-1)
				serial_out_done <= 1;
		end
	end
end

// HISTOGRAM COMPUTATION

//Find row and column for each window pixel

always@(negedge clock)begin
	
	if(reset_lbp)begin
		enable_lbp_reg2 <=0;
	end
	else begin
		enable_lbp_reg2 <=enable_lbp_reg;
		
	end

end

always@(posedge clock)begin
	

	
	if(reset_lbp)begin
		row_count <= 0;
		col_count <= 0;
		done_hist <= 0;
		enable_lbp_reg <=0;
	end
	else begin
	
		enable_lbp_reg <=enable_lbp;
	
		if(enable_lbp)begin
			if(col_count < (true_winCol-1))begin
				col_count <= col_count + 1'b1;
			end
			else begin
				if(row_count < (true_winRow-1))begin
					row_count <= row_count + 1'b1;
					col_count <= 0;
				end
			end	
		end
		
		if(hist_mem_en == 0 && col_count == (true_winCol-1) && row_count == (true_winCol-1))begin
			done_hist <= 1; // Histogram Generation is complete
		end
		
	end
	
end

// Region Selection

// 4 MSBs of col_counter show the column region
//
//	    |
//   _ _ _ _ 
//  |_|_|_|_|


// 3 MSBs of row_counter show the row region
//	    _ _ _ _ 
//	   |_|_|_|_|
//	    _ _ _ _ 
// -  |_|_|_|_|
//	    _ _ _ _ 
//	   |_|_|_|_|

/*
always@(negedge clock)begin
	if(reset_lbp)begin
		Address_offset <= 0;
		histogram_address <= 0;
	end
	else begin
		Address_offset <= box_col_coordinates[col_count]+box_row_coordinates[row_count]*boxPerCol;
		histogram_address <= Address_offset*(num_of_bins-1)+local_histogram_Address;
	end
end
*/

// Non Registered
assign Address_offset = box_col_coordinates[col_count]+box_row_coordinates[row_count]*boxPerCol;
assign histogram_address = Address_offset*(num_of_bins)+local_histogram_Address;
//assign histogram_address = local_histogram_Address;  // Used for simpler debugging


// Muxes to select between read and reset mode & lbp histogram computation mode
assign address_mux = (enable_readout_reset) ? serial_address : histogram_address;

Register #(addr_bits) addr_reg(clock,reset_lbp,address_mux,address_mux_reg);

assign increment = hist_dataA + 1'b1;  // Increase bin value by one
//assign hist_mem_dataIn = (enable_readout_reset) ? {hist_mem_bits{1'b0}} : ({hist_mem_bits{enable_readout_reset}}&increment); // assign data to be written to hist mem
assign hist_mem_dataIn = {hist_mem_bits{(~serial_out_done)&(~enable_readout_reset)}} & increment; // assign data to be written to hist mem

or(hist_mem_we,enable_readout_reset,enable_lbp_reg);

or(hist_mem_en,enable_readout_reset,enable_lbp);

// A is read port
// B is write port

// Delay inputs for port B in order to perform correct write
// Read on positive edge
// Write on negative edge
/*
	How the memory process works
				    __	   __      __
	clk	    __|  |____|  |____|  |__
					 __________________
	enablelbp __|                  |__
	
	addressA     A0      A1      A2      A3
	dataA		            D0      D1      D2
	dataB			         +1      +1      +1
							   __________________
	enablelbp_reg     __| 						|__

	addressB             A0      A1     
	
	
	1) When enablelbp==1 data is outputed from dataA, incremented and moved to port dataB
	2) AddressA is registered and moved to addressB port when enablelbp==1
	3) A write is performed on the negative edge of <clk>


*/
Histogram_Mem #(
	.blockLength(hist_mem_bits),
	.memDepth(dim)
)
hist_mem(
	.clka(clock),
	.clkb(),
	.ena(hist_mem_en),
	.enb(hist_mem_we),
	.wea(1'b0),
	.web(hist_mem_we),
	.addressA(address_mux),
	.addressB(address_mux_reg),
	.dataInA(),
	.dataInB(hist_mem_dataIn),
	.dataOutA(hist_dataA),
	.dataOutB()
);

//assign scaledHistValue = (hist_dataA*10'b0000111001);  // Scaling value is 1/18
assign scaledHistValue = (hist_dataA*10'b0001110001);  // Scaling value is 1/9

assign dataFeature = scaledHistValue[10:3];

endmodule
