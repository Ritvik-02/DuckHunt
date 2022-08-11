/*

	Module: cursor.sv
	Authors: Shubham & Devul

*/


module cursor( input Reset, frame_clk,
					input [7:0] keycode,
					input [31:0] mouseX,
					input [31:0] mouseY,
					input [7:0] mouseButton,
               output [9:0]  BallX, BallY, BallS );
					
	 parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=10;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=629;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=10;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=399;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
    
    logic [9:0] Ball_Size;
	 logic [9:0] X, Y;

    //assign Ball_Size = 15;
	 
	 always_ff @ (posedge Reset or posedge frame_clk ) begin
	 
	 if(Reset) begin
		X <= Ball_X_Center;
		Y <= Ball_Y_Center;
	 end
	 
	 else begin
	 
	 X <= mouseX;
	 Y <= mouseY;
    BallS <= Ball_Size;
	 
	 if(mouseButton == 1)begin
			Ball_Size = 20;
	 end
	 else begin
			Ball_Size = 15;
	  end
	 
	 if ( Y <= Ball_Y_Min ) begin  // Ball is at the bottom edge, BOUNCE!
		  BallY <= Ball_Y_Min;  // 2's complement.
		  BallX <= X;
	 end
	 else if ( Y >= Ball_Y_Max ) begin  // Ball is at the top edge, BOUNCE!
		  BallY <= Ball_Y_Max;
		  BallX <= X;
		end  
	  else if ( X >= Ball_X_Max ) begin  // Ball is at the Right edge, BOUNCE!
		  BallX <= Ball_X_Max;  // 2's complement.
		  BallY <= Y;
		end  
	 else if ( X <= Ball_X_Min ) begin  // Ball is at the Left edge, BOUNCE!
		  BallX <= Ball_X_Min;
		  BallY <= Y;
		end  
	 else begin
		  BallX <= X;  // Ball is somewhere in the middle, don't bounce, just keep moving
		  BallY <= Y;
	 end
	 end
	 end
    

endmodule
