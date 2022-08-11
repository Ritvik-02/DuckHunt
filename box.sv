//module  ball ( input Reset, frame_clk,
//					input [7:0] keycode,
//               output [9:0]  BallX, BallY, BallS );
					
module box( input Reset, frame_clk, slow_clk, faster_clk,
					input [31:0] mouseX,
					input [31:0] mouseY,
					input kill,
             output [9:0]  BoxX, BoxY, BoxS,
				 input [7:0] hit_count, click_count,
				 output [9:0]  randval );
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size, Ball_X_speed, Ball_Y_speed;
	 logic [9:0] XStep, YStep;
	 //logic [3:0] randval;
	 logic [6:0] slow_count;
	 
    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
//    parameter [9:0] Ball_X_Min=3;       // Leftmost point on the X axis
//    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
//    parameter [9:0] Ball_Y_Min=3;       // Topmost point on the Y axis
//    parameter [9:0] Ball_Y_Max=399;     // Bottommost point on the Y axis
//    parameter [9:0] Ball_X_Step=3;      // Step size on the X axis
//    parameter [9:0] Ball_Y_Step=3;      // Step size on the Y axis

    assign Ball_Size = 64;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 
	 logic [9:0] Ball_X_Min;       // Leftmost point on the X axis
    logic [9:0] Ball_X_Max;     // Rightmost point on the X axis
    logic [9:0] Ball_Y_Min;       // Topmost point on the Y axis
    logic [9:0] Ball_Y_Max;     // Bottommost point on the Y 
	 
	 logic [9:0] Ball_X_Step;
    logic [9:0] Ball_Y_Step;
	 
	 assign Ball_Y_Step = 3 + hit_count;
	 assign Ball_X_Step = 3 + hit_count;
	 
	 logic [3:0] rand_counter;
	 
	 assign Ball_X_Min=3 + hit_count;       // Leftmost point on the X axis
    assign Ball_X_Max=639 - hit_count;     // Rightmost point on the X axis
    assign Ball_Y_Min=3 + hit_count;       // Topmost point on the Y axis
    assign Ball_Y_Max=399 - hit_count;     // Bottommost point on the Y axis
	 
	 logic [3:0] speed_counter;
	 
	 always_ff @ (posedge slow_clk) begin
				speed_counter <= speed_counter + 1;
//				if(speed_counter % (16 - hit_count) == 0) begin 
				rand_counter <= (rand_counter + 1);
				randval <= ((mouseX + mouseY + 23 + rand_counter) % 16);
//				end
		
		case (randval)
			//first quad
			4'b0000 : begin
				XStep <= -3 - hit_count ;
				YStep <= 1 + hit_count;	
				
			end
			4'b0001 : begin
				XStep <= 3 + hit_count;
				YStep <= 1 + hit_count;
				
			end
			4'b0010 : begin
				XStep <= 2 + hit_count;
				YStep <= 2 + hit_count;
			end
			4'b0011 : begin
				XStep <= 1 + hit_count;
				YStep <= 3 + hit_count;
			end
			
			//second quad
			4'b0100 : begin
				XStep <= -2 - hit_count;
				YStep <= 2 + hit_count;
			end
			4'b0101 : begin
				XStep <= -1 - hit_count;
				YStep <= 3 + hit_count;
			end
			4'b0110 : begin
				XStep <= 0;
				YStep <= 3 + hit_count;
			end
			4'b0111 : begin
				XStep <= 3 + hit_count;
				YStep <= 0;
			end

			//third quad
			4'b1000 : begin
				XStep <= -3 - hit_count;
				YStep <= 0;
			end
			4'b1001 : begin
				XStep <= -3 - hit_count;
				YStep <= -1 - hit_count;
			end
			4'b1010 : begin
				XStep <= -2 - hit_count;
				YStep <= -2 - hit_count;
			end
			4'b1011 : begin
				XStep <= -1 - hit_count;
				YStep <= -3 - hit_count;
			end
			
			//fourth quad
			4'b1100 : begin
				XStep <= 3 + hit_count;
				YStep <= -1 - hit_count;
			end
			4'b1101 : begin
				XStep <= 1 + hit_count;
				YStep <= -3 - hit_count;
			end
			4'b1110 : begin
				XStep <= 2 + hit_count;
				YStep <= -2 - hit_count;
			end
			4'b1111 : begin
				XStep <= 0;
				YStep <= -3 - hit_count;
	
			end
			default : begin
				XStep <= 0;
				YStep <= 0;
			end
		endcase
	
	end
	
//	always_comb begin
	
//		if(XStep > 0) begin
//			Ball_X_speed =  hit_count;
//		end
//		else if(XStep < 0) begin
//			Ball_X_speed = ~(hit_count) + 1;
//		end
//		else begin
//			Ball_X_speed = 0;
//		end
//		
//		if(YStep > 0) begin
//			Ball_Y_speed = hit_count;
//		end
//		else if(YStep < 0) begin
//			Ball_Y_speed = ~(hit_count) + 1;
//		end
//		else begin
//			Ball_Y_speed = 0;
//		end
//				
//	end
   
    always_ff @ (posedge frame_clk or posedge Reset)
    begin: Move_Ball
	
	     if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= YStep;
				Ball_X_Motion <= XStep;
				Ball_Y_Pos <= (Ball_Y_Min + 50);
				Ball_X_Pos <= Ball_X_Center;
        end
			
        else if (kill)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= YStep ;
				Ball_X_Motion <= XStep ;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
           
        else 
        begin 
		  
				if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max ) begin  // Ball is at the bottom edge, BOUNCE!
					Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement
					if( (Ball_X_Pos + Ball_Size) >= Ball_X_Max ) begin
						Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
					end
					else if((Ball_X_Pos) <= Ball_X_Min) begin
						Ball_X_Motion <= Ball_X_Step;
					end
					else begin
						Ball_X_Motion <= Ball_X_Motion;
					end
				end
				else if ( (Ball_Y_Pos) <= Ball_Y_Min ) begin  // Ball is at the top edge, BOUNCE!
					Ball_Y_Motion <= Ball_Y_Step;  // 2's complement
					if( (Ball_X_Pos + Ball_Size) >= Ball_X_Max ) begin
						Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
					end
					else if((Ball_X_Pos) <= Ball_X_Min) begin
						Ball_X_Motion <= Ball_X_Step;
					end
					else begin
						Ball_X_Motion <= Ball_X_Motion;
					end
				end
				else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max ) begin  // Ball is at the Right edge, BOUNCE!
					Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
					if( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max ) begin
						Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);
					end
					else if((Ball_Y_Pos) <= Ball_Y_Min) begin
						Ball_Y_Motion <= Ball_Y_Step;
					end
					else begin 
						Ball_Y_Motion <= Ball_Y_Motion;
					end
				end
				else if ( (Ball_X_Pos) <= Ball_X_Min ) begin  // Ball is at the Left edge, BOUNCE!
					Ball_X_Motion <= Ball_X_Step;
					if( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max ) begin
						Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);
					end
					else if((Ball_Y_Pos) <= Ball_Y_Min) begin
						Ball_Y_Motion <= Ball_Y_Step;
					end
					else begin 
						Ball_Y_Motion <= Ball_Y_Motion;
					end
				end
				else if((BoxX >= (Ball_X_Min + 30)) && (BoxX <= (Ball_X_Max - 94))) begin
					if((BoxY >= (Ball_Y_Min + 30)) && (BoxY <= (Ball_Y_Max - 94))) begin
						Ball_Y_Motion <= (YStep);
						Ball_X_Motion <= (XStep);
					end
					else begin
						Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
						Ball_X_Motion <= Ball_X_Motion;
					end
				end
				else begin
					Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					Ball_X_Motion <= Ball_X_Motion;
				end
				 
				 Ball_Y_Pos <= (Ball_Y_Pos + ( Ball_Y_Motion));  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + ( Ball_X_Motion));
			
		end  
    end
       
    assign BoxX = Ball_X_Pos;
   
    assign BoxY = Ball_Y_Pos;
   
    assign BoxS = Ball_Size;
    

endmodule

