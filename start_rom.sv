module  start_rom
(
		input [13:0] read_address,
		input Clk,
		output logic [3:0] data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [9000];

initial
begin
	 $readmemh("sprite_files/start.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[(read_address)];
end

endmodule