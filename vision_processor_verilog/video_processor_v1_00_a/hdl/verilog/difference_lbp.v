module difference_lbp(windowIn,lbpPattern); // 3x3 Center Threshold Pattern Computation

	parameter inputWidth=8;
		parameter threshold=5;
		
	input[inputWidth*9-1:0] windowIn; 

	wire[inputWidth-1:0] win[0:8];
	wire[7:0] comparisonString[0:7];

	output [7:0] lbpPattern;
	
	generate

	// Make comparisons and compute LBP pattern

	genvar i;
	genvar j;		
			
		for(i=0;i<9;i=i+1)begin: winExtract
			assign win[i] = windowIn[(i*inputWidth)+inputWidth-1:(i*inputWidth)];
		end

	endgenerate

	assign comparisonString[0] = (win[0]>win[1]) ? win[0]-win[1] : win[1]-win[0];
	assign comparisonString[1] = (win[1]>win[2]) ? win[1]-win[2] : win[2]-win[1];
	assign comparisonString[2] = (win[2]>win[5]) ? win[2]-win[5] : win[5]-win[2];
	assign comparisonString[3] = (win[5]>win[8]) ? win[5]-win[8] : win[8]-win[5];
	assign comparisonString[4] = (win[8]>win[7]) ? win[8]-win[7] : win[7]-win[8];
	assign comparisonString[5] = (win[7]>win[6]) ? win[7]-win[6] : win[6]-win[7];
	assign comparisonString[6] = (win[6]>win[3]) ? win[6]-win[3] : win[3]-win[6];
	assign comparisonString[7] = (win[3]>win[0]) ? win[3]-win[1] : win[1]-win[3];

	assign lbpPattern[0] = (comparisonString[0] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[1] = (comparisonString[1] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[2] = (comparisonString[2] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[3] = (comparisonString[3] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[4] = (comparisonString[4] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[5] = (comparisonString[5] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[6] = (comparisonString[6] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[7] = (comparisonString[7] > threshold) ? 1'b1 : 1'b0;
	
endmodule

