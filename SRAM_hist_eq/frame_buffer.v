module frame_buffer
(
	input sw1,
	input [10:0] iX, iY,
	//input [ADDR_WIDTH-1:0] ra, wa,
	input re, clk,
	input [DATA_WIDTH-1:0] rd,
	output reg [DATA_WIDTH-1:0] q
);

// Declare the RAM variable
reg [ADDR_WIDTH-1 : 0] ram [0 : RAM_DEPTH-1];	// INTERNAL MEMORY

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 14;
parameter RAM_DEPTH = (1 << ADDR_WIDTH);

parameter WIDTH = 110;
parameter HEIGHT = 145;

reg switch;


always
	begin
	
		// Write
		//if (!re)
	//		ram[iX * HEIGHT + iY] <= rd;
/*
		else if(re && switch == 1)
			if( (iY >= 0 && iY <= 10) && (iX >= 0 && iX <= 10) )
					q <= ram[iX * HEIGHT + iY];
			else
					q <= 8'b10000000; // send green border
					*/
	//	else if(sw1 == 1)
			q <= rd;
	end

endmodule
