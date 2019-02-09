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
//   V1.1 :| Aaron VOlpone :| 12/19/2017 :| Reworked for histogram equalization
// ---------------------------------------------------------------------------------
////////////////////////////////////////////////////////////////////////////////////

module image_init_unit(CDF_done, calc_done, newPixel, sw1, sw2, rClk, re, ra, rd, rd_temp, iX, iY);

//=======================================================
//  PORT declarations
//=======================================================
input CDF_done, calc_done;				// placeholder bool pins
input	[DATA_WIDTH-1:0] newPixel;		// modified pixel input
input sw1, sw2, rClk, re;				
input [10:0] iX, iY;
input [ADDR_WIDTH-1:0] ra;
output reg [DATA_WIDTH-1:0] rd;		 // read pixel sent to VGA controller
output reg [DATA_WIDTH-1:0] rd_temp; // read pixel output from original histogram

//=======================================================
//  REG/Wire declarations
//=======================================================
reg [ADDR_WIDTH-1 : 0] mem  [0 : RAM_DEPTH-1];	// OLD HISTOGRAM
//reg [ADDR_WIDTH-1 : 0] hist [0 : RAM_DEPTH-1];	// NEW HISTOGRAM (needs work)

//=======================================================
//  PARAMETER declarations
//=======================================================
parameter DATA_WIDTH =  8;
parameter ADDR_WIDTH =  14;
parameter RAM_DEPTH  =  (1 << ADDR_WIDTH);

//=======================================================
//  Structural coding
//=======================================================

// Memory Initialization Code - change the file name & size parameters for different images
// 128 x 128
initial $readmemh ("lena_dark.dat", mem);
parameter WIDTH = 128;
parameter HEIGHT = 128;

//initial $readmemh ("imtextHist.txt", mem);
//parameter WIDTH = 145;
//parameter HEIGHT = 120;

/*
// 64 x 64
initial $readmemh ("memfile1.dat", mem);
parameter WIDTH = 64;
parameter HEIGHT = 64;
*/

// CODE - Read & Write
always @ (posedge rClk) begin

// WRITE TO NEW HISTOGRAM
/*
	// attempt at storing new pixel in memory location (needs work)
	if(re == 0 && calc_done == 0) begin
		if	(iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
			hist[iX * WIDTH + iY] = newPixel;
	end
*/

// ELSE READ FROM OLD HISTOGRAM
		if	(iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
			rd_temp <= mem[iX * WIDTH + iY];
			
		// in-flight operation - push new pixel out immediately
		if	(iY >= 0 && iY < HEIGHT && iX >= 0 && iX < WIDTH)
			rd <= newPixel;
		else	
			rd <= 0;
end

endmodule
