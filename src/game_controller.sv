
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input logic playerDR,
			input logic birdDRL,
			input logic birdDRR,
			input logic balloonDRL,
			input logic coinDRL,	
			input logic balloonDRM,
			input logic coinDRM,	
			input logic balloonDRR,
			input logic coinDRR,	
			input logic bulletDR,	

			
			
			output logic birdCollisionL, // active in case of collision between two objects	
			output logic birdCollisionR,
			output logic balloonCollision,
			output logic coinCollision,
			output logic bulletCollision
);

assign birdCollisionL = (playerDR && birdDRL);
assign birdCollisionR = (playerDR && birdDRR);
assign bulletCollision = ((bulletDR && balloonDRL) || (bulletDR && balloonDRM) || (bulletDR && balloonDRR));
assign balloonCollision = ((playerDR && balloonDRL) || (playerDR && balloonDRM) || (playerDR && balloonDRR));
assign coinCollision = ((playerDR && coinDRL) || (playerDR && coinDRM) || (playerDR && coinDRR));

endmodule