module Freq_Counter (clock, iReset_N, SW1, SW2, iPixel, CDF_done, calc_start, calc_done, iPixel_new, re);
//iX, iY);

//=======================================================
//  PORT declarations
//=======================================================
input re, SW1, SW2;
//input [10:0] iX, iY;
input	clock, iReset_N;
input	[7:0] iPixel;
output reg CDF_done;
output reg calc_start;
output reg calc_done;
output reg [7:0] iPixel_new;

//=======================================================
//  Parameter declarations
//=======================================================
parameter PIX_RANGE = 255;

/*
// 64 x 64
parameter LENGTH = 64;
parameter WIDTH = 64;
parameter AREA = (4096-1);
*/


// 128 x 128
parameter LENGTH = 128;
parameter WIDTH = 128;
parameter AREA = (16384-1);


//=======================================================
//  REG/Wire declarations
//=======================================================
reg [256:0] count [256:0];
reg [256:0] CDF [256:0];
reg [31:0] temp;
reg [31:0] CDF_temp;
reg [31:0] temp_finished;
reg [15:0] grey_min;
reg [15:0] CDF_min;

reg [31:0] CDF_start;
reg [16:0] pixel_count;
reg [31:0] CDF_counter = 0;


//=======================================================
//  Structural coding
//=======================================================

always @(posedge clock) //or negedge iReset_N) 
begin

	//=======================================================
	// RESET
	//=======================================================
	if(iReset_N == 1) 
	begin
		pixel_count <= 0;
		CDF_counter <= 0;
		CDF_temp <= 0;
		CDF_start <= 0;
	/*
		CDF_min <= 0;
		CDF_done <= 0;
		calc_start <= 0;
		calc_done <= 0;
		iPixel_new <= 0;
	*/
	end

	//=======================================================
	// ELSE, BEGIN COMPUTATIONS
	//=======================================================
	else if(iReset_N == 0)
	begin
	
		// placeholder condition
		if(calc_done == 0)
		begin
			
			// if total pixel count < image area, do algorithm
			if(pixel_count < AREA)
			begin
			
				// add iPixel count to temp
				temp <= count[iPixel];
				temp <= temp + 1;
				count[iPixel] <= temp;

				// if this count is less than the CDF minimum count
				if(count[iPixel] < CDF_min)
				   CDF_min <= count[iPixel];		// make new temp count the CDF minimum			
			
				// increment total pixel count
				pixel_count = pixel_count + 1;
				
			end

			// if total pixel count is finished, begin CDF computations
			else if(pixel_count >= AREA)
			begin
			
				// placeholder bool for debugging
				if(CDF_done == 0)
				begin

					// start accumulating total CDF count by incrementing up until 255
					if(CDF_counter >= 0 && CDF_counter <= 255)
					begin
					
						// move current accumulated count into temp
						temp <= count[CDF_counter];
						
						// add the newest count index to accumulated total
						CDF_temp	<= CDF_temp + count[CDF_counter];
						CDF[CDF_counter] <= CDF_temp;
					
						// set the accumulated total to the pixel intensity index
						CDF[iPixel] <= CDF_temp;
						
						// increment CDF counter by 1
						CDF_counter <= CDF_counter + 1;
						
						// debugging - set next loop counter to 0
						CDF_start <= 0;
					end
						
					// if counter complete, move on to last step of algorithm
					else if(CDF_counter > 255)
					begin
						
						// if last CDF counter still calculating the new histogram, continue
						if(CDF_start >= 0 && CDF_start <= 255)
						begin
						
							// set the pixel CDF to temp
							temp <= CDF[iPixel];
							
							// subtract from CDF_min
							temp <= (temp - CDF_min);
							
							// multiply by intensity range (0 - 255)
							temp <= temp * 255;

							// divide by picture area (L x W)
							CDF[iPixel] <= temp / AREA;

							// increment CDF calculation counter
							CDF_start <= CDF_start + 1;
						end
						
						// if CDF calculations done, new histogram is finished
						else if(CDF_start > 255)
						begin
							// set temp to the new pixel value calculated
							temp <= CDF[iPixel];
							
							// push the new pixel out to VGA controller
							temp_finished <= temp;
						end
						
					end
				end
			end
		end

		// if SW1 off, show original image
		if(SW1 == 0)
			iPixel_new <= iPixel; // take old pixel and rewrite to output
			
		// if SW1 on, show modified pixel
		else if(SW1 == 1)
			iPixel_new <= temp_finished; 	// take modified pixel and rewrite to output
			
	end
end

endmodule
