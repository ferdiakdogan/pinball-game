module pinball_v2(
		input wire rst,
		input wire clock,
		input wire button_right,
		input wire button_left,
		input wire button_start,
		output wire VGA_HS_O,       
		output wire VGA_VS_O,       
		output wire [7:0] VGA_R,     
		output wire [7:0] VGA_G,     
		output wire [7:0] VGA_B,		
		output reg vga_clk
		);
	
   // generate a 25 MHz vga clock and a 1 second clock for timer
   reg [99:0] counter;
	reg second_clock;
	 
	
	initial begin
			vga_clk = 0;
			second_clock = 0;
			score = 0;
			timer = 0;
	end
		 
	always @(posedge clock) begin   
			vga_clk <= ~vga_clk;
	end
	

	
			
    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-51
	 wire play ; 	 // high during active pixel drawing

    vga_sync ( 
			.input_reset(rst),
			.inputclock(clock),
         .pixel(vga_clk),
         .output_hsync(VGA_HS_O), 
         .output_vsync(VGA_VS_O), 
         .output_x(x),
		   .output_y(y),
			.output_play(play)
    );
wire [7:0] top_wall, left_wall, right_wall, bottom_right_wall, bottom_left_wall, game_ball, circle_1, circle_2, circle_3, circle_4, hexagon_1, hexagon_2;
reg [9:0] ball_center_x, ball_center_y, ball_radius;

wire [7:0] h1_1, h1_2, h1_3, h1_4, h1_5, h1_6, h1_7, h1_8, h1_9, h1_10, h1_11, h1_12, h1_13, h1_14, h1_15, h1_16, h1_17, h1_18, h1_19, h1_20;
wire [7:0] h2_1, h2_2, h2_3, h2_4, h2_5, h2_6, h2_7, h2_8, h2_9, h2_10, h2_11, h2_12, h2_13, h2_14, h2_15, h2_16, h2_17, h2_18, h2_19, h2_20;

reg [9:0] circle_1_x, circle_1_y, circle_radius, circle_2_x, circle_2_y, circle_3_x, circle_3_y, circle_4_x, circle_4_y;
reg [9:0] velocity_x, velocity_y, direction_x, direction_y;
reg [7:0] slope_flipper_right, slope_flipper_left;
reg [9:0] score;
reg [9:0] timer;
wire [7:0] flipper_left, flipper_right;

reg score1_0, score1_1, score1_2, score1_3, score1_4, score1_5, score1_6, score1_7, score1_8, score1_9;
reg score2_0, score2_1, score2_2, score2_3, score2_4, score2_5, score2_6, score2_7, score2_8, score2_9;
reg score3_0, score3_1, score3_2, score3_3, score3_4, score3_5, score3_6, score3_7, score3_8, score3_9;
reg [7:0] score1, score2, score3;

reg time1_0, time1_1, time1_2, time1_3, time1_4, time1_5, time1_6, time1_7, time1_8, time1_9;
reg time2_0, time2_1, time2_2, time2_3, time2_4, time2_5, time2_6, time2_7, time2_8, time2_9;
reg time3_0, time3_1, time3_2, time3_3, time3_4, time3_5, time3_6, time3_7, time3_8, time3_9;
reg [7:0] time1, time2, time3;

wire [7:0] green1_top, green1_bottom, green1_left, green1_right, green1_topleft, green1_topright, green1_bottomleft, green1_bottomright;
wire [7:0] green2_top, green2_bottom, green2_left, green2_right, green2_topleft, green2_topright, green2_bottomleft, green2_bottomright;
wire [7:0] red1_top, red1_bottom, red1_left, red1_right, red1_topleft, red1_topright, red1_bottomleft, red1_bottomright;
wire [7:0] red2_top, red2_bottom, red2_left, red2_right, red2_topleft, red2_topright, red2_bottomleft, red2_bottomright;
wire [7:0] s_1, s_2, s_3, s_4, s_5, c_1, c_2, c_3, o_1, o_2, o_3, o_4, r_1, r_2, r_3, r_4, e_1, e_2, e_3, e_4;
wire [7:0] t_1, t_2, i_1, m_1, m_2, m_3, m_4, e2_1, e2_2, e2_3, e2_4;
wire [7:0] s1_1, s1_2, s1_3, s1_4, s1_5, s1_6, s1_7, s2_1, s2_2, s2_3, s2_4, s2_5, s2_6, s2_7, s3_1, s3_2, s3_3, s3_4, s3_5, s3_6, s3_7;
wire [7:0] t1_1, t1_2, t1_3, t1_4, t1_5, t1_6, t1_7, t2_1, t2_2, t2_3, t2_4, t2_5, t2_6, t2_7, t3_1, t3_2, t3_3, t3_4, t3_5, t3_6, t3_7;

reg enable_collision;


initial begin 
	
	enable_collision = 1;
	ball_center_x = 370;
	ball_center_y = 370;
	ball_radius = 10;
	circle_1_x = 160;
	circle_1_y = 120;
	circle_radius = 20;
	circle_2_x = 220;
	circle_2_y = 220;
	circle_3_x = 280; 
	circle_3_y = 80;
	circle_4_x = 360;
	circle_4_y = 200;
	velocity_x = 3;
	velocity_y = 2;
	direction_x = 0;
	direction_y = 0;
	slope_flipper_right = 100;
	slope_flipper_left = 100;
	
	

end
	
//boundaries	
assign top_wall = (x >= 80 & x <= 440 & y <= 42 & y >= 38) ? 8'hFF : 0;
assign left_wall = (y >= 40 & y <= 320 & x <= 82 & x >= 78) ? 8'hFF : 0;
assign right_wall = (y >= 40 & y <= 320 & x <= 442 & x >= 438) ? 8'hFF : 0;
assign bottom_right_wall = (x >= 340 & x <= 440 & y <= 420 & y >= 320 & x + y >= 758 & x + y <= 762) ? 8'hFF : 0;
assign bottom_left_wall = (x >= 80 & x <= 180 & y <= 420 & y >= 320 & y >= x + 238 & y <= x + 242) ? 8'hFF : 0;

//objects
assign circle_1 = ((x - circle_1_x) ** 2 + (y - circle_1_y) ** 2 < (circle_radius + 1) ** 2 &
(x - circle_1_x) ** 2 + (y - circle_1_y) ** 2 >= 0) ? 8'hFF : 0;

assign circle_2 = ((x - circle_2_x) ** 2 + (y - circle_2_y) ** 2 < (circle_radius + 1) ** 2 &
(x - circle_2_x) ** 2 + (y - circle_2_y) ** 2 >= 0) ? 8'hFF : 0;

assign circle_3 = ((x - circle_3_x) ** 2 + (y - circle_3_y) ** 2 < (circle_radius + 1) ** 2 &
(x - circle_2_x) ** 2 + (y - circle_2_y) ** 2 >= 0) ? 8'hFF : 0;

assign circle_4 = ((x - circle_4_x) ** 2 + (y - circle_4_y) ** 2 < (circle_radius + 1) ** 2 &
(x - circle_2_x) ** 2 + (y - circle_2_y) ** 2 >= 0) ? 8'hFF : 0;

assign game_ball = ((x - ball_center_x) ** 2 + (y - ball_center_y) ** 2 < (ball_radius + 1) ** 2 &
(x - ball_center_x) ** 2 + (y - ball_center_y) ** 2 >= 0) ? 8'hFF : 0;

//flippers
assign flipper_right = (((x-340)*(x-340)+(y-420)*(y-420) >= 0) &  ((x-340)*(x-340)+(y-420)*(y-420) < (6401))&
(100*(y-420)+slope_flipper_right*(x-340) + 500>400)&(100*(y-420)+slope_flipper_right*(x-340)+500<600)&(x<=340))? 8'hFF : 0;

assign flipper_left = (((x-180)*(x-180)+(y-420)*(y-420) >= 0) &  ((x-180)*(x-180)+(y-420)*(y-420) < (6401))&
(100*(y-420) +500 > slope_flipper_left*(x-180) +400)&(100*(y-420) + 500<slope_flipper_left*(x-180)+600)&(x>=180))? 8'hFF : 0;

//circle object collisions

assign green1_top = ( ball_center_x >= 150 & ball_center_x <= 170 & ball_center_y <= 95 & ball_center_y >= 85 ) ? 1 : 0;
assign green1_bottom = ( ball_center_x >= 150 & ball_center_x <= 170 & ball_center_y <= 155 & ball_center_y >= 145 ) ? 1 : 0;
assign green1_left = ( ball_center_x >= 125 & ball_center_x <= 135 & ball_center_y <= 130 & ball_center_y >= 110 ) ? 1 : 0;
assign green1_right = ( ball_center_x >= 185 & ball_center_x <= 195 & ball_center_y <= 130 & ball_center_y >= 110 ) ? 1 : 0;
assign green1_topleft = ( ball_center_x >= 130 & ball_center_x <= 150 & ball_center_y + ball_center_x <= 245 & ball_center_y + ball_center_x >= 235  ) ? 1 : 0;
assign green1_topright = ( ball_center_x >= 170 & ball_center_x <= 190 & ball_center_x <= ball_center_y + 85 & ball_center_x >= ball_center_y + 75) ? 1 : 0;
assign green1_bottomleft = ( ball_center_x >= 130 & ball_center_x <= 150 & ball_center_x <= ball_center_y + 5 & ball_center_x + 5 >= ball_center_y ) ? 1 : 0;
assign green1_bottomright = ( ball_center_x >= 170 & ball_center_x <= 190 & ball_center_y + ball_center_x <= 325 & ball_center_y + ball_center_x >= 315 ) ? 1 : 0;
assign green2_top = ( ball_center_x >= 350 & ball_center_x <= 370 & ball_center_y <= 175 & ball_center_y >= 165 ) ? 1 : 0;
assign green2_bottom = (ball_center_x >= 350 & ball_center_x <= 370 & ball_center_y <= 235 & ball_center_y >= 225 ) ? 1 : 0;
assign green2_left = ( ball_center_x >= 325 & ball_center_x <= 335 & ball_center_y <= 210 & ball_center_y >= 190 ) ? 1 : 0;
assign green2_right = (ball_center_x >= 385 & ball_center_x <= 395 & ball_center_y <= 210 & ball_center_y >= 190 ) ? 1 : 0;
assign green2_topleft = (ball_center_x >= 330 & ball_center_x <= 350 & ball_center_y + ball_center_x <= 525 & ball_center_y + ball_center_x >= 515  ) ? 1 : 0;
assign green2_topright = (ball_center_x >= 370 & ball_center_x <= 390 &  ball_center_x <= ball_center_y +205 & ball_center_x >= ball_center_y + 195 ) ? 1 : 0;
assign green2_bottomleft = (ball_center_x >= 330 & ball_center_x <= 350 & ball_center_x <= ball_center_y + 125 & ball_center_x >= ball_center_y + 115) ? 1: 0;
assign green2_bottomright = (ball_center_x >= 370 & ball_center_x <= 390 & ball_center_y + ball_center_x <= 605 & ball_center_y + ball_center_x >= 595 ) ? 1 : 0;
assign red1_top = ( ball_center_x >= 210 & ball_center_x <= 230 & ball_center_y <= 195 & ball_center_y >= 185 ) ? 1 : 0;
assign red1_bottom = (ball_center_x >= 210 & ball_center_x <= 230 & ball_center_y <= 255 & ball_center_y >= 245 ) ? 1 : 0;
assign red1_left =  ( ball_center_x >= 185 & ball_center_x <= 195 & ball_center_y <= 230 & ball_center_y >= 210 ) ? 1 : 0;
assign red1_right = (ball_center_x >= 245 & ball_center_x <= 255 & ball_center_y <= 230 & ball_center_y >= 210 ) ? 1 : 0;
assign red1_topleft =  (ball_center_x >= 190 & ball_center_x <= 210 & ball_center_y + ball_center_x <= 405 & ball_center_y + ball_center_x >= 395  ) ? 1 : 0;
assign red1_topright =  (ball_center_x >= 230 & ball_center_x <= 250 &  ball_center_x <= ball_center_y +45 & ball_center_x >= ball_center_y + 35 ) ? 1 : 0;
assign red1_bottomleft = (ball_center_x >= 190 & ball_center_x <= 210 & ball_center_y <= ball_center_x + 45 & ball_center_y >= ball_center_x + 35) ? 1: 0;
assign red1_bottomright = (ball_center_x >= 230 & ball_center_x <= 250 & ball_center_y + ball_center_x <= 485 & ball_center_y + ball_center_x >= 475 ) ? 1 : 0;
assign red2_top = ( ball_center_x >= 270 & ball_center_x <= 290 & ball_center_y <= 55 & ball_center_y >= 45 ) ? 1 : 0;
assign red2_bottom = (ball_center_x >= 270 & ball_center_x <= 290 & ball_center_y <= 115 & ball_center_y >= 105 ) ? 1 : 0;
assign red2_left =  ( ball_center_x >= 245 & ball_center_x <= 255 & ball_center_y <= 90 & ball_center_y >= 70 ) ? 1 : 0;
assign red2_right =  (ball_center_x >= 305 & ball_center_x <= 315 & ball_center_y <= 90 & ball_center_y >= 70 ) ? 1 : 0;
assign red2_topleft =  (ball_center_x >= 250 & ball_center_x <= 270 & ball_center_y + ball_center_x <= 325 & ball_center_y + ball_center_x >= 315  ) ? 1 : 0;
assign red2_topright =  (ball_center_x >= 290 & ball_center_x <= 310 &  ball_center_x <= ball_center_y +245 & ball_center_x >= ball_center_y + 235 ) ? 1 : 0;
assign red2_bottomleft = (ball_center_x >= 250 & ball_center_x <= 270 & ball_center_x <= ball_center_y + 165 & ball_center_x >= ball_center_y + 155) ? 1: 0;
assign red2_bottomright = (ball_center_x >= 290 & ball_center_x <= 310 & ball_center_y + ball_center_x <= 405 & ball_center_y + ball_center_x >= 395 ) ? 1 : 0;

//score_write
assign s_1 = (x <= 490 & x >= 480 & y <= 182 & y >= 178) ? 8'hFF : 0;
//assign c_1 = (x <= 510 & x >= 500 & y <= 182 & y >= 178) ? 8'hFF : 0;
assign s_2 = (x <= 482 & x >= 478 & y <= 190 & y >= 180) ? 8'hFF : 0;
assign s_3 = (x <= 490 & x >= 480 & y <= 192 & y >= 188) ? 8'hFF : 0;
assign s_4 = (x <= 492 & x >= 488 & y <= 200 & y >= 190) ? 8'hFF : 0;
assign s_5 = (x <= 490 & x >= 480 & y <= 202 & y >= 198) ? 8'hFF : 0;

//time_write
assign t_1 = (x <= 500 & x >= 480 & y <= 62 & y >= 58) ? 8'hFF : 0;
assign t_2 = (x <= 492 & x >= 488 & y <= 80 & y >= 60) ? 8'hFF : 0;

//score
assign s1_1 = (x <= 520 & x >= 500 & y <= 222 & y >= 218 & (score1_0 | score1_2 | score1_3 | score1_5 | score1_7 | score1_8 | score1_9 )) ? 8'hFF : 0;
assign s1_2 = (x <= 522 & x >= 518 & y <= 240 & y >= 220 & (score1_0 | score1_1 | score1_2 | score1_3 | score1_4 | score1_7 | score1_8 | score1_9 )) ? 8'hFF : 0;
assign s1_3 = (x <= 522 & x >= 518 & y <= 260 & y >= 240 & (score1_0 | score1_1 | score1_3 | score1_4 | score1_5 | score1_6 | score1_7 | score1_8 | score1_9 )) ? 8'hFF : 0;
assign s1_4 = (x <= 520 & x >= 500 & y <= 262 & y >= 258 & (score1_0 | score1_2 | score1_3 | score1_5 | score1_6 | score1_8  )) ? 8'hFF : 0;
assign s1_5 = (x <= 502 & x >= 498 & y <= 260 & y >= 240 & (score1_0 | score1_2 | score1_6 | score1_8  )) ? 8'hFF : 0;
assign s1_6 = (x <= 520 & x >= 500 & y <= 242 & y >= 238 & (score1_2 | score1_3 | score1_4 | score1_5 | score1_6 | score1_8 | score1_9 )) ? 8'hFF : 0;
assign s1_7 = (x <= 502 & x >= 498 & y <= 240 & y >= 220 & (score1_0 | score1_4 | score1_5 | score1_6 | score1_8 | score1_9 )) ? 8'hFF : 0;

assign s2_1 = (x <= 550 & x >= 530 & y <= 222 & y >= 218 & (score2_0 | score2_2 | score2_3 | score2_5 | score2_7 | score2_8 | score2_9 )) ? 8'hFF : 0;
assign s2_2 = (x <= 552 & x >= 548 & y <= 240 & y >= 220 & (score2_0 | score2_1 | score2_2 | score2_3 | score2_4 | score2_7 | score2_8 | score2_9 )) ? 8'hFF : 0;
assign s2_3 = (x <= 552 & x >= 548 & y <= 260 & y >= 240 & (score2_0 | score2_1 | score2_3 | score2_4 | score2_5 | score2_6 | score2_7 | score2_8 | score2_9 )) ? 8'hFF : 0;
assign s2_4 = (x <= 550 & x >= 530 & y <= 262 & y >= 258 & (score2_0 | score2_2 | score2_3 | score2_5 | score2_6 | score2_8  )) ? 8'hFF : 0;
assign s2_5 = (x <= 532 & x >= 528 & y <= 260 & y >= 240 & (score2_0 | score2_2 | score2_6 | score2_8  )) ? 8'hFF : 0;
assign s2_6 = (x <= 550 & x >= 530 & y <= 242 & y >= 238 & (score2_2 | score2_3 | score2_4 | score2_5 | score2_6 | score2_8 | score2_9 )) ? 8'hFF : 0;
assign s2_7 = (x <= 532 & x >= 528 & y <= 240 & y >= 220 & (score2_0 | score2_4 | score2_5 | score2_6 | score2_8 | score2_9 )) ? 8'hFF : 0;

assign s3_1 = (x <= 580 & x >= 560 & y <= 222 & y >= 218 & (score3_0 | score3_2 | score3_3 | score3_5 | score3_7 | score3_8 | score3_9 )) ? 8'hFF : 0;
assign s3_2 = (x <= 582 & x >= 578 & y <= 240 & y >= 220 & (score3_0 | score3_1 | score3_2 | score3_3 | score3_4 | score3_7 | score3_8 | score3_9 )) ? 8'hFF : 0;
assign s3_3 = (x <= 582 & x >= 578 & y <= 260 & y >= 240 & (score3_0 | score3_1 | score3_3 | score3_4 | score3_5 | score3_6 | score3_7 | score3_8 | score3_9 )) ? 8'hFF : 0;
assign s3_4 = (x <= 580 & x >= 560 & y <= 262 & y >= 258 & (score3_0 | score3_2 | score3_3 | score3_5 | score3_6 | score3_8  )) ? 8'hFF : 0;
assign s3_5 = (x <= 562 & x >= 558 & y <= 260 & y >= 240 & (score3_0 | score3_2 | score3_6 | score3_8  )) ? 8'hFF : 0;
assign s3_6 = (x <= 580 & x >= 560 & y <= 242 & y >= 238 & (score3_2 | score3_3 | score3_4 | score3_5 | score3_6 | score3_8 | score3_9 )) ? 8'hFF : 0;
assign s3_7 = (x <= 562 & x >= 558 & y <= 240 & y >= 220 & (score3_0 | score3_4 | score3_5 | score3_6 | score3_8 | score3_9 )) ? 8'hFF : 0;

//time
assign t1_1 = (x <= 520 & x >= 500 & y <= 102 & y >= 98 & (time1_0 | time1_2 | time1_3 | time1_5 | time1_7 | time1_8 | time1_9 )) ? 8'hFF : 0;
assign t1_2 = (x <= 522 & x >= 518 & y <= 120 & y >= 100 & (time1_0 | time1_1 | time1_2 | time1_3 | time1_4 | time1_7 | time1_8 | time1_9 )) ? 8'hFF : 0;
assign t1_3 = (x <= 522 & x >= 518 & y <= 140 & y >= 120 & (time1_0 | time1_1 | time1_3 | time1_4 | time1_5 | time1_6 | time1_7 | time1_8 | time1_9 )) ? 8'hFF : 0;
assign t1_4 = (x <= 520 & x >= 500 & y <= 142 & y >= 138 & (time1_0 | time1_2 | time1_3 | time1_5 | time1_6 | time1_8  )) ? 8'hFF : 0;
assign t1_5 = (x <= 502 & x >= 498 & y <= 140 & y >= 120 & (time1_0 | time1_2 | time1_6 | time1_8  )) ? 8'hFF : 0;
assign t1_6 = (x <= 520 & x >= 500 & y <= 122 & y >= 118 & (time1_2 | time1_3 | time1_4 | time1_5 | time1_6 | time1_8 | time1_9 )) ? 8'hFF : 0;
assign t1_7 = (x <= 502 & x >= 498 & y <= 120 & y >= 100 & (time1_0 | time1_4 | time1_5 | time1_6 | time1_8 | time1_9 )) ? 8'hFF : 0;

assign t2_1 = (x <= 550 & x >= 530 & y <= 102 & y >= 98 & (time2_0 | time2_2 | time2_3 | time2_5 | time2_7 | time2_8 | time2_9 )) ? 8'hFF : 0;
assign t2_2 = (x <= 552 & x >= 548 & y <= 120 & y >= 100 & (time2_0 | time2_1 | time2_2 | time2_3 | time2_4 | time2_7 | time2_8 | time2_9 )) ? 8'hFF : 0;
assign t2_3 = (x <= 552 & x >= 548 & y <= 140 & y >= 120 & (time2_0 | time2_1 | time2_3 | time2_4 | time2_5 | time2_6 | time2_7 | time2_8 | time2_9 )) ? 8'hFF : 0;
assign t2_4 = (x <= 550 & x >= 530 & y <= 142 & y >= 138 & (time2_0 | time2_2 | time2_3 | time2_5 | time2_6 | time2_8 )) ? 8'hFF : 0;
assign t2_5 = (x <= 532 & x >= 528 & y <= 140 & y >= 120 & (time2_0 | time2_2 | time2_6 | time2_8  )) ? 8'hFF : 0;
assign t2_6 = (x <= 550 & x >= 530 & y <= 122 & y >= 118 & (time2_2 | time2_3 | time2_4 | time2_5 | time2_6 | time2_8 | time2_9 )) ? 8'hFF : 0;
assign t2_7 = (x <= 532 & x >= 528 & y <= 120 & y >= 100 & (time2_0 | time2_4 | time2_5 | time2_6 | time2_8 | time2_9 )) ? 8'hFF : 0;

assign t3_1 = (x <= 580 & x >= 560 & y <= 102 & y >= 98 & (time3_0 | time3_2 | time3_3 | time3_5 | time3_7 | time3_8 | time3_9 )) ? 8'hFF : 0;
assign t3_2 = (x <= 582 & x >= 578 & y <= 120 & y >= 100 & (time3_0 | time3_1 | time3_2 | time3_3 | time3_4 | time3_7 | time3_8 | time3_9 )) ? 8'hFF : 0;
assign t3_3 = (x <= 582 & x >= 578 & y <= 140 & y >= 120 & (time3_0 | time3_1 | time3_3 | time3_4 | time3_5 | time3_6 | time3_7 | time3_8 | time3_9 )) ? 8'hFF : 0;
assign t3_4 = (x <= 580 & x >= 560 & y <= 142 & y >= 138 & (time3_0 | time3_2 | time3_3 | time3_5 | time3_6 | time3_8 )) ? 8'hFF : 0;
assign t3_5 = (x <= 562 & x >= 558 & y <= 140 & y >= 120 & (time3_0 | time3_2 | time3_6 | time3_8 )) ? 8'hFF : 0;
assign t3_6 = (x <= 580 & x >= 560 & y <= 122 & y >= 118 & (time3_2 | time3_3 | time3_4 | time3_5 | time3_6 | time3_8 | time3_9 )) ? 8'hFF : 0;
assign t3_7 = (x <= 562 & x >= 558 & y <= 120 & y >= 100 & (time3_0 | time3_4 | time3_5 | time3_6 | time3_8 | time3_9 )) ? 8'hFF : 0;

// hexagons

assign h1_1 = ( x > 218 & x < 222 & y <= 160 & y >= 140 ) ? 8'hFF : 0;
assign h1_2 = ( x > 220 & x < 224 & y <= 161 & y >= 139 ) ? 8'hFF : 0;
assign h1_3 = ( x > 222 & x < 226 & y <= 162 & y >= 138 ) ? 8'hFF : 0;
assign h1_4 = ( x > 224 & x < 228 & y <= 163 & y >= 137 ) ? 8'hFF : 0;
assign h1_5 = ( x > 226 & x < 230 & y <= 164 & y >= 136 ) ? 8'hFF : 0;
assign h1_6 = ( x > 228 & x < 232 & y <= 165 & y >= 135 ) ? 8'hFF : 0;
assign h1_7 = ( x > 230 & x < 234 & y <= 166 & y >= 134 ) ? 8'hFF : 0;
assign h1_8 = ( x > 232 & x < 236 & y <= 167 & y >= 133 ) ? 8'hFF : 0;
assign h1_9 = ( x > 234 & x < 238 & y <= 168 & y >= 132 ) ? 8'hFF : 0;
assign h1_10 = ( x > 236 & x < 240 & y <= 169 & y >= 131 ) ? 8'hFF : 0;
assign h1_11 = ( x > 238 & x < 242 & y <= 170 & y >= 130 ) ? 8'hFF : 0;
assign h1_12 = ( x > 240 & x < 244 & y <= 169 & y >= 131 ) ? 8'hFF : 0;
assign h1_13 = ( x > 242 & x < 246 & y <= 168 & y >= 132 ) ? 8'hFF : 0;
assign h1_14 = ( x > 244 & x < 248 & y <= 167 & y >= 133 ) ? 8'hFF : 0;
assign h1_15 = ( x > 246 & x < 250 & y <= 166 & y >= 134 ) ? 8'hFF : 0;
assign h1_16 = ( x > 248 & x < 252 & y <= 165 & y >= 135 ) ? 8'hFF : 0;
assign h1_17 = ( x > 250 & x < 254 & y <= 164 & y >= 136 ) ? 8'hFF : 0;
assign h1_18 = ( x > 252 & x < 256 & y <= 163 & y >= 137 ) ? 8'hFF : 0;
assign h1_19 = ( x > 254 & x < 258 & y <= 162 & y >= 138 ) ? 8'hFF : 0;
assign h1_20 = ( x > 256 & x < 260 & y <= 161 & y >= 139 ) ? 8'hFF : 0;

assign h2_1 = ( x > 338 & x < 342 & y <= 120 & y >= 100 ) ? 8'hFF : 0;
assign h2_2 = ( x > 340 & x < 344 & y <= 121 & y >= 99 ) ? 8'hFF : 0;
assign h2_3 = ( x > 342 & x < 346 & y <= 122 & y >= 98 ) ? 8'hFF : 0;
assign h2_4 = ( x > 344 & x < 348 & y <= 123 & y >= 97 ) ? 8'hFF : 0;
assign h2_5 = ( x > 346 & x < 350 & y <= 124 & y >= 96 ) ? 8'hFF : 0;
assign h2_6 = ( x > 348 & x < 352 & y <= 125 & y >= 95 ) ? 8'hFF : 0;
assign h2_7 = ( x > 350 & x < 354 & y <= 126 & y >= 94 ) ? 8'hFF : 0;
assign h2_8 = ( x > 352 & x < 356 & y <= 127 & y >= 93 ) ? 8'hFF : 0;
assign h2_9 = ( x > 354 & x < 358 & y <= 128 & y >= 92 ) ? 8'hFF : 0;
assign h2_10 = ( x > 356 & x < 360 & y <= 129 & y >= 91 ) ? 8'hFF : 0;
assign h2_11 = ( x > 358 & x < 362 & y <= 130 & y >= 90 ) ? 8'hFF : 0;
assign h2_12 = ( x > 360 & x < 364 & y <= 129 & y >= 91 ) ? 8'hFF : 0;
assign h2_13 = ( x > 362 & x < 366 & y <= 128 & y >= 92 ) ? 8'hFF : 0;
assign h2_14 = ( x > 364 & x < 368 & y <= 127 & y >= 93 ) ? 8'hFF : 0;
assign h2_15 = ( x > 366 & x < 370 & y <= 126 & y >= 94 ) ? 8'hFF : 0;
assign h2_16 = ( x > 368 & x < 372 & y <= 125 & y >= 95 ) ? 8'hFF : 0;
assign h2_17 = ( x > 370 & x < 374 & y <= 124 & y >= 96 ) ? 8'hFF : 0;
assign h2_18 = ( x > 372 & x < 376 & y <= 123 & y >= 97 ) ? 8'hFF : 0;
assign h2_19 = ( x > 374 & x < 378 & y <= 122 & y >= 98 ) ? 8'hFF : 0;
assign h2_20 = ( x > 376 & x < 380 & y <= 121 & y >= 99 ) ? 8'hFF : 0;

//colours

assign VGA_R = top_wall | left_wall | right_wall | bottom_right_wall | bottom_left_wall | circle_2 | circle_3 | game_ball | flipper_right | flipper_left | s1_1 |
s1_2 | s1_3  | s1_4  | s1_5  | s1_6  | s1_7 | s2_1 | s2_2 | s2_3  | s2_4  | s2_5  | s2_6  | s2_7 | s3_1 | s3_2 | s3_3  | s3_4  | s3_5  | s3_6  | s3_7 |
s_1 | s_2 | s_3 | s_4 | s_5 | t_1 | t_2 | t1_1 |
t1_2 | t1_3  | t1_4  | t1_5  | t1_6  | t1_7 | t2_1 | t2_2 | t2_3  | t2_4  | t2_5  | t2_6  | t2_7 | t3_1 | t3_2 | t3_3  | t3_4  | t3_5  | t3_6  | t3_7 |
h1_1 | h1_2| h1_3| h1_4| h1_5| h1_6| h1_7| h1_8| h1_9| h1_10| h1_11| h1_12| h1_13| h1_14| h1_15| h1_16| h1_17| h1_18| h1_19| h1_20 |
h2_1 | h2_2| h2_3| h2_4| h2_5| h2_6| h2_7| h2_8| h2_9| h2_10| h2_11| h2_12| h2_13| h2_14| h2_15| h2_16| h2_17| h2_18| h2_19| h2_20;
assign VGA_G = top_wall | left_wall | right_wall | bottom_right_wall | bottom_left_wall | circle_1 | circle_4 | game_ball | s1_1 |
s1_2 | s1_3  | s1_4  | s1_5  | s1_6  | s1_7 | s2_1 | s2_2 | s2_3  | s2_4  | s2_5  | s2_6  | s2_7 | s3_1 | s3_2 | s3_3  | s3_4  | s3_5  | s3_6  | s3_7 |
s_1 | s_2 | s_3 | s_4 | s_5 | t_1 | t_2 | t1_1 |
t1_2 | t1_3  | t1_4  | t1_5  | t1_6  | t1_7 | t2_1 | t2_2 | t2_3  | t2_4  | t2_5  | t2_6  | t2_7 | t3_1 | t3_2 | t3_3  | t3_4  | t3_5  | t3_6  | t3_7 ;
assign VGA_B = top_wall | left_wall | right_wall | bottom_right_wall | bottom_left_wall | s_1 | s_2 | s_3 | s_4 | s_5 | t_1 | t_2 | s1_1 |
s1_2 | s1_3  | s1_4  | s1_5  | s1_6  | s1_7 | s2_1 | s2_2 | s2_3  | s2_4  | s2_5  | s2_6  | s2_7 | s3_1 | s3_2 | s3_3  | s3_4  | s3_5  | s3_6  | s3_7 | t1_1 |
t1_2 | t1_3  | t1_4  | t1_5  | t1_6  | t1_7 | t2_1 | t2_2 | t2_3  | t2_4  | t2_5  | t2_6  | t2_7 | t3_1 | t3_2 | t3_3  | t3_4  | t3_5  | t3_6  | t3_7 |
h1_1 | h1_2| h1_3| h1_4| h1_5| h1_6| h1_7| h1_8| h1_9| h1_10| h1_11| h1_12| h1_13| h1_14| h1_15| h1_16| h1_17| h1_18| h1_19| h1_20 |
h2_1 | h2_2| h2_3| h2_4| h2_5| h2_6| h2_7| h2_8| h2_9| h2_10| h2_11| h2_12| h2_13| h2_14| h2_15| h2_16| h2_17| h2_18| h2_19| h2_20;


	 
always @(posedge clock) begin
	
		counter <= counter + 1;
		if(counter > 49999999) begin
			second_clock = ~second_clock;
			counter <= 0;
			timer <= timer + 1;
			enable_collision <= 1;
		end
	if(play && vga_clk) begin
	
	
		if (!button_start) begin
			velocity_x <= 3;
			velocity_y <= 2;
		end
		//movement of the ball
		ball_center_x <= (direction_x) ? ball_center_x + velocity_x : ball_center_x - velocity_x;
		ball_center_y <= (direction_y) ? ball_center_y + velocity_y : ball_center_y - velocity_y;
		
		
		if (ball_center_x < 80 + ball_radius + 4)
			direction_x <= 1;
		else if (ball_center_x > 440 - ball_radius - 4)
			direction_x <= 0;
		else if (ball_center_y < 40 + ball_radius + 4)
			direction_y <= 1;
		else if (ball_center_y > 480 - ball_radius - 4) begin
			timer <= 0;
			score <= 0;
			ball_center_x <= 370;
			ball_center_y <= 370;
			direction_x <= 0;
			direction_y <= 0;
			velocity_x <= 0;
			velocity_y <= 0;
		end
		//bottom right wall collision
		else if ((ball_center_x >= 340) && (ball_center_x <= 440) && (ball_center_x + ball_center_y >= 755 - ball_radius) && (ball_center_x + ball_center_y <= 765 - ball_radius)) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			
			if ( direction_x == 1 && direction_y == 1) begin
				direction_x <= 0;
				direction_y <= 0;
			end 
		end
		
		//right flipper collision
		else if ((ball_center_x >= 259) && (ball_center_x <= 339) && (ball_center_x + ball_center_y >= 755 - ball_radius) && (ball_center_x + ball_center_y <= 765 - ball_radius)) begin
			if(button_right != 0) begin
				velocity_x <= velocity_y;
				velocity_y <= velocity_x;
				if ( direction_x == 1 && direction_y == 1) begin
					direction_x <= 0;
					direction_y <= 0;
				end 
			end
		end 
		
		if ((ball_center_x >= 259) && (ball_center_x <= 339) && ( ball_center_y > 420 - ball_radius - 4)) begin
			if(button_right == 0) begin
				direction_y <= 0;
			end
		end
		
		if (green1_top || green2_top) begin
			direction_y <= 0;
			if (score >= 15 && enable_collision) begin
				score <= score - 15;
				enable_collision <= 0;
			end
		end
		
		if (green1_bottom || green2_bottom) begin
			direction_y <= 1;
			if (score >= 15 && enable_collision) begin
				score <= score - 15;
				enable_collision <= 0;
			end
		end
		
		if (green1_right || green2_right) begin
			direction_x <= 1;
			if (score >= 15 && enable_collision) begin
				score <= score - 15;
				enable_collision <= 0;
			end
		end
		
		if (green1_left || green2_left) begin
			direction_x <= 0;
			if (score >= 15 && enable_collision) begin
				score <= score - 15;
				enable_collision <= 0;
			end
		end
		
		if (green1_topleft || green2_topleft) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if (score >= 15 && enable_collision) begin
				score <= score - 15;
				enable_collision <= 0;
			end
			if (direction_x == 1 && direction_y == 1) begin
				direction_x <= 0;
				direction_y <= 0;
			end
		end
		
		if (green1_topright || green2_topright) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if (score >= 15 && enable_collision) begin
				score <= score - 15;
				enable_collision <= 0;
			end
			if (direction_x == 0 && direction_y == 1) begin
				direction_x <= 1;
				direction_y <= 0;
			end
		end
		
		if (green1_bottomleft || green2_bottomleft) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if (score >= 15 && enable_collision) begin
				score <= score - 15;
				enable_collision <= 0;
			end
			if (direction_x == 1 && direction_y == 0) begin
				direction_x <= 0;
				direction_y <= 1;
			end
		end
		
		if (green1_bottomright || green2_bottomright) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if (score >= 15 && enable_collision) begin
				score <= score - 15;
				enable_collision <= 0;
			end
			if (direction_x == 0 && direction_y == 0) begin
				direction_x <= 1;
				direction_y <= 1;
			end
		end
		
		if (red1_top || red2_top) begin
			direction_y <= 0;
			if (score <= 990 && enable_collision) begin
				score <= score + 10;
				enable_collision <= 0;
			end
		end
		
		if (red1_bottom || red2_bottom ) begin
			direction_y <= 1;
			if (score <= 990 && enable_collision) begin
				score <= score + 10;
				enable_collision <= 0;
			end
		end
		
		if (red1_right || red2_right ) begin
			direction_x <= 1;
			if (score <= 990 && enable_collision) begin
				score <= score + 10;
				enable_collision <= 0;
			end
		end
		
		if (red1_left || red2_left ) begin
			direction_x <= 0;
			if (score <= 990 && enable_collision) begin
				score <= score + 10;
				enable_collision <= 0;
			end
		end
		
		if (red1_topleft || red2_topleft ) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if (score <= 990 && enable_collision) begin
				score <= score + 10;
				enable_collision <= 0;
			end
			if (direction_x == 1 && direction_y == 1) begin
				direction_x <= 0;
				direction_y <= 0;
			end
		end
		
		if (red1_topright || red2_topright ) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if (score <= 990 && enable_collision) begin
				score <= score + 10;
				enable_collision <= 0;
			end
			if (direction_x == 0 && direction_y == 1) begin
				direction_x <= 1;
				direction_y <= 0;
			end
		end
		
		if (red1_bottomleft || red2_bottomleft ) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if (score <= 990 && enable_collision) begin
				score <= score + 10;
				enable_collision <= 0;
			end
			if (direction_x == 1 && direction_y == 0) begin
				direction_x <= 0;
				direction_y <= 1;
			end
		end
		
		if (red1_bottomright || red2_bottomright ) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if (score <= 990 && enable_collision) begin
				score <= score + 10;
				enable_collision <= 0;
			end
			if (direction_x == 0 && direction_y == 0) begin
				direction_x <= 1;
				direction_y <= 1;
			end
		end
		
		//we tried at least :( 
		if (game_ball && (h1_1 || h1_2 || h1_3 || h1_4 || h1_5 || h1_6 || h1_7 || h1_8 || h1_9 || h1_10 || h1_11 || h1_12 || h1_13 || h1_14 || h1_15 || h1_16 || h1_17 ||
		h1_18|| h1_19|| h1_20 || h2_1 || h2_2|| h2_3|| h2_4|| h2_5|| h2_6|| h2_7|| h2_8|| h2_9|| h2_10|| h2_11|| h2_12|| h2_13|| h2_14|| h2_15|| h2_16|| h2_17|| h2_18|| h2_19|| h2_20)) begin
			direction_x <= ~direction_x;
			direction_y <= ~direction_y;
			if (score <= 990 && enable_collision) begin
				score <= score + 20;
				enable_collision <= 0;
			end
		end
		
		// left flipper collision////////////////////////////////////////////////
		else if ((ball_center_x >= 179) && (ball_center_x <= 259) && (ball_center_y - ball_center_x >= 255 - ball_radius) && (ball_center_y - ball_center_x <= 265 - ball_radius)) begin
			if(button_left != 0) begin
				velocity_x <= velocity_y;
				velocity_y <= velocity_x;
				if ( direction_x == 0 && direction_y == 1) begin
					direction_x <= 1;
					direction_y <= 0;
				end 
			end
		end 
		
		if ((ball_center_x >= 179) && (ball_center_x <= 259) && ( ball_center_y > 420 - ball_radius - 4)) begin
			if(button_left == 0) begin
				direction_y <= 0;
			end
		end
		/////////////////////////////////////////////////////////////////////////////
			
		// bottom left wall	
		else if ((ball_center_x >= 80) && (ball_center_x <= 180) && (ball_center_y >= ball_center_x + 235 - ball_radius) && (ball_center_y <= ball_center_x + 245 - ball_radius)) begin
			velocity_x <= velocity_y;
			velocity_y <= velocity_x;
			if ( direction_x == 0 && direction_y == 1) begin
				direction_x <= 1;
				direction_y <= 0;
			end
		end
		
		//flipper movements
		if (button_right == 0 && slope_flipper_right != 0)
			slope_flipper_right <= slope_flipper_right - 10;
		if (button_right != 0 && slope_flipper_right <= 100)
			slope_flipper_right <= slope_flipper_right + 10;
			
		if (button_left == 0 && slope_flipper_left != 0)
			slope_flipper_left <= slope_flipper_left - 10;
		if (button_left != 0 && slope_flipper_left <= 100)
			slope_flipper_left <= slope_flipper_left + 10;
			
			
		// score update
		score1 = score / 100;
		score2 = (score - score1*100) / 10;
		score3 = score - score1*100 - score2 * 10;
		
		case (score1)
		0: begin
		score1_0 = 1;
		score1_1 = 0;
		score1_2 = 0;
		score1_3 = 0;
		score1_4 = 0;
		score1_5 = 0;
		score1_6 = 0;
		score1_7 = 0;
		score1_8 = 0;
		score1_9 = 0;
		end
		1: begin
		score1_0 = 0;
		score1_1 = 1;
		score1_2 = 0;
		score1_3 = 0;
		score1_4 = 0;
		score1_5 = 0;
		score1_6 = 0;
		score1_7 = 0;
		score1_8 = 0;
		score1_9 = 0;
		end
		2: begin
		score1_0 = 0;
		score1_1 = 0;
		score1_2 = 1;
		score1_3 = 0;
		score1_4 = 0;
		score1_5 = 0;
		score1_6 = 0;
		score1_7 = 0;
		score1_8 = 0;
		score1_9 = 0;
		end
		3: begin
		score1_0 = 0;
		score1_1 = 0;
		score1_2 = 0;
		score1_3 = 1;
		score1_4 = 0;
		score1_5 = 0;
		score1_6 = 0;
		score1_7 = 0;
		score1_8 = 0;
		score1_9 = 0;
		end
		4: begin
		score1_0 = 0;
		score1_1 = 0;
		score1_2 = 0;
		score1_3 = 0;
		score1_4 = 1;
		score1_5 = 0;
		score1_6 = 0;
		score1_7 = 0;
		score1_8 = 0;
		score1_9 = 0;
		end
		5: begin
		score1_0 = 0;
		score1_1 = 0;
		score1_2 = 0;
		score1_3 = 0;
		score1_4 = 0;
		score1_5 = 1;
		score1_6 = 0;
		score1_7 = 0;
		score1_8 = 0;
		score1_9 = 0;
		end
		6: begin
		score1_0 = 0;
		score1_1 = 0;
		score1_2 = 0;
		score1_3 = 0;
		score1_4 = 0;
		score1_5 = 0;
		score1_6 = 1;
		score1_7 = 0;
		score1_8 = 0;
		score1_9 = 0;
		end
		7: begin
		score1_0 = 0;
		score1_1 = 0;
		score1_2 = 0;
		score1_3 = 0;
		score1_4 = 0;
		score1_5 = 0;
		score1_6 = 0;
		score1_7 = 1;
		score1_8 = 0;
		score1_9 = 0;
		end
		8: begin
		score1_0 = 0;
		score1_1 = 0;
		score1_2 = 0;
		score1_3 = 0;
		score1_4 = 0;
		score1_5 = 0;
		score1_6 = 0;
		score1_7 = 0;
		score1_8 = 1;
		score1_9 = 0;
		end
		9: begin
		score1_0 = 0;
		score1_1 = 0;
		score1_2 = 0;
		score1_3 = 0;
		score1_4 = 0;
		score1_5 = 0;
		score1_6 = 0;
		score1_7 = 0;
		score1_8 = 0;
		score1_9 = 1;
		end
	endcase
	
	case (score2)
		0: begin
		score2_0 = 1;
		score2_1 = 0;
		score2_2 = 0;
		score2_3 = 0;
		score2_4 = 0;
		score2_5 = 0;
		score2_6 = 0;
		score2_7 = 0;
		score2_8 = 0;
		score2_9 = 0;
		end
		1: begin
		score2_0 = 0;
		score2_1 = 1;
		score2_2 = 0;
		score2_3 = 0;
		score2_4 = 0;
		score2_5 = 0;
		score2_6 = 0;
		score2_7 = 0;
		score2_8 = 0;
		score2_9 = 0;
		end
		2: begin
		score2_0 = 0;
		score2_1 = 0;
		score2_2 = 1;
		score2_3 = 0;
		score2_4 = 0;
		score2_5 = 0;
		score2_6 = 0;
		score2_7 = 0;
		score2_8 = 0;
		score2_9 = 0;
		end
		3: begin
		score2_0 = 0;
		score2_1 = 0;
		score2_2 = 0;
		score2_3 = 1;
		score2_4 = 0;
		score2_5 = 0;
		score2_6 = 0;
		score2_7 = 0;
		score2_8 = 0;
		score2_9 = 0;
		end
		4: begin
		score2_0 = 0;
		score2_1 = 0;
		score2_2 = 0;
		score2_3 = 0;
		score2_4 = 1;
		score2_5 = 0;
		score2_6 = 0;
		score2_7 = 0;
		score2_8 = 0;
		score2_9 = 0;
		end
		5: begin
		score2_0 = 0;
		score2_1 = 0;
		score2_2 = 0;
		score2_3 = 0;
		score2_4 = 0;
		score2_5 = 1;
		score2_6 = 0;
		score2_7 = 0;
		score2_8 = 0;
		score2_9 = 0;
		end
		6: begin
		score2_0 = 0;
		score2_1 = 0;
		score2_2 = 0;
		score2_3 = 0;
		score2_4 = 0;
		score2_5 = 0;
		score2_6 = 1;
		score2_7 = 0;
		score2_8 = 0;
		score2_9 = 0;
		end
		7: begin
		score2_0 = 0;
		score2_1 = 0;
		score2_2 = 0;
		score2_3 = 0;
		score2_4 = 0;
		score2_5 = 0;
		score2_6 = 0;
		score2_7 = 1;
		score2_8 = 0;
		score2_9 = 0;
		end
		8: begin
		score2_0 = 0;
		score2_1 = 0;
		score2_2 = 0;
		score2_3 = 0;
		score2_4 = 0;
		score2_5 = 0;
		score2_6 = 0;
		score2_7 = 0;
		score2_8 = 1;
		score2_9 = 0;
		end
		9: begin
		score2_0 = 0;
		score2_1 = 0;
		score2_2 = 0;
		score2_3 = 0;
		score2_4 = 0;
		score2_5 = 0;
		score2_6 = 0;
		score2_7 = 0;
		score2_8 = 0;
		score2_9 = 1;
		end
	endcase
	
	case (score3)
		0: begin
		score3_0 = 1;
		score3_1 = 0;
		score3_2 = 0;
		score3_3 = 0;
		score3_4 = 0;
		score3_5 = 0;
		score3_6 = 0;
		score3_7 = 0;
		score3_8 = 0;
		score3_9 = 0;
		end
		1: begin
		score3_0 = 0;
		score3_1 = 1;
		score3_2 = 0;
		score3_3 = 0;
		score3_4 = 0;
		score3_5 = 0;
		score3_6 = 0;
		score3_7 = 0;
		score3_8 = 0;
		score3_9 = 0;
		end
		2: begin
		score3_0 = 0;
		score3_1 = 0;
		score3_2 = 1;
		score3_3 = 0;
		score3_4 = 0;
		score3_5 = 0;
		score3_6 = 0;
		score3_7 = 0;
		score3_8 = 0;
		score3_9 = 0;
		end
		3: begin
		score3_0 = 0;
		score3_1 = 0;
		score3_2 = 0;
		score3_3 = 1;
		score3_4 = 0;
		score3_5 = 0;
		score3_6 = 0;
		score3_7 = 0;
		score3_8 = 0;
		score3_9 = 0;
		end
		4: begin
		score3_0 = 0;
		score3_1 = 0;
		score3_2 = 0;
		score3_3 = 0;
		score3_4 = 1;
		score3_5 = 0;
		score3_6 = 0;
		score3_7 = 0;
		score3_8 = 0;
		score3_9 = 0;
		end
		5: begin
		score3_0 = 0;
		score3_1 = 0;
		score3_2 = 0;
		score3_3 = 0;
		score3_4 = 0;
		score3_5 = 1;
		score3_6 = 0;
		score3_7 = 0;
		score3_8 = 0;
		score3_9 = 0;
		end
		6: begin
		score3_0 = 0;
		score3_1 = 0;
		score3_2 = 0;
		score3_3 = 0;
		score3_4 = 0;
		score3_5 = 0;
		score3_6 = 1;
		score3_7 = 0;
		score3_8 = 0;
		score3_9 = 0;
		end
		7: begin
		score3_0 = 0;
		score3_1 = 0;
		score3_2 = 0;
		score3_3 = 0;
		score3_4 = 0;
		score3_5 = 0;
		score3_6 = 0;
		score3_7 = 1;
		score3_8 = 0;
		score3_9 = 0;
		end
		8: begin
		score3_0 = 0;
		score3_1 = 0;
		score3_2 = 0;
		score3_3 = 0;
		score3_4 = 0;
		score3_5 = 0;
		score3_6 = 0;
		score3_7 = 0;
		score3_8 = 1;
		score3_9 = 0;
		end
		9: begin
		score3_0 = 0;
		score3_1 = 0;
		score3_2 = 0;
		score3_3 = 0;
		score3_4 = 0;
		score3_5 = 0;
		score3_6 = 0;
		score3_7 = 0;
		score3_8 = 0;
		score3_9 = 1;
		end
	endcase
	
		time1 = timer / 100;
		time2 = (timer - time1*100) / 10;
		time3 = timer - time1*100 - time2 * 10;
		
		case (time1)
		0: begin
		time1_0 = 1;
		time1_1 = 0;
		time1_2 = 0;
		time1_3 = 0;
		time1_4 = 0;
		time1_5 = 0;
		time1_6 = 0;
		time1_7 = 0;
		time1_8 = 0;
		time1_9 = 0;
		end
		1: begin
		time1_0 = 0;
		time1_1 = 1;
		time1_2 = 0;
		time1_3 = 0;
		time1_4 = 0;
		time1_5 = 0;
		time1_6 = 0;
		time1_7 = 0;
		time1_8 = 0;
		time1_9 = 0;
		end
		2: begin
		time1_0 = 0;
		time1_1 = 0;
		time1_2 = 1;
		time1_3 = 0;
		time1_4 = 0;
		time1_5 = 0;
		time1_6 = 0;
		time1_7 = 0;
		time1_8 = 0;
		time1_9 = 0;
		end
		3: begin
		time1_0 = 0;
		time1_1 = 0;
		time1_2 = 0;
		time1_3 = 1;
		time1_4 = 0;
		time1_5 = 0;
		time1_6 = 0;
		time1_7 = 0;
		time1_8 = 0;
		time1_9 = 0;
		end
		4: begin
		time1_0 = 0;
		time1_1 = 0;
		time1_2 = 0;
		time1_3 = 0;
		time1_4 = 1;
		time1_5 = 0;
		time1_6 = 0;
		time1_7 = 0;
		time1_8 = 0;
		time1_9 = 0;
		end
		5: begin
		time1_0 = 0;
		time1_1 = 0;
		time1_2 = 0;
		time1_3 = 0;
		time1_4 = 0;
		time1_5 = 1;
		time1_6 = 0;
		time1_7 = 0;
		time1_8 = 0;
		time1_9 = 0;
		end
		6: begin
		time1_0 = 0;
		time1_1 = 0;
		time1_2 = 0;
		time1_3 = 0;
		time1_4 = 0;
		time1_5 = 0;
		time1_6 = 1;
		time1_7 = 0;
		time1_8 = 0;
		time1_9 = 0;
		end
		7: begin
		time1_0 = 0;
		time1_1 = 0;
		time1_2 = 0;
		time1_3 = 0;
		time1_4 = 0;
		time1_5 = 0;
		time1_6 = 0;
		time1_7 = 1;
		time1_8 = 0;
		time1_9 = 0;
		end
		8: begin
		time1_0 = 0;
		time1_1 = 0;
		time1_2 = 0;
		time1_3 = 0;
		time1_4 = 0;
		time1_5 = 0;
		time1_6 = 0;
		time1_7 = 0;
		time1_8 = 1;
		time1_9 = 0;
		end
		9: begin
		time1_0 = 0;
		time1_1 = 0;
		time1_2 = 0;
		time1_3 = 0;
		time1_4 = 0;
		time1_5 = 0;
		time1_6 = 0;
		time1_7 = 0;
		time1_8 = 0;
		time1_9 = 1;
		end
	endcase
	
	case (time2)
		0: begin
		time2_0 = 1;
		time2_1 = 0;
		time2_2 = 0;
		time2_3 = 0;
		time2_4 = 0;
		time2_5 = 0;
		time2_6 = 0;
		time2_7 = 0;
		time2_8 = 0;
		time2_9 = 0;
		end
		1: begin
		time2_0 = 0;
		time2_1 = 1;
		time2_2 = 0;
		time2_3 = 0;
		time2_4 = 0;
		time2_5 = 0;
		time2_6 = 0;
		time2_7 = 0;
		time2_8 = 0;
		time2_9 = 0;
		end
		2: begin
		time2_0 = 0;
		time2_1 = 0;
		time2_2 = 1;
		time2_3 = 0;
		time2_4 = 0;
		time2_5 = 0;
		time2_6 = 0;
		time2_7 = 0;
		time2_8 = 0;
		time2_9 = 0;
		end
		3: begin
		time2_0 = 0;
		time2_1 = 0;
		time2_2 = 0;
		time2_3 = 1;
		time2_4 = 0;
		time2_5 = 0;
		time2_6 = 0;
		time2_7 = 0;
		time2_8 = 0;
		time2_9 = 0;
		end
		4: begin
		time2_0 = 0;
		time2_1 = 0;
		time2_2 = 0;
		time2_3 = 0;
		time2_4 = 1;
		time2_5 = 0;
		time2_6 = 0;
		time2_7 = 0;
		time2_8 = 0;
		time2_9 = 0;
		end
		5: begin
		time2_0 = 0;
		time2_1 = 0;
		time2_2 = 0;
		time2_3 = 0;
		time2_4 = 0;
		time2_5 = 1;
		time2_6 = 0;
		time2_7 = 0;
		time2_8 = 0;
		time2_9 = 0;
		end
		6: begin
		time2_0 = 0;
		time2_1 = 0;
		time2_2 = 0;
		time2_3 = 0;
		time2_4 = 0;
		time2_5 = 0;
		time2_6 = 1;
		time2_7 = 0;
		time2_8 = 0;
		time2_9 = 0;
		end
		7: begin
		time2_0 = 0;
		time2_1 = 0;
		time2_2 = 0;
		time2_3 = 0;
		time2_4 = 0;
		time2_5 = 0;
		time2_6 = 0;
		time2_7 = 1;
		time2_8 = 0;
		time2_9 = 0;
		end
		8: begin
		time2_0 = 0;
		time2_1 = 0;
		time2_2 = 0;
		time2_3 = 0;
		time2_4 = 0;
		time2_5 = 0;
		time2_6 = 0;
		time2_7 = 0;
		time2_8 = 1;
		time2_9 = 0;
		end
		9: begin
		time2_0 = 0;
		time2_1 = 0;
		time2_2 = 0;
		time2_3 = 0;
		time2_4 = 0;
		time2_5 = 0;
		time2_6 = 0;
		time2_7 = 0;
		time2_8 = 0;
		time2_9 = 1;
		end
	endcase
	
	case (time3)
		0: begin
		time3_0 = 1;
		time3_1 = 0;
		time3_2 = 0;
		time3_3 = 0;
		time3_4 = 0;
		time3_5 = 0;
		time3_6 = 0;
		time3_7 = 0;
		time3_8 = 0;
		time3_9 = 0;
		end
		1: begin
		time3_0 = 0;
		time3_1 = 1;
		time3_2 = 0;
		time3_3 = 0;
		time3_4 = 0;
		time3_5 = 0;
		time3_6 = 0;
		time3_7 = 0;
		time3_8 = 0;
		time3_9 = 0;
		end
		2: begin
		time3_0 = 0;
		time3_1 = 0;
		time3_2 = 1;
		time3_3 = 0;
		time3_4 = 0;
		time3_5 = 0;
		time3_6 = 0;
		time3_7 = 0;
		time3_8 = 0;
		time3_9 = 0;
		end
		3: begin
		time3_0 = 0;
		time3_1 = 0;
		time3_2 = 0;
		time3_3 = 1;
		time3_4 = 0;
		time3_5 = 0;
		time3_6 = 0;
		time3_7 = 0;
		time3_8 = 0;
		time3_9 = 0;
		end
		4: begin
		time3_0 = 0;
		time3_1 = 0;
		time3_2 = 0;
		time3_3 = 0;
		time3_4 = 1;
		time3_5 = 0;
		time3_6 = 0;
		time3_7 = 0;
		time3_8 = 0;
		time3_9 = 0;
		end
		5: begin
		time3_0 = 0;
		time3_1 = 0;
		time3_2 = 0;
		time3_3 = 0;
		time3_4 = 0;
		time3_5 = 1;
		time3_6 = 0;
		time3_7 = 0;
		time3_8 = 0;
		time3_9 = 0;
		end
		6: begin
		time3_0 = 0;
		time3_1 = 0;
		time3_2 = 0;
		time3_3 = 0;
		time3_4 = 0;
		time3_5 = 0;
		time3_6 = 1;
		time3_7 = 0;
		time3_8 = 0;
		time3_9 = 0;
		end
		7: begin
		time3_0 = 0;
		time3_1 = 0;
		time3_2 = 0;
		time3_3 = 0;
		time3_4 = 0;
		time3_5 = 0;
		time3_6 = 0;
		time3_7 = 1;
		time3_8 = 0;
		time3_9 = 0;
		end
		8: begin
		time3_0 = 0;
		time3_1 = 0;
		time3_2 = 0;
		time3_3 = 0;
		time3_4 = 0;
		time3_5 = 0;
		time3_6 = 0;
		time3_7 = 0;
		time3_8 = 1;
		time3_9 = 0;
		end
		9: begin
		time3_0 = 0;
		time3_1 = 0;
		time3_2 = 0;
		time3_3 = 0;
		time3_4 = 0;
		time3_5 = 0;
		time3_6 = 0;
		time3_7 = 0;
		time3_8 = 0;
		time3_9 = 1;
		end
	endcase
		
	end
end

 


endmodule
