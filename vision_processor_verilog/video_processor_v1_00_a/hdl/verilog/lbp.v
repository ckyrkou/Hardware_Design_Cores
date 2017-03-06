module lbp(windowIn,lbpPattern); // 3x3 Center Threshold Pattern Computation

	parameter inputWidth=8;
	
	input[inputWidth*9-1:0] windowIn; 

	wire[inputWidth-1:0] win[0:8];
	wire[0:8] comparisonString;

	output [7:0] lbpPattern;
	
	generate

	// Make comparisons and compute LBP pattern

	genvar i;
	genvar j;		
			
		for(i=0;i<9;i=i+1)begin: winExtract
			assign win[i] = windowIn[(i*inputWidth)+inputWidth-1:(i*inputWidth)];
		end

		for(i=0;i<9;i=i+1)begin: meanComparison
			//assign comparisonString[i] = (win[i] >= win[5]) ? 1'b1 : 1'b0;
			assign comparisonString[i] = (win[i] >= win[4]) ? 1'b1 : 1'b0;
		end

	endgenerate

	assign lbpPattern = {comparisonString[8],comparisonString[7],comparisonString[6],comparisonString[3],comparisonString[0],comparisonString[1],comparisonString[2],comparisonString[5]};

endmodule

