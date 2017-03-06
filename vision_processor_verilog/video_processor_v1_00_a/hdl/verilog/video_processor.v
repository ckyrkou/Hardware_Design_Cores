//----------------------------------------------------------------------------
// video_processor - module
//----------------------------------------------------------------------------
// IMPORTANT:
// DO NOT MODIFY THIS FILE EXCEPT IN THE DESIGNATED SECTIONS.
//
// SEARCH FOR --USER TO DETERMINE WHERE CHANGES ARE ALLOWED.
//
// TYPICALLY, THE ONLY ACCEPTABLE CHANGES INVOLVE ADDING NEW
// PORTS AND GENERICS THAT GET PASSED THROUGH TO THE INSTANTIATION
// OF THE USER_LOGIC ENTITY.
//----------------------------------------------------------------------------
//
// ***************************************************************************
// ** Copyright (c) 1995-2010 Xilinx, Inc.  All rights reserved.            **
// **                                                                       **
// ** Xilinx, Inc.                                                          **
// ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
// ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
// ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
// ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
// ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
// ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
// ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
// ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
// ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
// ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
// ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
// ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
// ** FOR A PARTICULAR PURPOSE.                                             **
// **                                                                       **
// ***************************************************************************
//
//----------------------------------------------------------------------------
// Filename:          video_processor
// Version:           1.00.a
// Description:       Example FSL core (Verilog).
// Date:              Mon May 07 15:30:16 2012 (by Create and Import Peripheral Wizard)
// Verilog Standard:  Verilog-2001
//----------------------------------------------------------------------------
// Naming Conventions:
//   active low signals:                    "*_n"
//   clock signals:                         "clk", "clk_div#", "clk_#x"
//   reset signals:                         "rst", "rst_n"
//   generics:                              "C_*"
//   user defined types:                    "*_TYPE"
//   state machine next state:              "*_ns"
//   state machine current state:           "*_cs"
//   combinatorial signals:                 "*_com"
//   pipelined or register delay signals:   "*_d#"
//   counter signals:                       "*cnt*"
//   clock enable signals:                  "*_ce"
//   internal version of output port:       "*_i"
//   device pins:                           "*_pin"
//   ports:                                 "- Names begin with Uppercase"
//   processes:                             "*_PROCESS"
//   component instantiations:              "<ENTITY_>I_<#|FUNC>"
//----------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
//
//
// Definition of Ports
// FSL_Clk             : Synchronous clock
// FSL_Rst           : System reset, should always come from FSL bus
// FSL_S_Clk       : Slave asynchronous clock
// FSL_S_Read      : Read signal, requiring next available input to be read
// FSL_S_Data      : Input data
// FSL_S_Control   : Control Bit, indicating the input data are control word
// FSL_S_Exists    : Data Exist Bit, indicating data exist in the input FSL bus
// FSL_M_Clk       : Master asynchronous clock
// FSL_M_Write     : Write signal, enabling writing to output FSL bus
// FSL_M_Data      : Output data
// FSL_M_Control   : Control Bit, indicating the output data are contol word
// FSL_M_Full      : Full Bit, indicating output FSL bus is full
//
////////////////////////////////////////////////////////////////////////////////

//----------------------------------------
// Module Section
//----------------------------------------

module clock_divider(clock_fast,clock_slow);

function integer log2;
  input integer value;
  integer temp;
  begin
    temp = value-1;
    for (log2=0; temp>0; log2=log2+1)
      temp = temp >> 1;
	if(value == 1)
		log2 = 1;
  end
endfunction

	parameter delay=2;
	localparam bits = log2(delay);
	
	input clock_fast;
	output reg clock_slow;
	reg[bits-1:0] counter=0;
	
	always@(posedge clock_fast)begin
		counter <= counter + 1'b1;
		if(counter[bits-1] == 1'b1)
			clock_slow <= 1;
		else
			clock_slow <= 0;
	end

endmodule


(* RAM_STYLE="BLOCK" *) module frameBuffer(clock, enable, writeEnable, addressA, addressB, dataIn, dataOutA, dataOutB); 

function integer log2;
  input integer value;
  integer temp;
  begin
    temp = value-1;
    for (log2=0; temp>0; log2=log2+1)
      temp = temp >> 1;
  end
endfunction

parameter blockLength = 8;
parameter memDepth = 256*768;
localparam addressBitWidth = log2(memDepth);

    input  clock; 
    input  [addressBitWidth-1:0] addressA; 
    input  [addressBitWidth-1:0] addressB; 
	 input writeEnable;
    input  [blockLength-1:0] dataIn; 
	 input enable;
    output reg [blockLength-1:0] dataOutA; 
    output reg [blockLength-1:0] dataOutB; 
    reg [blockLength-1:0] ram [0:memDepth-1]; 

    always @(posedge clock) 
    begin 
	 
        if (writeEnable)begin
            ram[addressA] <= dataIn;
		  end
		  
        dataOutA <= ram[addressA];
		  
		  if(enable)
				dataOutB <= ram[addressB];

    end
   
endmodule

module AbsDifferenceIntigers(clock,A,B,sum);

	parameter Abitwidth=8;
	parameter Bbitwidth=8;
	parameter Sbitwidth=9;

	input clock;
	input[Abitwidth-1:0] A;
	input[Bbitwidth-1:0] B;

	output reg[Sbitwidth-1:0] sum;

	always@(posedge clock)begin
		if(A>B)
		sum = A - B;
			else
		sum = B - A;
	end

endmodule

//----------------------------------------
// Top Module
//----------------------------------------

module video_processor 
	(
		// ADD USER PORTS BELOW THIS LINE 
		vblank_in,
		hblank_in,
		vsync_in,
		hsync_in,
		active_video_in,
		video_data_in,
		vblank_out,
		hblank_out,
		vsync_out,
		hsync_out,
		active_video_out,
		video_data_out,
		System_Clock,
		Display_Clock,
		System_Reset,
		FSL_Reset,
		control_signals_in,
		control_signals_out,
		// ADD USER PORTS ABOVE THIS LINE 

		// DO NOT EDIT BELOW THIS LINE ////////////////////
		// Bus protocol ports, do not add or delete. 
		FSL_Clk,
		FSL_Rst,
		FSL_S_Clk,
		FSL_S_Read,
		FSL_S_Data,
		FSL_S_Control,
		FSL_S_Exists,
		FSL_M_Clk,
		FSL_M_Write,
		FSL_M_Data,
		FSL_M_Control,
		FSL_M_Full
		// DO NOT EDIT ABOVE THIS LINE ////////////////////
	);

function integer log2;
  input integer value;
  integer temp;
  begin
    temp = value-1;
    for (log2=0; temp>0; log2=log2+1)
      temp = temp >> 1;
  end
endfunction

// ADD USER PORTS BELOW THIS LINE 
// -- USER ports added here 
// ADD USER PORTS ABOVE THIS LINE 

parameter C_XSVI_DWIDTH = 24;
parameter C_CTRLDATA_WIDTH = 32;
parameter C_FAMILY = "spartan6";


	parameter frameCol=640;
	parameter frameRow=480;
	parameter imCol=320;
	parameter imRow=240;
	
	parameter memDim = frameCol*frameRow;

	parameter pixelWidth=8;
	parameter scaleWidth = 12;
	parameter winRow = 26;
	parameter winCol = 26;
	parameter winRow_Capture = 208;
	parameter winCol_Capture = 208;
	parameter winRow_Show = 104;
	parameter winCol_Show = 104;

	localparam winDim = winRow*winCol;
		
	localparam imSize=imCol*imRow;
	localparam frameSize=frameCol*frameRow;
	localparam memAddrBits = log2(memDim);
	localparam winAddrBits = log2(winDim);
	
	localparam row_left = (240-(winRow_Capture/2)); //320x240 is the center
	localparam row_right = (240+(winRow_Capture/2));
	localparam col_left = (320-(winCol_Capture/2));
	localparam col_right = (320+(winCol_Capture/2));
	
input                                     FSL_Clk;
input                                     FSL_Rst;
input                                     FSL_S_Clk;
output                                    FSL_S_Read;
input      [0 : 31]                       FSL_S_Data;
input                                     FSL_S_Control;
input                                     FSL_S_Exists;
input                                     FSL_M_Clk;
output                                    FSL_M_Write;
output     [0 : 31]                       FSL_M_Data;
output                                    FSL_M_Control;
input                                     FSL_M_Full;

input System_Clock,Display_Clock,System_Reset;

// System_Clock is 100MHz Clock
// Display_Clock is VGA Clock

input[C_CTRLDATA_WIDTH-1:0] control_signals_in;
output[C_CTRLDATA_WIDTH-1:0] control_signals_out;

output reg FSL_Reset;

input   vblank_in,hblank_in,vsync_in,hsync_in,active_video_in;
input[0:C_XSVI_DWIDTH-1] video_data_in;
output	vblank_out,hblank_out,vsync_out,hsync_out,active_video_out;
output[0:C_XSVI_DWIDTH-1] video_data_out;

reg [0:C_XSVI_DWIDTH-1] video_data_out;
reg vblank_out,hblank_out,vsync_out,hsync_out,active_video_out;

// ADD USER PARAMETERS BELOW THIS LINE 
// --USER parameters added here 
// ADD USER PARAMETERS ABOVE THIS LINE

wire[7:0] red,green,blue;
wire[7:0] red_out,green_out,blue_out,skin;

/*
video_data[23:16] = G 
video_data[15:8] = R 
video_data[7:0] = B 
*/


assign green = video_data_in[16:23];
assign red = video_data_in[8:15];
assign blue = video_data_in[0:7];

wire[pixelWidth-1:0] pixelIn; // used as input to the face verifier

wire[17:0] greyAvrg;
wire[7:0] grayValue;
reg[17:0] greyAvrg_Reg; 
reg[7:0] grayValue_Reg; 
wire[8*9-1:0] window_output;
reg[7:0] pixelValue;
wire[7:0] lbpPattern;
wire[7:0] lbpPattern_uni;
wire[7:0] lbpPattern_NR;
wire[7:0] lbpPattern_uni_NR;
wire[3:0] CS_lbpPattern;
wire[7:0] Diff_lbpPattern;
wire[7:0] edgePixels;
wire[7:0] magnitude;
wire[7:0] Gy;
wire[7:0] Gx;
reg[23:0] pixel_Out;

wire[7:0] edgeThreshold;
wire[7:0] skinThreshold;
reg[7:0] motion;
wire[7:0] cb,cr;

wire[3:0] selectProcessingOutput;

wire capture_frame;
wire show_boundary;
wire process_frame;

reg done_processing=0;

reg resetFD=0;

reg FSL_write=0;
reg[16:0] pixelCount=0;

reg resetSVM,enableSVM;

wire[49:0] result;

wire[8:0] diff;

localparam Idle  = 4'b0100;
localparam Write_Outputs  = 4'b0001;
localparam Process  = 4'b0010;
localparam Stop  = 4'b1000;

reg[3:0] state=Idle;

reg[pixelWidth-1:0] color_black = 8'b00000000;
reg[pixelWidth-1:0] color_white = 8'b11111111;

assign control_signals_out = control_signals_in;

assign selectProcessingOutput = control_signals_in[3:0];

assign edgeThreshold = control_signals_in[13:6];
assign skinThreshold = control_signals_in[11:4];

wire[2:0] LBP_Select;
wire[1:0] edge_select;

wire[25:0] dotOutput;

assign LBP_Select = control_signals_in[5:4];
assign edge_select = control_signals_in[5:4];

assign greyAvrg = (video_data_in[0:7] + video_data_in[8:15] + video_data_in[16:23]);

always@(posedge System_Clock) begin greyAvrg_Reg <= greyAvrg*(10'b0101010101); end

assign grayValue = greyAvrg_Reg[17:10];
	

   reg [memAddrBits-1:0] addressA; 
   reg [memAddrBits-1:0] addressB=0; 
	
	wire[winAddrBits-1:0] addressA_win1;
	wire [winAddrBits-1:0] addressA_win2;
	wire [winAddrBits-1:0] addressDM;
	reg [winAddrBits-1:0] addressA_win3;
	wire [winAddrBits-1:0] addressA_win;
	wire[winAddrBits-1:0] addressB_win;
	
	wire [9:-12] row_win_Show,col_win_Show,row_win_up_Show,col_win_up_Show;
	wire [9:0] row_win_up_Show_int,col_win_up_Show_int;
	
	reg[9:0] row_count=0,col_count=0;
	wire[9:0] row_win_Write,col_win_Write;
   wire[pixelWidth-1:0] dataOutA; 
   wire[pixelWidth-1:0] dataOutB; 
   wire[pixelWidth-1:0] check_data;  /// Displays the face diagram 

	wire[pixelWidth-1:0] windowPixels,windowPixelsA,windowPixelsB; 

	reg[24:0] sum=0;

	reg we;
	reg pe;
	reg sb;
	wire writeEnable,writeWindow,enableProcessing;
	reg activeRegion,activeWindow,activeProcessing;
  	wire validFace;	  

	
	assign validFace = (showWindow & class);

	 // Row and Column Counters
  
    always @(posedge Display_Clock)begin 
		if(vblank_in)begin
			row_count <= 0;
			col_count <= 0;
		end
		else
			if(active_video_in)begin
					col_count <= col_count + 1'b1;
					if(col_count == frameCol-1)begin
						row_count <= row_count + 1'b1;
						col_count <= 0;
						if(row_count == frameRow-1)begin
							row_count <= 0;	
						end
					end								
			end
    end

	// Pixel and Processing Select
  
    always @(negedge Display_Clock)begin
		
		
		if(row_count >= 0 && row_count < winRow_Show && col_count >= 0 && col_count < winCol_Show)
			activeWindow <= 1;
		else
			activeWindow <= 0;
		
		if(row_count >= row_left  && row_count < row_right && col_count >= col_left && col_count < col_right)
			activeRegion <= 1;
		else
			activeRegion <= 0;
		
		if(row_count == row_right)
			resetFD <= 1;
		else
			resetFD <= 0;
		
		if(row_count < frameRow &&  row_count > row_right)
			activeProcessing <= 1;
		else
			activeProcessing <= 0;
			
	end

	/////SELECT OUTPUT

	always @(posedge Display_Clock)begin	
	
		case(selectProcessingOutput)
		
			//0
			4'b0000:pixel_Out<={red,blue,green};
		
			//1
			4'b0001:pixel_Out<={3{grayValue}};
			
			//2
			4'b0010:begin
				case (LBP_Select)
				
					3'b000:begin
						pixel_Out<={3{lbpPattern}};
					end
					
					3'b001:begin
						pixel_Out<={3{lbpPattern_uni<<2}};
					end
					
					3'b010:begin
						pixel_Out<={3{lbpPattern_NR<<1}};
					end
					
					3'b011:begin
						pixel_Out<={3{lbpPattern_uni_NR<<2}};
					end
					
					3'b100:begin
						pixel_Out<={3{CS_lbpPattern,4'b0000}};
					end
				
					3'b101:begin
						pixel_Out<={3{Diff_lbpPattern}};
					end
					
					3'b110:begin
						pixel_Out<={3{lbpPattern}};
					end
					
					3'b111:begin
						pixel_Out<={3{lbpPattern}};
					end
					
				endcase
					
			end
			
			//3
			4'b0011:begin
				case (edge_select)
				
					2'b00:begin
						pixel_Out<={3{edgePixels}};
					end
					
					2'b01:begin
						pixel_Out<={3{magnitude}};
					end
					
					2'b10:begin
						pixel_Out<={3{Gx}};
					end
					
					2'b11:begin
						pixel_Out<={3{Gy}};
					end
				endcase
				
			end			
			//4
			4'b0100:pixel_Out<={red_out,blue_out,green_out};
			
			//5
			4'b0101:begin

				if(showWindow && class)begin			
					pixel_Out<={(windowPixels | ~check_data),(windowPixels & check_data),(windowPixels | ~check_data)};
				end
				else begin
					pixel_Out<={windowPixels,windowPixels,windowPixels};
				end
				
			end
			
			//6
			4'b0110:pixel_Out<={motion,color_black,motion};
			
			//7
			4'b0111:begin
				if(green > blue && green > red)
					pixel_Out<={color_black,color_black,green};
				else
					pixel_Out<={color_black,color_black,color_black};
			end
			
			//8
			4'b1000:begin
				if(blue > green && blue > red)
					pixel_Out<={color_black,blue,color_black};
				else
					pixel_Out<={color_black,color_black,color_black};
			end
			
			
			
			//9
			4'b1001:begin
				if(red > blue && red > green)
					pixel_Out<={red,color_black,color_black};
				else
					pixel_Out<={color_black,color_black,color_black};
			end
						
			default:	pixel_Out<={8'b00000000,8'b00000000,8'b00000000};
		
		endcase
			
    end

	always @(posedge Display_Clock)begin 
		
		if(vblank_in)begin
			FSL_write <= 0;			
			sum <= 0;
			enableSVM <= 0;
			resetSVM <= 1;
			state <= Idle;
			pixelCount <= 0;
			done_processing <= 0;
			
		end
		else begin	

			case (state)		 
			 	 			 					
			Idle:begin	
				FSL_write <= 0;
				resetSVM <= 1;
				enableSVM <= 0;
				if(pe)
					state <= Process;		
			end		
				
			Process:begin
				FSL_write <= 0;
				resetSVM <= 0;
				enableSVM <= 1;
					if(row_count == 400)begin
						state <= Write_Outputs;
						done_processing <= 1;
					end
			end

			Write_Outputs:begin	
            state <= Stop;
				FSL_write <= 1;
				enableSVM <= 0;	
				resetSVM <= 0;	
			end
			
			Stop:begin	
				FSL_write <= 0;
				enableSVM <= 0;	
				resetSVM <= 0;	
			end

        endcase			
						
		end
    end

	// Display and Store Frame
	
	assign writeEnable = active_video_in & we;
	
	assign showWindow = activeWindow & active_video_in;
	assign writeWindow = activeRegion & active_video_in;
	// OLD Code. We do not need active_video_in since the data is already in memory. active_video_in becomes 0 and 1 as image is displayed
	//assign enableProcessing = activeProcessing & active_video_in; 
	// OLD Code.
	assign enableProcessing = activeProcessing;

	assign lbpPattern_NR = 	(127 < lbpPattern) ? 255-lbpPattern : lbpPattern;
	
	always @(posedge Display_Clock) begin

		if(vblank_in)begin
		
			addressB <= 0;
			addressA <= 0;
			//addressA_win3<= 0;
			
			if(process_frame)
				pe <= 1;
			else
				pe <= 0;
				
			if(capture_frame)
				we <= 0;
			else
				we <= 1;
			
		end
		else begin
			we <= we;
			
			// Capture Frame			
			if (writeEnable)begin
				addressA <= addressA + 1'b1;
			end
			
			// Display Frame
			if (active_video_in)begin
				addressB <= (addressB + 1'b1);
			end

			// Process Window
			//if (enableProcessing)begin
			//		addressA_win3<= addressA_win3 + 1'b1;
			//end
		
		end
		
   end
	
	always@(posedge Display_Clock)begin
		if(resetFD)
			addressA_win3<= 0;
		else
			if (enableProcessing)
				addressA_win3 <= addressA_win3 + 1'b1;
			else
				addressA_win3 <= 0;
				
	end
	
	/*
	always@(posedge Display_Clock)begin
		
		if(vblank_in)begin
			addressA_win1 <= 0;
		end
		else begin
		// Display Window
			if (writeWindow || showWindow)begin
				if(addressA_win1 == (16*winDim-1))
					addressA_win1 <= 0;
				else
					addressA_win1 <= addressA_win1 + 1'b1;
			end
		end
	end
	*/
	
	reg[11:0] rowScaleFactor_up = 12'b000011011101; // 480/26 -> 18.4615 | 1/18.4615 -> 0.054166 
	reg[11:0] colScaleFactor_up = 12'b000010100110; // 640/26 -> 24.6153 | 1/24.6153 -> 0.040625
	
	assign row_win_up_Show = row_count*rowScaleFactor_up;
	assign col_win_up_Show = col_count*colScaleFactor_up;
	
	assign row_win_up_Show_int = row_win_up_Show[9:0];
	assign col_win_up_Show_int = col_win_up_Show[9:0];
	
	reg[11:0] rowScaleFactor = 12'b000011011101; // 480/26 -> 18.4615 | 1/18.4615 -> 0.054166 
	reg[11:0] colScaleFactor = 12'b000010100110; // 640/26 -> 24.6153 | 1/24.6153 -> 0.040625

	assign row_win_Write = (row_count-row_left);
	assign col_win_Write = (col_count-col_left);

	assign row_win_Show = row_win_Write;
	assign col_win_Show = col_win_Write;

			//assign addressB_win = (((row_win_Show[4:0])*(5'b10100)) + col_count[9:5]); // SHOW UPSCALED WINDOW 20x20		
	assign addressB_win = (((row_win_up_Show_int)*(5'b11010)) + col_win_up_Show_int); // SHOW UPSCALED WINDOW 26x26	
	
	// Read a pixel from the 26x26 window every 8 cycles Hence exclude [2:0] 208/26 = 8
	assign addressA_win1 = (((row_win_Write[7:3])*(5'b11010)) + col_win_Write[7:3]); //WRITE WINDOW 26x26
	
	// Read a pixel from the 26x26 window every 4 cycles Hence exclude [1:0] 104/26 = 4 
	assign addressA_win2 = (((row_count[6:2])*(5'b11010)) + col_count[6:2]);
	
	// Read a pixel from the 26x26 show if face indicator memory 
	//assign addressDM = (((row_count[9:2])*(5'b11010)) + col_count[9:2]);
	
	assign addressA_win = (enableProcessing) ? addressA_win3 : (showWindow) ? addressA_win2 : addressA_win1;
	
	assign windowPixels = (showWindow) ? windowPixelsA : windowPixelsB; //previous
	//assign windowPixels = (showWindow) ? pixelIn : pixelInB; // use pixelIn to output from static mem
	
	AbsDifferenceIntigers abs_diff(Display_Clock,dataOutB,grayValue_Reg,diff);	

	always@(posedge Display_Clock)begin
	
		if(diff > 50)
			motion <= diff;
		else
			motion <= color_black;
	
	end

	assign pixelIn = windowPixelsA;
	wire[7:0] pixelInB;  // Used to show upscaled window from copy image

frameBuffer #(
	.blockLength(pixelWidth),
	.memDepth(winDim)
	) 
	WM (
	.clock(Display_Clock),
	.writeEnable(writeWindow),
	.addressA(addressA_win),
	.addressB(addressB_win),
	.dataIn(grayValue),
	.enable(active_video_in),
	.dataOutA(windowPixelsA),
	.dataOutB(windowPixelsB)
	);

frameBuffer #(
	.blockLength(pixelWidth),
	.memDepth(memDim)
	) 
	FB (
		.clock(Display_Clock),
		.writeEnable(writeEnable),
		.addressA(addressA),
		.addressB(addressB),
		.dataIn(grayValue),
		.enable(active_video_in),
		.dataOutA(),
		.dataOutB(dataOutB)
	);

	ROM #(
	.blockLength(pixelWidth),
	.memDepth(winDim),
	.file("face.txt")
	)
	faceIndicator_mem(
	.clock(Display_Clock), 
	.address(addressA_win2), 
	.dataOut(check_data)
	);

/*
//Show this mem for static evaluation 
	ROM #(
	.blockLength(pixelWidth),
	.memDepth(winCol*winRow),
	.file("pos.txt")
	)
	pos_memA(
	.clock(Display_Clock), 
	.address(addressA_win), 
	.dataOut(pixelIn)
	);


//Show this mem for static evaluation 
	ROM #(
	.blockLength(pixelWidth),
	.memDepth(winCol*winRow),
	.file("pos.txt")
	)
	pos_memB(
	.clock(Display_Clock), 
	.address(addressB_win), 
	.dataOut(pixelInB)
	);
*/

faceVerifier # (
	.pixelWidth(pixelWidth),
	.winCol(winCol),
	.winRow(winRow),
	.boxPerRow(8),
	.boxPerCol(8),
	.num_of_bins(32)
	)
	FD(
		.clock(Display_Clock),
		.pixelIn(pixelIn),
		.address(addressA_win3),
		.reset(resetFD),
		.class(class),
		.testSignal1(testSignal1),
		.testSignal2(testSignal2),
		.testSignal3(testSignal3),
		.testSignal4(testSignal4),
		.enableProcessing(enableProcessing)
	);

	`ifdef XILINX_ISIM 

		assign FSL_M_Control = testSignal4;
		
	`endif	

WindowBuffer #(
	.winRow(3),
	.imCol(640),
	.winCol(3),
	.bitwidth(8)
	)
	WB_video_processor(
		.clock(Display_Clock),
		.valid(),
		.reset(1'b0),
		.enable(active_video_in),
		.dataIn(grayValue),
		.dataOut(window_output)
	);

lbp #(
	.inputWidth(8)
	)
	lbp_processor(
		.windowIn(window_output),
		.lbpPattern(lbpPattern)
	);

cs_lbp #(
	.inputWidth(8),
	.threshold(5)
	)
	cs_lbp_processor(
		.windowIn(window_output),
		.lbpPattern(CS_lbpPattern)
	);

difference_lbp #(
	.inputWidth(8),
	.threshold(5)
	)
	diff_lbp_processor(
		.windowIn(window_output),
		.lbpPattern(Diff_lbpPattern)
	);
	
LBP_Uniform_Patterns LBP_UNI(Display_Clock,lbpPattern,lbpPattern_uni);

LBP_Uniform_Patterns LBP_UNI_NR(Display_Clock,lbpPattern_NR,lbpPattern_uni_NR);

edgeUnit #(
	.inputWidth(8)
	)
	edge_processor(
		.windowIn(window_output),
		.threshold(edgeThreshold),
		.edgePixel(edgePixels)
	);

Gradient #(
	.inputWidth(8)
	)
	gradient_processor(
		.windowIn(window_output),
		.Gx_out(Gx),
		.Gy_out(Gy),
		.magnitude(magnitude)
	);

skin_detector SD(
		.clock(Display_Clock),
		.skinThreshold(skinThreshold),
		.red(red),
		.green(green),
		.blue(blue),
		.skin(skin),
		.red_out(red_out),
		.green_out(green_out),
		.blue_out(blue_out),
		.cb_round(cb),
		.cr_round(cr)
	);


	// Assign Signals to Output

	always@(posedge Display_Clock) begin
		vblank_out <= vblank_in;
		hblank_out <= hblank_in; 
		vsync_out <= vsync_in;
		hsync_out <= hsync_in;
		active_video_out <= active_video_in;	
		video_data_out <= pixel_Out;
		grayValue_Reg = grayValue;
	end

   // Total number of input data.
   localparam NUMBER_OF_INPUT_WORDS  = 1;

   // Total number of output data
   localparam NUMBER_OF_OUTPUT_WORDS = 1;

   // Define the states of state machine

   // Counters to store the number inputs read & outputs written
   reg [0:NUMBER_OF_INPUT_WORDS - 1] nr_of_reads;
   reg [0:NUMBER_OF_OUTPUT_WORDS - 1] nr_of_writes;

   // CAUTION:
   // The sequence in which data are read in should be
   // consistent with the sequence they are written in the
   // driver's video_processor.c file

   assign FSL_S_Read  = (state == Write_Outputs) ? FSL_S_Exists : 0;	
   assign FSL_M_Write = FSL_write;

   assign FSL_M_Data = pixelCount;

endmodule
