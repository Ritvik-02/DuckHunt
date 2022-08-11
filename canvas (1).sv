/*
	Module: canvas.sv
	Authors: Shubham & Devul

*/


module  canvas       ( input        [9:0] BallX, BallY, DrawX, DrawY, Ball_size, BoxX, BoxY, Box_size,
							  input 			[7:0] mouseButton, background_G, background_B, background_R,
							  input			[3:0] duck_R, duck_G, duck_B, grass_R, grass_G, grass_B,
							  input 					blank, frame_clk, slow_clk, Reset, pixel_clk, start,
                       output logic [3:0]  Red, Green, Blue, 
								output logic [7:0] click_count, hit_count,
								output 				kill);
    
    logic ball_on, grass, box_on;
	 
	 logic d1, d2;
	 
	 longint count_cyc;
	 int count_sec;
	  
    int DistX_ball, DistY_ball, Size, DistX_box, DistY_box, DistX_curs, DistY_curs;
	 assign DistX_ball = DrawX - BallX;
    assign DistY_ball = DrawY - BallY;
	 assign DistX_box = DrawX - BoxX;
    assign DistY_box = DrawY - BoxY;
	 assign DistX_curs = BallX - BoxX;
    assign DistY_curs = BallY - BoxY;
    assign Size = Ball_size;
	 
	 
	 always_ff @ (posedge frame_clk) begin
		d1 <= mouseButton[0];
		d2 <= mouseButton[0];
	 end
	 
	 logic click_flag;
//	 logic reset_flag;
//	 
//	 
//	 always_ff @ (posedge start) begin
//		reset_flag;
//	 end
	 
	 
	 always_ff @ (posedge frame_clk or posedge Reset) begin // or negedge mouseButton[0] ) begin //clicking logic
	 
		if(Reset) begin
		click_count <= 0;
		hit_count <= 0;
		click_flag <= 0;
		end 
		
		else if(start == 1'b0) begin
			click_count <= 0;
			hit_count <= 0;
			click_flag <= 0;
		end
		
		else begin //posedge
			if(mouseButton[0] == 1'b1 && !click_flag && start) begin
				click_count <= (click_count + 1);
				click_flag <= 1;
				if ( DistX_curs <= Box_size ) begin
					if(DistY_curs <= Box_size) begin
						hit_count <= (hit_count + 1);
						kill <= 1'b1;
					end
				end
			end else if (mouseButton[0] == 0 && click_flag) begin
				kill <= 1'b0;
				click_flag <= 0;
			end
		end
	 end


	 always_comb //drawing ball
    begin:Ball_on_proc
        if ( ( DistX_ball*DistX_ball + DistY_ball*DistY_ball) <= (Size * Size) ) begin
				if((DistX_ball*DistX_ball + DistY_ball*DistY_ball) >= ((Size * Size) - 2)) begin
					ball_on = 1'b1;
				end
				else if(DrawX == BallX || DrawY == BallY) begin
						ball_on = 1'b1;
				end
				else begin
				   ball_on = 1'b0;
				end
		  end
        else 
            ball_on = 1'b0;
	 end
	 
	 always_comb //drawing box
    begin:Box_on_proc
		  box_on = 1'b0;
        if ( DistX_box <= Box_size ) begin
				if(DistY_box <= Box_size) begin
					box_on = 1'b1;
				end
		  end
	 end
	 
	 always_comb begin //drawing grass
		  if(((grass_R != 4'h0) || (grass_G != 4'hf) || (grass_B != 4'hb)))
				grass = 1'b1;
		  else
				grass = 1'b0;		
	end
       
		 
		 
    always_ff @ (posedge pixel_clk) begin
	 
		if(blank == 0) begin
			Red = 4'h0; 
			Green = 4'h0;
			Blue = 4'h0;
		end else begin
		  if ((ball_on == 1'b1)) 
        begin 
				if(mouseButton == 1) begin
					Red = 4'hf;
					Green = 4'h2;
					Blue = 4'h2;
				end
				else begin
					Red = 4'h0;
					Green = 8'h0;
					Blue = 8'h0;
				end
        end  
		  else if (grass == 1'b1 && ((grass_R != 4'h0) || (grass_G != 4'hf) || (grass_B != 4'hb))) begin
				Red = grass_R;
            Green = grass_G;
            Blue = grass_B;
		  end
		  else if (box_on == 1'b1 && ((duck_R != 4'h0) || (duck_G != 4'hf) || (duck_B != 4'hb))) begin
				Red = duck_R;
            Green = duck_G;
            Blue = duck_B;
		  end
		  else 
        begin 
            Red = 4'h6; 
            Green = 4'ha;
            Blue = 4'hf; //- DrawX[9:3];
//				Red = background_R; 
//            Green = background_G;
//            Blue = background_B;
        end     
		end
		
		
	end	
    
endmodule
