`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:15:33 10/24/2013 
// Design Name: 
// Module Name:    rgb2ycrcb 
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
module rgb2ycrcb(clock,red,green,blue,cb_round,cr_round,red_out,green_out,blue_out);

	 parameter bitwidth = 8;
	 parameter fraction_bitwidth = 12;
	 
	 
	 input[bitwidth-1:0] red,green,blue;
	 
	 input clock;
	 	 
	 reg signed[-1:-fraction_bitwidth] 	
								cb_coeff1=32'b001001011110,
								//cb_coeff1=32'b110110100010,
								cb_coeff2=32'b010010100111,
								//cb_coeff2=32'b101101011001,
								cb_coeff3=32'b011100000110;
	// cb_coeff1 - 0.148 red
	// cb_coeff2 - 0.291 green
	// cb_coeff3 - 0.439 blue
	 
	 reg signed[-1:-fraction_bitwidth] 	
								cr_coeff1=32'b011100000110,
								cr_coeff2=32'b010111100011,
								//cr_coeff2=32'b101000011101,
								cr_coeff3=32'b000100100010;
								//cr_coeff3=32'b111011011110;
	// cr_coeff1 - 0.439 red
	// cr_coeff2 - 0.368 green
	// cr_coeff3 - 0.071 blue
	 
	 wire[bitwidth-1:-fraction_bitwidth] const;
	 
	 wire checkLessThan_cb;
	 wire checkLessThan_cr;
	 
	 assign const[bitwidth-1:0] = 128;
	 assign const[-1:-fraction_bitwidth] = 0;
	 
	 //output[2*bitwidth-1:0] y;
    wire signed[bitwidth-1:-fraction_bitwidth] cb,cr;
	 reg [bitwidth-1:-fraction_bitwidth] cb_1,cr_1,cb_2,cr_2,cb_3,cr_3;
	 wire [bitwidth-1:-fraction_bitwidth] cb_negs,cr_negs;
	
	 output signed[bitwidth-1:0] cb_round,cr_round;	
	 output reg[bitwidth-1:0] red_out,green_out,blue_out;	
	
	 //assign y = (coeff1*red + coeff2*green + coeff3*blue) >> bitwidth;
	
		always@(posedge clock)begin
			cb_1 = cb_coeff1*red;
			cb_2 = cb_coeff2*green;
			cb_3 = cb_coeff3*blue;
			//cb_negs = cb_1 + cb_2;
			//cb = cb_3 - cb_negs;
			
			cr_1 = cr_coeff1*red;
			cr_2 = cr_coeff2*green;
			cr_3 = cr_coeff3*blue;
			//cr_negs = cr_2 + cr_3;
			//cr = cr_1 - cr_negs;
			

			red_out <= red;
			blue_out <= blue;
			green_out <= green;
			
		end

		assign cb = (cb_1 - cb_2 + cb_3);
		assign cr = (cr_1 - cr_2 - cr_3);
	
		assign checkLessThan_cb = (cb < 0) ? 1'b1 : 1'b0;
		assign checkLessThan_cr = (cr < 0) ? 1'b1 : 1'b0;
	
		assign cb_round = (checkLessThan_cb) ? 8'b00000000 : cb[bitwidth-1:0];
		assign cr_round = (checkLessThan_cr) ? 8'b00000000 : cr[bitwidth-1:0];
	
endmodule
