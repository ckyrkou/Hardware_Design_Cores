`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:17:47 03/23/2008 
// Design Name: 
// Module Name:    controller 
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
module ControllerUnitSVM(clock,userReset,dataValid,lastElement,lastEnabled,enableAlphaU,
enableAlphaMem,lastScalar,processedScalars,reset,resetVU,resetSU,enableVU,enableSU,transfer,enableMems,
AddressEnable,addBias);

function integer log2;
  input integer value;
  begin
    value = value-1;
    for (log2=0; value>0; log2=log2+1)
      value = value>>1;
  end
endfunction

parameter statesBitwidth=16;

parameter maxColumn=4;
parameter counterBitwidth=7;

	parameter S0  = 16'b0000000000000001; //1
   parameter S1  = 16'b0000000000000010; //2
   parameter S2  = 16'b0000000000000100; //4
   parameter S3  = 16'b0000000000001000; //8
   parameter S4  = 16'b0000000000010000; //16
   parameter S5  = 16'b0000000000100000; //32
   parameter S6  = 16'b0000000001000000; //64
   parameter S7  = 16'b0000000010000000; //128
   parameter S8  = 16'b0000000100000000; //256
   parameter S9  = 16'b0000001000000000; //512
   parameter S10 = 16'b0000010000000000; //1024
   parameter S11 = 16'b0000100000000000; //2048
   parameter S12 = 16'b0001000000000000; //4096
   parameter S13 = 16'b0010000000000000; //8192
   parameter S14 = 16'b0100000000000000; //16384
   parameter S15 = 16'b1000000000000000; //32768



input clock;
input userReset;
input dataValid;

//Transfer after the final VU has finished
//MUX results until first VU has transfered

input lastElement;
input lastEnabled;
input processedScalars;
input lastScalar;

output reg enableAlphaU;
output reg enableAlphaMem;
output reg reset;
output reg resetVU;
output reg resetSU;
output reg enableVU;
output reg enableSU;
output reg transfer;
output reg enableMems;
output reg AddressEnable;
output reg addBias;

reg[statesBitwidth-1:0] state=S0;

reg[log2(maxColumn):0] counter=0;

reg stopSU = 0;

always@(posedge clock)begin
	
	if(enableSU)begin
		//if(counter == maxColumn-2)begin // For Demo on Virtex 5
		if(counter == maxColumn)begin
			counter <= counter;
			stopSU <= 1;
		end
		else begin
			stopSU <= 0;
			counter <= counter + 1;
		end
		
	end
	else begin
	
		counter <= 0;
		stopSU <= 0;
	
	end
	
end



always@(posedge clock)begin

		if(userReset == 1)begin
			state <= S0;
			reset <= 1;
			resetSU <= 1;
			resetVU <= 1;
			enableVU <= 0;
			enableSU <= 0;
			transfer <= 0;
			enableMems <= 0;
			AddressEnable <= 0;
			enableAlphaU <= 0;
			enableAlphaMem <= 0;
			addBias <= 0;

		end		
		else begin
		
			case(state)

				//Reset State
				S0:begin  ///1
					state <= S1;
					reset <= 1;
					resetSU <= 1;
					resetVU <= 1;
					enableVU <= 0;
					enableSU <= 0;
					transfer <= 0;
					enableMems <= 0;
					AddressEnable <= 0;
					enableAlphaU <= 0;
					enableAlphaMem <= 0;
					addBias <= 0;
				end
				
				//Enable Address
				S1:begin  ///2
					if(dataValid)begin
						resetVU <= 0;
						state <= S2;	
						enableMems <= 1;
						AddressEnable <= 1;
					end
					reset <= 0;
					resetSU <= 1;
					//enableVU <= 0;
					enableSU <= 0;
					transfer <= 0;
					enableAlphaU <= 0;
					enableAlphaMem <= 0;
					addBias <= 0;
				end
				
				// Enable VUs
				S2:begin  ///4
					state <= S3;
					reset <= 0;
					resetVU <= 0;
					resetSU <= 1;
					enableSU <= 0;
					transfer <= 0;
					enableVU <= 1;
					enableAlphaU <= 0;
					enableAlphaMem <= 0;
					addBias <= 0;
				end
				
				
				S3:begin  ///8				
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableSU <= 0;
					//enableAlphaU <= 0;
					transfer <= 0;
					addBias <= 0;
					if(lastElement)begin
						state <= S4;
						enableMems <= 0;
						AddressEnable <= 0;
						enableVU <= 0;
						//enableAlphaU <= 1;
						//enableAlphaMem <= 1;
					end
					//else begin
						//state = S3;		
						//AddressEnable = 1;		
					//end
				end
						
				// Disable VUs
				S4:begin  ///16
					if(lastEnabled)begin  // If enable is zero
						state <= S5;
						transfer <= 1;
						enableAlphaU <= 1;
					end
					enableAlphaMem <= 0;
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;
					enableSU <= 0;
					enableMems <= 0;
					addBias <= 0;
					AddressEnable <= 0;
				end	

				//Start transfer of Scalars and enable Alpha Unit in first round				
				
				S5:begin  ///32
					reset <= 0;
					transfer <= 0;
					enableAlphaMem <= 1;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;
					enableSU <= 1; ///5:20 8/7
					enableMems <= 0;
					AddressEnable <= 0;
					addBias <= 0;
					state <= S6;
					
				end
									
				S6:begin  ///64
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;		
					transfer <= 0;
					enableMems <= 0;
					AddressEnable <= 0;		
					addBias <= 0;
					if(processedScalars)begin
						state <= S7;	
					end
				end
				
				S7:begin  ///128
					state <= S8;
					enableSU <= 1;
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;
					enableAlphaU <= 0;
					enableAlphaMem <= 1;
					transfer <= 0;
					enableMems <= 0;
					AddressEnable <= 0;
					addBias <= 0;
				end
				
				S8:begin  ///256
					state <= S9;
					enableSU <= 1;
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;
					enableAlphaU <= 0;
					enableAlphaMem <= 0;
					transfer <= 0;
					enableMems <= 0;
					AddressEnable <= 0;
					addBias <= 0;
				end
				
				// Disable Scalar Units
				S9:begin  ///512
					if(stopSU)begin
						enableSU <= 0;	
						state <= S10;
					end
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;
					enableAlphaU <= 0;
					enableAlphaMem <= 0;
					transfer <= 0;
					enableMems <= 0;
					AddressEnable <= 0;
					addBias <= 0;
				end
				
				S10:begin  ///1024
					if((enableSU == 0) && (lastScalar == 1))begin
						state <= S11;
						addBias <= 1;
					end
					enableSU <= 0;
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;
					enableAlphaU <= 0;
					enableAlphaMem <= 0;
					transfer <= 0;
					enableMems <= 0;
					AddressEnable <= 0;
				end

				S11:begin  ///2048 wait for reset
					state <= S11;
					addBias <= 1;
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;
					enableSU <= 0;
					transfer <= 0;
					enableAlphaU <= 0;
					enableAlphaMem <= 0;
					enableMems <= 0;
					AddressEnable <= 0;
				end
				
				//Default State
				default:begin
					state <= S0;
					addBias <= 0;
					reset <= 0;
					resetVU <= 0;
					resetSU <= 0;
					enableVU <= 0;
					enableSU <= 0;
					transfer <= 0;
					enableAlphaU <= 0;
					enableAlphaMem <= 0;
					enableMems <= 0;
					AddressEnable <= 0;
				end
	
			endcase
	end
end

endmodule
