module background_CP (	input [2:0] color_idx,
								output [3:0] VGA_R, VGA_G, VGA_B);
								

always_comb begin
	
	case(color_idx)
	
		4'b0000: begin
				VGA_R = 4'hF;
				VGA_G = 4'h0;
				VGA_B = 4'h0;
		end
		
		4'b0001: begin
				VGA_R = 4'h0;
				VGA_G = 4'h0;
				VGA_B = 4'h0;
		end

		4'b0010: begin
				VGA_R = 4'h0;
				VGA_G = 4'h0;
				VGA_B = 4'hF;
		end

		4'b0011: begin
				VGA_R = 4'h5;
				VGA_G = 4'h2;
				VGA_B = 4'h0;
		end
		
		4'b0100: begin
				VGA_R = 4'h6;
				VGA_G = 4'h6;
				VGA_B = 4'h0;
		end
		
		4'b0101: begin
				VGA_R = 4'h8;
				VGA_G = 4'hD;
				VGA_B = 4'h0;
		end

		4'b0110: begin
				VGA_R = 4'h0;
				VGA_G = 4'h5;
				VGA_B = 4'h0;
		end
		
		4'b0111: begin
				VGA_R = 4'h6;
				VGA_G = 4'hA;
				VGA_B = 4'hF;
		end
		
		default: begin
				VGA_R = 4'hD;
				VGA_G = 4'h0;
				VGA_B = 4'h0;
		end
	endcase
	
end

endmodule


		