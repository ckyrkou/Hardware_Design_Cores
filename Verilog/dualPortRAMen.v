//
// Dual-Port RAM with One Enable Controlling Both Ports
//

module dualPortRAMen(clk, en, we, addra, addrb, di, doa, dob);
	
	parameter blockLength = 32;
	parameter memDepth = 1024;
	parameter addressBitWidth = 10;
	parameter file = "meminit.data";
	
    input  clk;
    input  en;
    input  we;
    input  [addressBitWidth-1:0] addra;
    input  [addressBitWidth-1:0] addrb;
    input  [15:0] di;
    output [15:0] doa;
    output [15:0] dob;
    reg    [15:0] ram [63:0];
    reg    [5:0] read_addra;
    reg    [5:0] read_addrb;

    always @(posedge clk) begin
        if (en)
        begin
            if (we)
                ram[addra] <= di;
            read_addra <= addra;
            read_addrb <= addrb;
        end
    end

    assign doa = ram[read_addra];
    assign dob = ram[read_addrb];

endmodule
