/*

	Module: finalProject.sv
	Authors: Shubham & Devul

*/

module finalProject (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig, boxxsig, boxysig, boxsizesig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;
	logic [7:0] mousebutton;
	logic [31:0] mousex;
	logic [31:0] mousey;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//logic [3:0] randval;
	logic [9:0] Xmotion, Ymotion;
	
	//HEX drivers to convert numbers to HEX output
//	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
//	assign HEX4[7] = 1'b1;
//	
//	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
//	assign HEX3[7] = 1'b1;
//	
//	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
//	assign HEX1[7] = 1'b1;
//	
//	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
//	assign HEX0[7] = 1'b1;

	HexDriver hex_driver4 (score[7:4], HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (score[3:0], HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (bullets_left[7:4], HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (bullets_left[3:0], HEX0[6:0]);
	assign HEX0[7] = 1'b1;


logic [39:0] count;
logic [15:0] test_hex;
logic [7:0] click_count;
logic [7:0] bullets_left;
logic [7:0] hit_count, score;
logic kill;
logic start, endgame;
logic [3:0] red1, green1, blue1, red2, green2, blue2;

assign bullets_left = 16 - click_count;

always_comb begin
	if(bullets_left == 0) begin
		endgame = 1'b1;
	end
	else begin
		endgame = 1'b0;
	end
end

always_ff @ (posedge Reset_h or negedge start) begin
	if(Reset_h) begin
		score = 0;
	end
	else begin
		score = hit_count;
	end
end


//spire background variables
logic [4:0] color_idx_background;
logic [3:0] background_R;
logic [3:0] background_G;
logic [3:0] background_B;

logic [2:0] duck_idx;
logic [3:0] duck_R;
logic [3:0] duck_G;
logic [3:0] duck_B;

logic [2:0] title_idx;
logic [3:0] title_R;
logic [3:0] title_G;
logic [3:0] title_B;

logic [2:0] start_idx;
logic [3:0] start_R;
logic [3:0] start_G;
logic [3:0] start_B;

logic [2:0] grass_idx;
logic [3:0] grass_R;
logic [3:0] grass_G;
logic [3:0] grass_B;


always_ff @ (posedge MAX10_CLK1_50) begin
	if(count <= 10'h3ff) begin
		test_hex <= test_hex + 0;
		count <= count + 1;
	end
	else begin
		test_hex <= test_hex + 1;
		count <= 0;
	end
end
	
	

	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign Reset_h =~ (KEY[0]);

	//Our A/D converter is only 12 bit
	
	logic start1;
	assign start1 = 1'b1;
	
	always_comb begin
		if(start) begin
		VGA_R = red1;//[7:4];
		VGA_B = blue1;//[7:4];
		VGA_G = green1;//[7:4];
		end
		else begin
		VGA_R = red2;//[7:4];
		VGA_B = blue2;//[7:4];
		VGA_G = green2;//[7:4];
		end
	end
//	assign VGA_R = Red;//[7:4];
//	assign VGA_B = Blue;//[7:4];
//	assign VGA_G = Green;//[7:4];
	
	
	final_project_soc u0(
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		.mousebutton_export(mousebutton),
		.mousex_export(mousex),
		.mousey_export(mousey)
	 );


	vga_controller myVGA (.Clk(MAX10_CLK1_50),    
								 .Reset(Reset_h),     	 
								 .hs(VGA_HS),        	 
								 .vs(VGA_VS),        	 
								 .pixel_clk(VGA_Clk), 	 
								 .blank(blank),     		 
								 .sync(sync),     		 
								 .DrawX(drawxsig),     	 
								 .DrawY(drawysig)); 
					
	box myBox(.Reset(Reset_h), 
						 .frame_clk(VGA_VS),
						 .slow_clk(test_hex[14]),
						 .faster_clk(test_hex[11]),
						 .BoxX(boxxsig), 
						 .BoxY(boxysig), 
						 .mouseX(mousex),
						 .mouseY(mousey),
						 .BoxS(boxsizesig),
						 .randval(Xmotion),
						 .hit_count(hit_count),
						 .click_count(click_count),
						 .kill(kill));					

	
	cursor myCursor(.Reset(Reset_h), 
						 .frame_clk(VGA_VS),
						 .keycode(keycode),
						 .BallX(ballxsig), 
						 .BallY(ballysig), 
						 .BallS(ballsizesig),
						 .mouseX(mousex),
						 .mouseY(mousey),
						 .mouseButton(mousebutton));
	
	canvas myCanvas(.BallX(ballxsig), 
						 .BallY(ballysig),
						 .mouseButton(mousebutton), 
						 .DrawX(drawxsig), 
						 .DrawY(drawysig), 
						 .Ball_size(ballsizesig),
						 .Red(red1),//Red), 
						 .Green(green1),//Green),
						 .Blue(blue1),//Blue),
						 .blank(blank),
						 .frame_clk(VGA_VS),
						 .pixel_clk(VGA_Clk),
						 .slow_clk(test_hex[15]),
						 .Reset(Reset_h),
						 .BoxX(boxxsig), 
						 .background_R(background_R), 
						 .background_G(background_G), 
						 .background_B(background_B),
						 .click_count(click_count),
						 .start(start),
						 .hit_count(hit_count),
						 .duck_R(duck_R),
						 .duck_G(duck_G),
						 .duck_B(duck_B),
						 .grass_R(grass_R),
						 .grass_G(grass_G),
						 .grass_B(grass_B),
						 .BoxY(boxysig),
						 .Box_size(boxsizesig),
						 .kill(kill));
						 

	starting start_screen(.blank(blank), 
								 .pixel_clk(VGA_Clk),
								 .frame_clk(VGA_VS),
								 .Reset(Reset_h),
								 .endgame(endgame),
								 .mouseX(mousex), 
								 .mouseY(mousey), 
								 .DrawX(drawxsig), 
								 .DrawY(drawysig),
								 .mouseButton(mousebutton),
								 .click_count(click_count),
								 .title_R(title_R),
								 .title_G(title_G),
								 .title_B(title_B),
								 .start_R(start_R),
								 .start_G(start_G),
								 .start_B(start_B),
								 .Red(red2), 
								 .Green(green2), 
								 .Blue(blue2),
								 .start(start));
						 
//	background_rom background(
//			.read_address(drawxsig + drawysig*640),
//			.Clk(MAX10_CLK1_50),
//			.data_Out(color_idx_background)
//	);
//	
//	background_CP background_colors(.color_idx(color_idx_background),
//								.VGA_R(background_R), .VGA_G(background_G), .VGA_B(background_B));
		

	title_rom1 title(
			.read_address((drawxsig - 120) + (drawysig - 50)*400),
			.Clk(MAX10_CLK1_50),
			.data_Out(title_idx));
	
	title_CP title_color(.color_idx(title_idx),
								.VGA_R(title_R), .VGA_G(title_G), .VGA_B(title_B));
							
	start_rom startButton(
			.read_address((drawxsig - 245) + (drawysig - 320)*150),
			.Clk(MAX10_CLK1_50),
			.data_Out(start_idx));
	
	start_CP start_color(.color_idx(start_idx),
								.VGA_R(start_R), .VGA_G(start_G), .VGA_B(start_B));
							
	grass_rom grassrom(
			.read_address((drawxsig) + (drawysig)*640),
			.Clk(MAX10_CLK1_50),
			.data_Out(grass_idx));
	
	grass_CP grass_color(.color_idx(grass_idx),
								.VGA_R(grass_R), .VGA_G(grass_G), .VGA_B(grass_B));	
							
								
	duck_rom duck(
			.read_address((drawxsig - boxxsig) + (drawysig - boxysig)*64),
			.Clk(MAX10_CLK1_50), .slow_clk(test_hex[14]),
			.data_Out(duck_idx)
	);
	
	duck_CP duck_color(.color_idx(duck_idx),
								.VGA_R(duck_R), .VGA_G(duck_G), .VGA_B(duck_B));
endmodule
