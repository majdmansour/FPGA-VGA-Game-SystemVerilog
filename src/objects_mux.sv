
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
		//Clock Input	 	
				input		logic	clk,
				input		logic	resetN,
				
		//Game Control
				input		logic	winDR,
				input		logic	[7:0] winRGB,
				input		logic	loseDR,
				input		logic	[7:0] loseRGB,
				
				
		//Player 
				input		logic	playerDrawingRequest, // two set of inputs per unit
				input		logic	[7:0] playerRGB, 
				
		//Bullet
				input		logic	bulletDrawingRequest,
				input		logic	[7:0] bulletRGB, 

		//Bird
				input		logic	birdDrawingRequestL,
				input		logic	[7:0] birdRGBL, 
				input		logic	birdDrawingRequestR,
				input		logic	[7:0] birdRGBR, 
				
		//Balloon+Coin
				input		logic	balloonDrawingRequestL,
				input		logic coinDrawingRequestL,
				input		logic	[7:0] objectsRGBL, 
				input		logic	balloonDrawingRequestM,
				input		logic coinDrawingRequestM,
				input		logic	[7:0] objectsRGBM, 
				input		logic	balloonDrawingRequestR,
				input		logic coinDrawingRequestR,
				input		logic	[7:0] objectsRGBR, 

		//Score
				input		logic	scoreDrawingRequest,
				input		logic	[7:0] scoreRGB, 
				input		logic	onesDrawingRequest,
				input		logic	[7:0] onesRGB, 
				input		logic	tensDrawingRequest,
				input		logic	[7:0] tensRGB, 
				input		logic	hundredsDrawingRequest,
				input		logic	[7:0] hundredsRGB, 
				
		//Timer
				input 	logic secLSBDR,
				input		logic	[7:0] secLSBRGB, 
				input 	logic secMSBDR,
				input		logic	[7:0] secMSBRGB,
				input 	logic dotsDR,				
				input		logic	[7:0] dotsRGB,
				input 	logic minuteDR,
				input		logic	[7:0] minuteRGB,
				
		//Heart
				input		logic	heartDrawingRequest,
				input		logic	[7:0] heartRGB, 
										
		//background 
				input    logic cloudDrawingRequestFirst, // box of numbers
				input		logic	[7:0] cloudRGBFirst,  
				input    logic cloudDrawingRequestSecond, // box of numbers
				input		logic	[7:0] cloudRGBSecond, 	
				input		logic	[7:0] RGB_MIF, 
			
				output	logic	[7:0] RGBOut
);

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
	end
	
	else begin
      if(winDR == 1'b1)
			RGBOut <= winRGB;

		else if (loseDR == 1'b1)
			RGBOut <= loseRGB;
		
		else if (scoreDrawingRequest == 1'b1)
			RGBOut <= scoreRGB;
			
		else if (onesDrawingRequest == 1'b1)
			RGBOut <= onesRGB;
		
		else if (tensDrawingRequest == 1'b1)
			RGBOut <= tensRGB;
		
		else if (hundredsDrawingRequest == 1'b1)
			RGBOut <= hundredsRGB;	
	
		else if (heartDrawingRequest == 1'b1)
			RGBOut <= heartRGB;
			
			
		else if (secLSBDR == 1'b1)
			RGBOut <= secLSBRGB;
			
		else if (secMSBDR == 1'b1)
			RGBOut <= secMSBRGB;
			
		else if (dotsDR == 1'b1)
			RGBOut <= dotsRGB;
			
		else if (minuteDR == 1'b1)
			RGBOut <= minuteRGB;
			
		else if (playerDrawingRequest == 1'b1 )   
			RGBOut <= playerRGB;  
			
		else if (bulletDrawingRequest == 1'b1 )   
			RGBOut <= bulletRGB;  
		 
		else if (birdDrawingRequestL == 1'b1)
			RGBOut <= birdRGBL;
		
		else if (birdDrawingRequestR == 1'b1)
			RGBOut <= birdRGBR;		
								 
		else if (balloonDrawingRequestL == 1'b1 || coinDrawingRequestL == 1'b1)
			RGBOut <= objectsRGBL;
		
		else if (balloonDrawingRequestM == 1'b1 || coinDrawingRequestM == 1'b1)
			RGBOut <= objectsRGBM;	
			
		else if (balloonDrawingRequestR == 1'b1 || coinDrawingRequestR == 1'b1)
			RGBOut <= objectsRGBR;
			
		else if (cloudDrawingRequestFirst == 1'b1)
			RGBOut <= cloudRGBFirst;
		else if (cloudDrawingRequestSecond == 1'b1)
			RGBOut <= cloudRGBSecond;
			
		else 
			RGBOut <= RGB_MIF;// last priority 
			
		end; 
	end

endmodule


