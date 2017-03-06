`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:01:34 05/19/2014 
// Design Name: 
// Module Name:    faceVerifier 
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
////////////////////////////////////////////////////////////////////////////////////
module faceVerifier(clock,pixelIn,address,reset,enableProcessing,class,
//module faceVerifier(class,
testSignal1,testSignal2,testSignal3,testSignal4);

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

function integer sum;
  input integer value;
  input integer times;
  integer i;
  begin
    for (i=0; i>times; i=i+1)
      sum = sum + value;
  end
endfunction

parameter pixelWidth=8;
parameter winCol=26;
parameter winRow=26;
parameter boxPerRow = 8;
//parameter boxPerCol = 4;
parameter boxPerCol = 8;
parameter num_of_bins = 32;

localparam numOfPEs = 10;

localparam featureBitwidth = log2(((winRow-2)/boxPerRow)*((winCol-2)/boxPerCol));

localparam scaledFeatureBits=featureBitwidth+3;

localparam svBitsInt=1;
localparam svBitsFra=7;
localparam svBits=svBitsInt+svBitsFra;
//localparam svMemDepth=1024;
localparam svMemDepth=2048;
localparam svMemAddrBits=log2(svMemDepth);
localparam svFile="sv0.txt";
localparam svAccBits = log2(((2**(svBits+scaledFeatureBits))-1)*svMemDepth);

localparam alphaBitsInt=3;
localparam alphaBitsFra=5;
localparam alphaBits=alphaBitsInt+alphaBitsFra;
localparam alphaMemAddrBits=log2(numOfPEs);
localparam alphaFile="alpha.txt";

localparam biasBitsInt=1;
localparam biasBitsFra=2;
localparam biasBits=biasBitsInt+biasBitsFra;

parameter resBits = (((2*svAccBits)+alphaBits)+log2(numOfPEs));

input clock,reset,enableProcessing; input [9:0] address; input[pixelWidth-1:0] pixelIn; 
//reg clock,reset,enableProcessing; wire [9:0] address;

(* KEEP="TRUE" *)wire[pixelWidth-1:0] pixelIn;

(* KEEP="TRUE" *)wire[scaledFeatureBits-1:0] lbp_hist_feature;

(* KEEP="TRUE" *)wire[alphaMemAddrBits-1:0] alphaMemAddr;
(* KEEP="TRUE" *)wire[numOfPEs*svBits-1:0] SVs;
(* KEEP="TRUE" *)wire[alphaBits-1:0] Alphas;

(* KEEP="TRUE" *)wire[pixelWidth-1:0] lbpPattern;
(* KEEP="TRUE" *)wire[pixelWidth-1:0] lbpPattern_uni;

(* KEEP="TRUE" *)wire[pixelWidth*9-1:0] window_output;

(* KEEP="TRUE" *)wire[resBits-1:0] svm_result;

(* KEEP="TRUE" *)wire enableVU;

(* KEEP="TRUE" *)output reg class=0;

(* KEEP="TRUE" *)wire valid; // output if window is valid from the window buffer

(* KEEP="TRUE" *)wire[25:0] dotOutput;


///// check signals

(* KEEP="TRUE" *)reg reset_lbp;
(* KEEP="TRUE" *)reg enable_lbp;
(* KEEP="TRUE" *)reg enableProcessing_reg;

output testSignal1;
output testSignal2;
output testSignal3;
output testSignal4;

assign testSignal1 = enable_lbp; // test
assign testSignal2 = enableVU; // test
assign testSignal3 = enableSU; // test
assign testSignal4 = addBias; // test

///////////////////////////////
//////////////////// TESTBENCH
/////////////////////////////////////////////
/*
initial begin
	clock=0;
	reset=0;
	#10 reset=1;
	enableProcessing=0;
end

always begin
	#100
	reset=0;
	#20 begin
		enableProcessing=1;
		if(addBias)begin
			enableProcessing=0;
			reset=1;
		end
	end
end

wire[7:0] pixelInPos,pixelInNeg;
reg[9:0] addressT;

always #10 clock=~clock;

	always@(posedge clock)begin
		if(reset)
			addressT<= 0;
		else
			if (enableProcessing)
				addressT <= addressT + 1'b1;
			else
				addressT <= 0;
				
	end
	
assign pixelIn = pixelInPos;
assign address = addressT;

ROM #(
	.blockLength(pixelWidth),
	.memDepth(winCol*winRow),
	.file("neg.txt")
	)
	neg_mem(
	.clock(clock), 
	.address(addressT), 
	.dataOut(pixelInNeg)
	);
	
ROM #(
	.blockLength(pixelWidth),
	.memDepth(winCol*winRow),
	.file("pos.txt")
	)
	pos_mem(
	.clock(clock), 
	.address(addressT), 
	.dataOut(pixelInPos)
	);
*/
//////////////////////////////

always@ (posedge clock)begin 
	
	enableProcessing_reg<=enableProcessing;
	
	if(reset)begin 
		reset_lbp<=1;
		enable_lbp <= 0;
	end
	else begin
		reset_lbp<=0;
		if(enableProcessing_reg)begin
		if(address > (winCol*3-1) && (done_hist == 0))
		//if(address > (winCol*3-1))
			enable_lbp <= valid;
		else
			enable_lbp <= 0;
		end
	end
	
end


WindowBuffer #(
	.winRow(3),
	.imCol(winCol),
	.winCol(3),
	.bitwidth(pixelWidth)
	)
	WB(
		.clock(clock),
		.valid(valid),
		.reset(reset),
		.enable(enableProcessing_reg),
		.dataIn(pixelIn),
		.dataOut(window_output)
	);
/*
WindowBuffer2
	WB2(
		.clock(clock),
		.valid(valid),
		.reset(reset),
		.enable(enableProcessing_reg),
		.dataIn(pixelIn),
		.dataOut(window_output)
	);
*/
LBP_processor
	#(
		.inputWidth(pixelWidth),
		.winCol(winCol),
		.winRow(winRow),
		.boxPerRow(boxPerRow),
		.boxPerCol(boxPerCol),
		.num_of_bins(num_of_bins),
		.lbp_type(1),// 0 - original 1 - uniform 
		.lbp_threshold(0), // 0 - center 1 -mean
		.outputFeatureBits(scaledFeatureBits)
	)
	LBP_Hist_Generator(
		.clock(clock),
		.reset_lbp(reset_lbp),
		.enable_lbp(enable_lbp),
		.enable_readout_reset(enableMems),  // Histogram will be outputed to SVM and memory will be reset
		.windowIn(window_output),
		.done_hist(done_hist),
		.serial_out_done(lastElement),
		.dataFeature(lbp_hist_feature)
	);	

/*
LBP_processor2
	LBP_Hist_Generator2(
		.clock(clock),
		.reset_lbp(reset_lbp),
		.enable_lbp(enable_lbp),
		.enable_readout_reset(enableMems),  // Histogram will be outputed to SVM and memory will be reset
		.windowIn(window_output),
		.done_hist(done_hist),
		.serial_out_done(lastElement),
		.dataFeature(lbp_hist_feature)
	);	
*/	
ControllerUnitSVM 
	#(
		16,
		numOfPEs,
		7
	)
	CU(
		//**Inputs**
		.clock(clock),
		.userReset(reset),  /// Input is expected to be positive logic
		.dataValid(done_hist),  /// Input is expected to be positive logic. Histogram is ready for processing
		.lastElement(lastElement), /// Last element of histogram is outputed to the SVM processor
		.lastEnabled(doneProcessing),
		.lastScalar(lastScalar),
		//**Outputs**
		.reset(resetUnits),
		.resetVU(resetVU),
		.resetSU(resetSU),
		.enableVU(enableVU),
		.enableSU(enableSU),
		.transfer(transfer), /// Select what the VU mux will transfer 
		.enableAlphaU(enableAlphaU),
		.enableAlphaMem(enableAlphaMem),
		.processedScalars(processedScalars),
		.enableMems(enableMems),
		.AddressEnable(),
		.addBias(addBias)
	);	
	
memoryChain #(
	.maxColumn(numOfPEs),
	.wordSize(svBits),
	.memDepth(svMemDepth),
	.file(svFile)
	)
	MC(
	.clk(clock),
	.reset(resetUnits),
	.memEn(enableMems),
	.dO(SVs)
	);

alphaUnit #(
	.maxColumn(numOfPEs),
	.alphaWidth(alphaMemAddrBits),
	.alphaMemDepth(numOfPEs),
	.alphaFile(alphaFile)
	)
	AU(
		.clock(clock),
		.reset(resetUnits),
		.enable(enableAlphaU),
		.processedScalars(processedScalars),
		.address(alphaMemAddr),
		.lastScalar(lastScalar)
	);

ROMen 
	#(
		.blockLength(alphaBits),
		.memDepth(numOfPEs),
		.file(alphaFile),
		.offset(0),
		.totalAmount(numOfPEs),
		.file_init("true")
	)
	alpha_mult_mem(
		.clock(clock), 
		.enable(enableAlphaMem), 
		.address(alphaMemAddr), 
		.dataOut(Alphas)
	);


(* KEEP_HIERARCHY="TRUE" *)final_SVM_stage
	#(
		.dim(svMemDepth),
		.num_of_SVs(numOfPEs),
		.maxColumn(numOfPEs),
		.pixelInputWidth(scaledFeatureBits),
		.svInputWidth(svBits),
		.controlWidth(4),
		.chainOutputWidth(svAccBits),
		.alphaBitwidth(alphaBits),
		.resBit(resBits)
	)
	SVM_Core(
		.clock(clock),
		.reset(resetUnits),
		.resetVU(resetVU),
		.resetSU(resetSU),
		.pixelInputs(lbp_hist_feature),
		.svInputs(SVs),
		.alphaInput(Alphas),
		.mu(transfer),
		.enableVU(enableVU),
		.enableSU(enableSU),
		.lastData(lastElement),
		.doneProcessing(doneProcessing),
		.svm_result(svm_result),
		.dotOutput(dotOutput),
		.addBias(addBias),
		.class(validFace)
	);	

always@(posedge clock)begin
	
	if(resetSU)
		class <= 0;
		else
	if(addBias && validFace)
		class <= 1;
	

end
		

endmodule
