/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  duck_rom
(
		input [12:0] read_address,
		input Clk, slow_clk,
		output logic [3:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [8192];

initial
begin
	 $readmemh("sprite_files/duck1.txt", mem, 0, 4095);
	 $readmemh("sprite_files/duck2.txt", mem, 4096, 8191);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[(read_address + (4096 * slow_clk))];
end

endmodule
