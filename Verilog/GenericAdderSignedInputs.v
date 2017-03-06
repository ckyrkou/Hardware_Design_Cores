`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:47:43 03/03/2009 
// Design Name: 
// Module Name:    adder 
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
module GenericAdderSignedInputs(A,B,sum);

parameter Abitwidth=21;
parameter Bbitwidth=21;
parameter Sbitwidth=22;
parameter signedInput = 0;

input[Abitwidth-1:0] A;
input[Bbitwidth-1:0] B;

output [Sbitwidth-1:0] sum;

generate

if(signedVectorInputs == 0)begin
	assign sum = A + B;
end

if(signedVectorInputs == 1)begin
	
	xor(sign,multiplicand[bitwidthA-1],multiplier[bitwidthB-1]);
	wire[multWidth-3:0] productMult;
	
	assign productMult = multiplicand[bitwidthA-2:0]*multiplier[bitwidthB-2:0];

	assign product = (sign) ? ~(productMult)+1 : productMult;

end

endgenerate

endmodule
