////////////////////////////////////////////////////
//Intensity Calculator Module
//Jeff Yates, Tom Gowing, Kerran Flanagan
//ECE 5760 Final Project - Cartoonifier
////////////////////////////////////////////////////
module intensityCalc (
	iCLK,
	iR,iG,iB,
	oR_bi, oG_bi, oB_bi,
	oIntensity
);

	input			iCLK;			//27MHz VGA clock
	input [9:0]	iR,iG,iB,oR_bi, oG_bi, oB_bi;	//RGB input
	
	output reg [9:0] oIntensity;	//Intensity output
	
	always @(posedge iCLK) begin
		//    I     =  .25R  +  .5G  + .25B
		oIntensity <= (iR>>2)+(iG>>1)+(iB>>2);
		
		
	end
	
endmodule
