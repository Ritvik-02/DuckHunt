module  starting( input 		  blank, pixel_clk, frame_clk, Reset, endgame,
						input	 [9:0]  mouseX, mouseY, DrawX, DrawY,
						input  [7:0]  mouseButton, click_count,
						input			[3:0] title_R, title_G, title_B, start_R, start_G, start_B,
                  output [3:0]  Red, Green, Blue, 
						output 		  start);
			
parameter [9:0] Ball_X_Center=320 - 75;  // Center position on the X axis
parameter [9:0] Ball_Y_Center= 350- 30;  // Center position on the Y axis
parameter [9:0] X_Size= 150;  // Center position on the X axis
parameter [9:0] Y_Size= 60; // Center position on the Y axis
parameter [9:0] Logo_X_Center=320 - 200;  // Center position on the X axis
parameter [9:0] Logo_Y_Center= 150- 100 ;  // Center position on the Y axis
parameter [9:0] Logo_X_Size= 400;  // Center position on the X axis
parameter [9:0] Logo_Y_Size= 200; // Center position on the Y axis

logic box, ball_on, logo;
int DistX_ball, DistY_ball;
assign DistX_ball = DrawX - mouseX;
assign DistY_ball = DrawY - mouseY;

always_comb begin // drawing box
	  box = 1'b0;
	  if(DrawY >= Ball_Y_Center && DrawY <= (Ball_Y_Center + Y_Size)) begin
			if(DrawX >= Ball_X_Center && DrawX <= (Ball_X_Center + X_Size)) begin
				box = 1'b1;
			end
	  end
end

always_comb begin // drawing logo
	  logo = 1'b0;
	  if(DrawY >= Logo_Y_Center && DrawY <= (Logo_Y_Center + Logo_Y_Size)) begin
			if(DrawX >= Logo_X_Center && DrawX <= (Logo_X_Center + Logo_X_Size)) begin
				logo = 1'b1;
			end
	  end
end

always_comb //drawing cursor
    begin:Ball_on_proc
        if ( ( DistX_ball*DistX_ball + DistY_ball*DistY_ball) <= (30 * 30) ) begin
				if((DistX_ball*DistX_ball + DistY_ball*DistY_ball) >= ((30 * 30) - 2)) begin
					ball_on = 1'b1;
				end
				else if(DrawX == mouseX || DrawY == mouseY) begin
						ball_on = 1'b1;
				end
				else begin
				   ball_on = 1'b0;
				end
		  end
        else 
            ball_on = 1'b0;
	 end


always_ff @ (posedge pixel_clk) begin
	if(blank == 0) begin
			Red = 4'h0; 
			Green = 4'h0;
			Blue = 4'h0;
		end else begin
		
	if(ball_on) begin
		Red = 4'hf;
		Green = 4'hf;
		Blue = 4'hf;
	end
	
	else if(logo && ((title_R != 4'h0) || (title_G != 4'hf) || (title_B != 4'hb))) begin
		Red = title_R;
		Green = title_G;
		Blue = title_B;
//		Red = 0;
//		Green = 4'hf;
//		Blue = 0;
	end

	else if(box && ((start_R != 4'h0) || (start_G != 4'hf) || (start_B != 4'hb))) begin
		Red = start_R;
		Green = start_G;
		Blue = start_B;
//		Red = 0;
//		Green = 0;
//		Blue = 4'hf;
	end
	else begin
				Red = 4'h6; 
            Green = 4'ha;
            Blue = 4'hf;
	end
	end
end

logic click_flag;

always_ff @ (posedge frame_clk or posedge Reset) begin //clicking logic

	if(Reset) begin
		start <= 1'b0;
	end
	 
	else if(mouseButton[0] == 1'b1 && !click_flag) begin
		click_flag <= 1;
		if(mouseY >= Ball_Y_Center && mouseY <= (Ball_Y_Center + Y_Size)) begin
			if(mouseX >= Ball_X_Center && mouseX <= (Ball_X_Center + X_Size)) begin
				start <= 1'b1;
			end
		end
	end
	
	else if (mouseButton[0] == 0 && click_flag) begin
		click_flag <= 0;
	end else if (endgame) begin
		start <= 1'b0;
	end
end


	
						
endmodule 