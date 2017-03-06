module Gradient(windowIn,Gx_out,Gy_out,magnitude);

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

	parameter inputWidth=8;
	
	input[inputWidth*9-1:0] windowIn; 
	
	wire[inputWidth-1:0] win[0:8];

	output[inputWidth-1:0] Gx_out;
	wire[inputWidth:0] abs_Gx;
	wire signed[inputWidth:0] Gx;
	output[inputWidth-1:0] Gy_out;
	wire[inputWidth:0] abs_Gy;
	wire signed[inputWidth:0] Gy;
	
	wire[inputWidth:0] sum;
	
	output[inputWidth-1:0] magnitude;

	
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
		assign win[1] = 255;
		assign win[2] = 132;
		assign win[3] = 255;
		assign win[4] = 227;
		assign win[5] = 255;
		assign win[6] = 180;
		assign win[7] = 255;	
		assign win[8] = 164;	
		*/
		assign abs_Gx =  (win[1] > win[7]) ? win[1]-win[7] : win[7] - win[1];
		assign Gx =  (win[1] - win[7]) + $signed({1'b0,8'b11111111});
		
		assign abs_Gy =  (win[3] > win[5]) ? win[3]-win[5] : win[5] - win[3];
		assign Gy =  (win[3] - win[5]) + $signed({1'b0,8'b11111111});

		assign sum = abs_Gx + abs_Gy;
		
	   assign magnitude = sum >> 1;
		
	   assign Gx_out = Gx >> 1;
	   assign Gy_out = Gy >> 1;
	
	
endmodule

