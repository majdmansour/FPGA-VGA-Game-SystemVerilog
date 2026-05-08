// (c) Technion IIT, Department of Electrical Engineering 2022 
// Updated by Mor Dahan - January 2022

// Implements a 4 bits down counter 9  down to 0 with several enable inputs and loadN data.
// It outputs count and asynchronous terminal count, tc, signal 

module scoreControl
	(
	input logic clk, 
	input logic resetN, 
	input logic balloonCollision,
	input logic coinCollision,
	input logic stopGame,
	
	output logic [3:0] ones,
	output logic [3:0] tens,
	output logic [3:0] hundreds,
	output logic gameWon
   );

// Down counter

int count = 0;


always_ff @(posedge clk or negedge resetN)
   begin
	      
      if (!resetN ) begin
			count <= 0;
			gameWon <= 0;
		end
			
      else 	begin	 
//				if(balloonCollision == 1'b1) begin	
//					if(count - 3 < 0)
//						count <= 0;
//					else
//						count <= count - 3;
//				end
			if(!stopGame) begin
					if(coinCollision == 1'b1)
						count <= count + 7;	
						
					if(count >= 100)
						gameWon <= 1;
			end
		end
	end 

	
assign ones = count % 10;
assign tens = (count / 10) % 10;
assign hundreds = (count / 100) % 10;

	
endmodule