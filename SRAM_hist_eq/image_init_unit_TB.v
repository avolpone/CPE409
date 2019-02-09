////////////////////////////////////////////////////////////////////////////////////
// Image Initialization Module
//
// ---------------------------------------------------------------------------------
// Description:
// ---------------------------------------------------------------------------------
// This module initializes memory to the provided image file to be displayed
// to the screen via VGA.
// 
// Revision History :
// ---------------------------------------------------------------------------------
//   Ver  :| Author(s)     :| Mod. Date  :| Changes Made:
//   V1.0 :| Reiner Dizon  :| 08/28/2017 :| Initial Code
// ---------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////
module image_init_unit_TB();

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 14;
parameter RAM_DEPTH = (1 << ADDR_WIDTH);

//=======================================================
//  PORT declarations
//=======================================================
reg sw1, sw2, rClk, re;
reg [10:0] iX, iY;
reg [ADDR_WIDTH-1:0] ra;
wire [DATA_WIDTH-1:0] rd;

//=======================================================
//  REG/Wire declarations
//=======================================================
reg [ADDR_WIDTH-1 : 0] mem [0 : RAM_DEPTH-1];	// INTERNAL MEMORY

reg[DATA_WIDTH-1:0] hist[7:0][7:0];
reg[DATA_WIDTH-1:0] hist_eq[7:0][7:0];

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  Structural coding
//=======================================================

// Memory Initialization Code - change the file name & size parameters for different images
//initial $readmemh ("imtextHist.txt", mem);
//reg x[10:0];
//reg y[10:0];
//parameter WIDTH = 110;
//parameter HEIGHT = 145;
//initial $readmemh ("memfile2.dat", mem);
initial $readmemh ("memfile2.dat", mem);
parameter WIDTH = 128;
parameter HEIGHT = 128;
parameter PIXEL_DEPTH = 255;
parameter IMAGE_SIZE = 16384;
reg [DATA_WIDTH-1:0] temp;

reg [15:0] totalPixels = 0;
reg [15:0] eq_totalPixels = 0;
reg [7:0] CEF[7:0];

image_init_unit 	tb(
	.sw1(SW1),
	.sw2(SW2),
	.rClk(VGA_CTRL_CLK), 
	.re(Read),
	.rd(gray_out),
	.iX(VGA_X), 
	.iY(VGA_Y)
);

initial 
begin 
	sw1 = 1; 
   	$readmemh ("memfile2.dat", mem);
   	iX = 0;
   	iY = 0;
 end 
 
 initial
 begin
 $dumpfile("dmp.txt");
 $display("hello");
 $dumpvars;
 end
 
always
begin
	#10 rClk = ~rClk;
	$monitor($time, "<< iX = %d ",iX);
	$monitor($time, "<< iY = %d ",iY);
	
	$monitor($time, "<< hist = %d ",hist[iX][iY]);
end
 

 
initial
#1000 $finish;

/*
// CODE - Read & Write
always @ (posedge rClk) 
begin
	if(re) 
	begin

		// =========================================================
		// LOAD UNEQUALIZED HISTOGRAM
		// =========================================================
		if(iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
			// load memory value into standard histogram matrix
			hist[iX][iY] <= mem[iX * HEIGHT + iY];
		
		// =========================================================
		// HISTOGRAM EQUALIZATION ALGORITHM
		// =========================================================
		if(sw1 == 0 && sw2 == 0 && iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
		begin
		
			//rd <= mem[iX * HEIGHT + iY];
		
			//hist[iX][iY] <= mem[iX * HEIGHT + iY];
		
				// SCAN IMAGE FOR PIXEL INTENSITIES
				// ---------------------------------------------------------
				if(totalPixels < IMAGE_SIZE)
				begin
				
					// increment pixel counter
					totalPixels = totalPixels + 1;
				
					// CUMULATIVE EQUALIZATION FUNCTION
					// ---------------------------------------------------------
					CEF[hist[iX][iY]] = CEF[hist[iX][iY]] + 1;
					
				end
				
				// IF SCAN COMPLETED...
				// ---------------------------------------------------------
				else if(totalPixels == IMAGE_SIZE)
				begin
				
					// if there is a count from the CEF
					if(CEF[hist[iX][iY]] > 0 && eq_totalPixels < IMAGE_SIZE)
					begin
					
						// perform equalization algorithm
						hist_eq[iX][iY] = ((CEF[hist[iX][iY]] - 1) / (IMAGE_SIZE)) * PIXEL_DEPTH;
						
						// increment counter for algorithm
						eq_totalPixels = eq_totalPixels + 1;
						
					end
					
				end

		end
		
		// =========================================================
		// DISPLAY OPTIONS
		// =========================================================
		
			// SHOW UNALTERED HISTOGRAM
			// ---------------------------------------------------------		
			else if (sw1 == 1 && sw2 == 0 && iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
			// && iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
			begin
				//hist[iX][iY] <= mem[iX * HEIGHT + iY];
				rd <= hist[iX][iY];
			end
				
			// SHOW EQUALIZED HISTOGRAM
			// ---------------------------------------------------------	
			else if (sw1 == 0 && sw2 == 1 && iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
				rd <= hist_eq[iX][iY];
				
			// CLEAR SCREEN
			// ---------------------------------------------------------	
			else if (sw1 == 1 && sw2 == 1 && iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
				rd <= 8'b00000000;
				
			else
				rd <= 0;
	end
end
*/
endmodule
