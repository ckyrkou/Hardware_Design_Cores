`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:23:07 05/29/2009 
// Design Name: 
// Module Name:    nBitRegister 
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

module LBP_Uniform_Patterns(clock,dataIn,dataOut);

input clock;
input[7:0] dataIn;
reg[7:0] mem[0:399];
output reg[7:0] dataOut;


initial begin

	mem[0]=1;
	mem[1]=2;
	mem[2]=3;
	mem[3]=4;
	mem[4]=5;
	mem[5]=0;
	mem[6]=6;
	mem[7]=7;
	mem[8]=8;
	mem[9]=0;
	mem[10]=0;
	mem[11]=0;
	mem[12]=9;
	mem[13]=0;
	mem[14]=10;
	mem[15]=11;
	mem[16]=12;
	mem[17]=0;
	mem[18]=0;
	mem[19]=0;
	mem[20]=0;
	mem[21]=0;
	mem[22]=0;
	mem[23]=0;
	mem[24]=13;
	mem[25]=0;
	mem[26]=0;
	mem[27]=0;
	mem[28]=14;
	mem[29]=0;
	mem[30]=15;
	mem[31]=16;
	mem[32]=17;
	mem[33]=0;
	mem[34]=0;
	mem[35]=0;
	mem[36]=0;
	mem[37]=0;
	mem[38]=0;
	mem[39]=0;
	mem[40]=0;
	mem[41]=0;
	mem[42]=0;
	mem[43]=0;
	mem[44]=0;
	mem[45]=0;
	mem[46]=0;
	mem[47]=0;
	mem[48]=18;
	mem[49]=0;
	mem[50]=0;
	mem[51]=0;
	mem[52]=0;
	mem[53]=0;
	mem[54]=0;
	mem[55]=0;
	mem[56]=19;
	mem[57]=0;
	mem[58]=0;
	mem[59]=0;
	mem[60]=20;
	mem[61]=0;
	mem[62]=21;
	mem[63]=22;
	mem[64]=23;
	mem[65]=0;
	mem[66]=0;
	mem[67]=0;
	mem[68]=0;
	mem[69]=0;
	mem[70]=0;
	mem[71]=0;
	mem[72]=0;
	mem[73]=0;
	mem[74]=0;
	mem[75]=0;
	mem[76]=0;
	mem[77]=0;
	mem[78]=0;
	mem[79]=0;
	mem[80]=0;
	mem[81]=0;
	mem[82]=0;
	mem[83]=0;
	mem[84]=0;
	mem[85]=0;
	mem[86]=0;
	mem[87]=0;
	mem[88]=0;
	mem[89]=0;
	mem[90]=0;
	mem[91]=0;
	mem[92]=0;
	mem[93]=0;
	mem[94]=0;
	mem[95]=0;
	mem[96]=24;
	mem[97]=0;
	mem[98]=0;
	mem[99]=0;
	mem[100]=0;
	mem[101]=0;
	mem[102]=0;
	mem[103]=0;
	mem[104]=0;
	mem[105]=0;
	mem[106]=0;
	mem[107]=0;
	mem[108]=0;
	mem[109]=0;
	mem[110]=0;
	mem[111]=0;
	mem[112]=25;
	mem[113]=0;
	mem[114]=0;
	mem[115]=0;
	mem[116]=0;
	mem[117]=0;
	mem[118]=0;
	mem[119]=0;
	mem[120]=26;
	mem[121]=0;
	mem[122]=0;
	mem[123]=0;
	mem[124]=27;
	mem[125]=0;
	mem[126]=28;
	mem[127]=29;
	mem[128]=30;
	mem[129]=31;
	mem[130]=0;
	mem[131]=32;
	mem[132]=0;
	mem[133]=0;
	mem[134]=0;
	mem[135]=33;
	mem[136]=0;
	mem[137]=0;
	mem[138]=0;
	mem[139]=0;
	mem[140]=0;
	mem[141]=0;
	mem[142]=0;
	mem[143]=34;
	mem[144]=0;
	mem[145]=0;
	mem[146]=0;
	mem[147]=0;
	mem[148]=0;
	mem[149]=0;
	mem[150]=0;
	mem[151]=0;
	mem[152]=0;
	mem[153]=0;
	mem[154]=0;
	mem[155]=0;
	mem[156]=0;
	mem[157]=0;
	mem[158]=0;
	mem[159]=35;
	mem[160]=0;
	mem[161]=0;
	mem[162]=0;
	mem[163]=0;
	mem[164]=0;
	mem[165]=0;
	mem[166]=0;
	mem[167]=0;
	mem[168]=0;
	mem[169]=0;
	mem[170]=0;
	mem[171]=0;
	mem[172]=0;
	mem[173]=0;
	mem[174]=0;
	mem[175]=0;
	mem[176]=0;
	mem[177]=0;
	mem[178]=0;
	mem[179]=0;
	mem[180]=0;
	mem[181]=0;
	mem[182]=0;
	mem[183]=0;
	mem[184]=0;
	mem[185]=0;
	mem[186]=0;
	mem[187]=0;
	mem[188]=0;
	mem[189]=0;
	mem[190]=0;
	mem[191]=36;
	mem[192]=37;
	mem[193]=38;
	mem[194]=0;
	mem[195]=39;
	mem[196]=0;
	mem[197]=0;
	mem[198]=0;
	mem[199]=40;
	mem[200]=0;
	mem[201]=0;
	mem[202]=0;
	mem[203]=0;
	mem[204]=0;
	mem[205]=0;
	mem[206]=0;
	mem[207]=41;
	mem[208]=0;
	mem[209]=0;
	mem[210]=0;
	mem[211]=0;
	mem[212]=0;
	mem[213]=0;
	mem[214]=0;
	mem[215]=0;
	mem[216]=0;
	mem[217]=0;
	mem[218]=0;
	mem[219]=0;
	mem[220]=0;
	mem[221]=0;
	mem[222]=0;
	mem[223]=42;
	mem[224]=43;
	mem[225]=44;
	mem[226]=0;
	mem[227]=45;
	mem[228]=0;
	mem[229]=0;
	mem[230]=0;
	mem[231]=46;
	mem[232]=0;
	mem[233]=0;
	mem[234]=0;
	mem[235]=0;
	mem[236]=0;
	mem[237]=0;
	mem[238]=0;
	mem[239]=47;
	mem[240]=48;
	mem[241]=49;
	mem[242]=0;
	mem[243]=50;
	mem[244]=0;
	mem[245]=0;
	mem[246]=0;
	mem[247]=51;
	mem[248]=52;
	mem[249]=53;
	mem[250]=0;
	mem[251]=54;
	mem[252]=55;
	mem[253]=56;
	mem[254]=57;
	mem[255]=58;

end


always@(posedge clock)begin

	dataOut <= mem[dataIn];

end

endmodule

