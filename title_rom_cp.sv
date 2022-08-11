module title_CP (	input [3:0] color_idx,
								output [3:0] VGA_R, VGA_G, VGA_B);
								

always_comb begin
	
	case(color_idx)
	
		4'b0000: begin
				VGA_R = 4'h0;
				VGA_G = 4'hF;
				VGA_B = 4'hB;
		end
		
		4'b0001: begin
				VGA_R = 4'h0;
				VGA_G = 4'h0;
				VGA_B = 4'h0;
		end

		4'b0010: begin
				VGA_R = 4'hF;
				VGA_G = 4'hA;
				VGA_B = 4'h4;
		end

		4'b0011: begin
				VGA_R = 4'h0;
				VGA_G = 4'hF;
				VGA_B = 4'hB;
		end
		
		default: begin
				VGA_R = 4'h0;
				VGA_G = 4'h0;
				VGA_B = 4'h0;
		end
		
	endcase
	
end

endmodule


		