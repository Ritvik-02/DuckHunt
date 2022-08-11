module  grass_rom
(
		input [18:0] read_address,
		input Clk,
		output logic [3:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [307200];

initial
begin
	 $readmemh("sprite_files/grass2.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[(read_address)];
end

endmodule
