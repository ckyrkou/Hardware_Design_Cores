//
// Dual-Port Block RAM with Two Write Ports
//

(* RAM_STYLE="BLOCK" *)module dualPortBRamInstantiation(clka,clkb,ena,enb,wea,web,addressA,addressB,dataInA,dataInB,dataOutA,dataOutB);

//---------------- FUNCTIONS ----------------------------

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

//---------------- PARAMETERS ----------------------------

	 parameter blockLength = 8;
	 parameter memDepth = 320*240;
	 parameter file = "init.im";

	localparam addressBitWidth=log2(memDepth-1);
	 
    input  clka,clkb,ena,enb,wea,web;
    input  [addressBitWidth-1:0]  addressA,addressB;
    input  [blockLength-1:0] dataInA,dataInB;
    output reg[blockLength-1:0] dataOutA,dataOutB;
    reg    [blockLength-1:0] ram[0:memDepth-1];

	 initial
    begin
		  $readmemb(file,ram);
	 end

    always @(posedge clka) begin
        if (ena)    
        begin
            if (wea)begin
               ram[addressA] <= dataInA;
					dataOutA <= dataInA;
				end
				else begin
						dataOutA <= ram[addressA];
				end
        end
    end

    always @(posedge clkb) begin
        if (enb)
        begin
            if (web)begin
               ram[addressB] <= dataInB;
					dataOutB <= dataInB;
				end
				else begin
					dataOutB <= ram[addressB];
				end
        end
    end

endmodule
