module edgeUnit(windowIn,threshold,edgePixel); // 3x3 Center Threshold Pattern Computation

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

	parameter inputWidth=8;
	
	localparam sumWidth = inputWidth+3;
	
	input[inputWidth*9-1:0] windowIn; 
	input[inputWidth-1:0] threshold;
	
	wire[inputWidth-1:0] win[0:8];

	wire signed[sumWidth-1:0] Gx_1;
	wire signed[sumWidth-1:0] Gx_2;
	wire signed[sumWidth-1:0] Gx;
	wire signed[sumWidth-1:0] absGx;
	wire signed[sumWidth-1:0] Gy_1;
	wire signed[sumWidth-1:0] Gy_2;
	wire signed[sumWidth-1:0] Gy;
	wire signed[sumWidth-1:0] absGy;
	
	wire[sumWidth-1:0] sum;
	
	output[inputWidth-1:0] edgePixel;

	
	/*
	[0] [1] [2]
	[3] [4] [5]
	[6] [7] [8]
	*/

	generate

	// Make comparisons and compute LBP pattern

	genvar i;
		
			
		for(i=0;i<9;i=i+1)begin: winExtract
			assign win[i] = windowIn[(i*inputWidth)+inputWidth-1:(i*inputWidth)];
		end		

	endgenerate
		/*
		assign win[0] = 100;
		assign win[1] = 128;
		assign win[2] = 132;
		assign win[3] = 58;
		assign win[4] = 227;
		assign win[5] = 10;
		assign win[6] = 180;
		assign win[7] = 64;	
		assign win[8] = 164;	
		*/
		assign Gx_1 =  win[0] + 2*win[3] + win[6];
		assign Gx_2 =  win[2] + 2*win[5] + win[8];
		assign Gx = Gx_2 - Gx_1;
		
		assign Gy_1 = win[0] + 2*win[1] + win[2];
		assign Gy_2 = win[6] + 2*win[7] + win[8];
		assign Gy = Gy_2 - Gy_1;
		
		assign absGx = (Gx > 0) ? Gx  : ((~Gx) + 1'b1);
		assign absGy = (Gy > 0) ? Gy  : ((~Gy) + 1'b1);

		assign sum = (absGx + absGy);
			
		assign edgePixel = (sum > threshold) ? {inputWidth{1'b1}} : {inputWidth{1'b0}};
	
	
endmodule

