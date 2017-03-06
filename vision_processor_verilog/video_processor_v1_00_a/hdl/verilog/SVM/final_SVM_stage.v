`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:31:00 06/23/2011 
// Design Name: 
// Module Name:    cellArrayGenrated 
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

(* USE_DSP48="NO" *)module VU(clock,reset,SVin,DataIn,control,regDataOut);

	parameter bitwidthA=8;
	parameter bitwidthB=8;
	parameter bitwidthAccRes=25;
	parameter controlbits=3;
	
	input clock,reset;
	input signed[bitwidthB-1:0] SVin;
	input [bitwidthAccRes-1:0] DataIn;
	input [controlbits-1:0] control;

	
	(* KEEP="TRUE" *)wire[bitwidthA-1:0] inputData;
	
	(* KEEP="TRUE" *)wire resetVU;
	assign resetVU = control[0];
	(* KEEP="TRUE" *)wire enableVU;
	assign enableVU = control[1];
	(* KEEP="TRUE" *)wire muxSelect;
	assign muxSelect = control[2];
	
	(* KEEP="TRUE" *)wire[bitwidthAccRes-1:0] muxOut;
	
	(* KEEP="TRUE" *)wire[bitwidthAccRes-1:0] AccResult;
	
	assign inputData=DataIn[bitwidthA-1:0];
	
	(* KEEP="TRUE" *)output[bitwidthAccRes-1:0] regDataOut;

	`ifdef XILINX_ISIM 

		wire[13:0] fra;
		assign fra = AccResult[13:0];
		
		wire[bitwidthAccRes-14:0] integ;
		assign integ = AccResult[bitwidthAccRes-1:14];
		
	`endif	
	
	MAC #(
		.Abitwidth(bitwidthA),
		.Bbitwidth(bitwidthB),
		.Pbitwidth(bitwidthAccRes)
	) 
	multacc(
		.clock(clock),
		.reset(resetVU),
		.enable(enableVU),
		.A(inputData),
		.B(SVin),
		.P(AccResult)
	);

	Mux2to1 #(bitwidthAccRes) multiplexer(
		.inA(DataIn),
		.inB(AccResult),
		.sel(muxSelect),
		.out(muxOut)
		);

	Register #(bitwidthAccRes) RegisterDATA(
		.clk(clock),
		.reset(reset),
		.dataIn(muxOut),
		.dataOut(regDataOut)
	);
	
endmodule

// ----------------MAIN MODULE----------------------------------------

module final_SVM_stage(
clock,reset,resetVU,resetSU,
pixelInputs,
svInputs,
alphaInput,
mu,
enableVU,enableSU,
addBias,
lastData,
doneProcessing,
svm_result,class,
dotOutput
);


/*
Array Cell Structure:
***********************
 --      --      --
|01| -- |02| -- |06|
 --      --      --
 ||      ||      ||
 --      --      --
|01| -- |08| -- |06|
 --      --      --
 ||      ||      ||
 --      --      --
|04| -- |03| -- |05|
 --      --      --
*/

/* NOTES:
	1) Reset must be 0 in order for resetVU to propagate otherwise it will allways be 0, and subsequent cells will not reset properly 

*/

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

//Array Structure
localparam maxRow=1;
parameter maxColumn=10;
parameter dim = 1024;
parameter num_of_SVs = 10;
parameter pixelInputWidth=8;
parameter svInputWidth=8;
parameter controlWidth=4;
parameter chainOutputWidth=log2(dim*(2**(svInputWidth+pixelInputWidth))-1);
parameter alphaBitwidth=8;

//reg[resBit-1:0] bias = {{(resBit-34){1'b0}},34'b1010100100000000000000000000000000}; //    1.3203125
//reg[resBit-1:0] bias = {{(resBit-34){1'b0}},34'b1001101000000000000000000000000000}; // 1.203125
//reg[resBit-1:0] bias = {{(resBit-34){1'b0}},34'b1000000000000000000000000000000000}; // 1
//reg[resBit-1:0] bias = {{(resBit-34){1'b0}},34'b0111000000000000000000000000000000}; // 0.875
reg[resBit-1:0] bias = {{(resBit-34){1'b0}},34'b0110000000000000000000000000000000}; // 0.75
//reg[resBit-1:0] bias = {{(resBit-34){1'b0}},34'b0101000000000000000000000000000000}; // 0.625
//reg[resBit-1:0] bias = {{(resBit-34){1'b0}},34'b0100000000000000000000000000000000}; // 0.5
//reg[resBit-1:0] bias = {{(resBit-34){1'b0}},34'b0110100000000000000000000000000000}; // 0.40625



parameter resBit = (2*chainOutputWidth+alphaBitwidth) + log2(num_of_SVs);
input clock,reset,resetVU,resetSU;

(* KEEP="TRUE" *)input mu,enableVU,lastData,enableSU;
(* KEEP="TRUE" *)input addBias;
(* KEEP="TRUE" *)input [maxRow*pixelInputWidth-1:0] pixelInputs;
(* KEEP="TRUE" *)input [maxColumn*svInputWidth-1:0] svInputs;
input [alphaBitwidth-1:0] alphaInput;
(* KEEP="TRUE" *)wire [maxRow*chainOutputWidth-1:0] rowOutputs;


wire[resBit-1:0] kernel_result;

(* KEEP="TRUE" *)output[resBit-1:0] svm_result;

(* KEEP="TRUE" *)output doneProcessing;

(* KEEP="TRUE" *)output class;

(* KEEP="TRUE" *)output [maxRow*chainOutputWidth-1:0] dotOutput;



generate
genvar column;
genvar row;


	wire [chainOutputWidth-1:0] dataSignals[0:maxColumn-2];
	wire [controlWidth-3:0] controlSignals[0:(maxColumn-2)];
	wire [(maxColumn-2):0]monitoringWires;

		for (column=0; column < maxColumn; column=column+1) 
		begin: C
		
					if(column == 0)begin // [0]-[0]
						Register #(controlWidth-2) RegisterCtrl(
							.clk(clock),
							.reset(reset),
							.dataIn({enableVU,resetVU}),
							.dataOut(controlSignals[column])
						);
						Register #(1) monitoringRegister(
							.clk(clock),
							.reset(reset),
							.dataIn(lastData),
							.dataOut(monitoringWires[column])
						);
						VU #(pixelInputWidth,svInputWidth,chainOutputWidth,controlWidth-1) Cell(
							.clock(clock),
							.reset(reset),
							.DataIn({{(chainOutputWidth-pixelInputWidth){1'b0}},pixelInputs}),
							.control({mu,enableVU,resetVU}),
							.SVin(svInputs[column*svInputWidth+svInputWidth-1:column*svInputWidth]),
							.regDataOut(dataSignals[column])
						);
						
					end
					else begin 
						if(column == (maxColumn-1))begin // [0]-[maxColumn]
							Register #(1) monitoringRegister(
								.clk(clock),
								.reset(reset),
								.dataIn(monitoringWires[column-1]),
								.dataOut(doneProcessing)
							); 
							VU #(pixelInputWidth,svInputWidth,chainOutputWidth,controlWidth-1) Cell(
								.clock(clock),
								.reset(reset),
								.DataIn(dataSignals[(column-1)]),
								.control({mu,controlSignals[column-1]}),
								.SVin(svInputs[column*svInputWidth+svInputWidth-1:column*svInputWidth]),
								.regDataOut(rowOutputs)
							);
						end
						else begin // [0]-[?]
							Register #(1) monitoringRegister(
								.clk(clock),
								.reset(reset),
								.dataIn(monitoringWires[column-1]),
								.dataOut(monitoringWires[column])
							); 
							Register #(controlWidth-2) RegisterCtrl(
								.clk(clock),
								.reset(reset),
								.dataIn(controlSignals[column-1]),
								.dataOut(controlSignals[column])
							);
							VU #(pixelInputWidth,svInputWidth,chainOutputWidth,controlWidth-1) Cell(
								.clock(clock),
								.reset(reset),
								.DataIn(dataSignals[(column-1)]),
								.control({mu,controlSignals[column-1]}),
								.SVin(svInputs[column*svInputWidth+svInputWidth-1:column*svInputWidth]),
								.regDataOut(dataSignals[column])
							);
						end
					end
	
		end	

kernelModule
	#(
		.bitwidth(chainOutputWidth),
		.alphaBitwidth(alphaBitwidth),
		.Pbitwidth(resBit)
	)
	kernel(
		.clock(clock),
		.reset(resetSU),
		.enable(enableSU),
		.dot(rowOutputs),
		.alpha(alphaInput),
		.P(kernel_result)
	);

assign dotOutput = rowOutputs;
assign svm_result = kernel_result + bias;
//assign svm_result = kernel_result;
assign class = svm_result[resBit-1];


endgenerate

endmodule
