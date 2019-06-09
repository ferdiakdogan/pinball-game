module vga_sync(
	input wire inputclock,           
	input wire pixel,       
	input wire input_reset,           
	output wire output_hsync,          
	output wire output_vsync,           
	output wire [9:0] output_x,      
	output wire [8:0] output_y,       
	output wire output_play
	);

	localparam horizontal_begin = 16;    
	localparam horizontal_end = 16 + 96; 
	localparam horizontal_sta = 16 + 96 + 48;    
	localparam vertical_sta = 480 + 10;        
	localparam vertical_end = 480 + 10 + 2;    
	localparam VertAxis_end = 480;             
	localparam horizontal   = 800;             
	localparam image = 525;             
	reg [9:0] h_count; 
	reg [9:0] v_count;  
	
	
	
	assign output_hsync = ~((h_count >= horizontal_begin) & (h_count < horizontal_end));
	assign output_vsync = ~((v_count >= vertical_sta) & (v_count < vertical_end));
	assign output_x = (h_count < horizontal_sta) ? 0 : (h_count - horizontal_sta);
	assign output_y = (v_count >= VertAxis_end) ? (VertAxis_end - 1) : (v_count);
   assign output_play = ((v_count == VertAxis_end - 1) & (h_count == horizontal));
	
		always @ (posedge inputclock)
		begin
		  if (input_reset)  
		  begin
				h_count <= 0;
				v_count <= 0;
		  end
		  if (pixel)  
		  begin
				if (h_count == horizontal) 
				begin
					 h_count <= 0;
					 v_count <= v_count + 1;
				end
				else 
					 h_count <= h_count + 1;

				if (v_count == image)  
					 v_count <= 0;
		  end
		end
endmodule