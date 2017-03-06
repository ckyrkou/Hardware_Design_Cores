module cs_lbp(windowIn,lbpPattern); // 3x3 Center Symetric LBP Patterns

	parameter inputWidth=8;
	parameter threshold=5;
	
	input[inputWidth*9-1:0] windowIn; 

	wire[inputWidth-1:0] win[0:8];
	wire[7:0] comparisonString[0:8];

	output [3:0] lbpPattern;
	
	generate

	// Make comparisons and compute LBP pattern

	genvar i;
	genvar j;		
			
		for(i=0;i<9;i=i+1)begin: winExtract
			assign win[i] = windowIn[(i*inputWidth)+inputWidth-1:(i*inputWidth)];
		end

	endgenerate

	assign comparisonString[0] = (win[3]>win[5]) ? win[3]-win[5] : win[5]-win[3];
	assign comparisonString[1] = (win[0]>win[8]) ? win[0]-win[8] : win[8]-win[0];
	assign comparisonString[2] = (win[1]>win[7]) ? win[1]-win[7] : win[7]-win[1];
	assign comparisonString[3] = (win[2]>win[6]) ? win[2]-win[6] : win[6]-win[2];

	assign lbpPattern[0] = (comparisonString[0] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[1] = (comparisonString[1] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[2] = (comparisonString[2] > threshold) ? 1'b1 : 1'b0;
	assign lbpPattern[3] = (comparisonString[3] > threshold) ? 1'b1 : 1'b0;
	
endmodule

