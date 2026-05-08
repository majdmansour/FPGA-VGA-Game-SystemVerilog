// (c) Technion IIT, Department of Electrical and Computer Engineering 2023 

module timerControl (
   // Input, Output Ports
   input logic clk, 
   input logic resetN,
	input logic stopGame,
	
   output logic [3:0] minute,
	output logic [3:0] secMSB,
	output logic [3:0] secLSB,
	output logic gameLost
   );
	
always_ff @( posedge clk or negedge resetN ) begin
     
		if( !resetN ) begin	// Asynchronic reset
		      minute <= 1;
				secMSB <= 0;
				secLSB <= 0;
				gameLost <= 0;
		end 
		else begin
			gameLost <= 0; //default
			
		   if (secLSB == 0 && (!stopGame || gameLost)) begin
				if(secMSB == 0) begin	
					if(minute == 0)
						gameLost <= 1;
					else begin
						if(!stopGame) begin
							minute <= minute - 1;
							secMSB <= 5;
							secLSB <= 9;
						end
					end
			end
				else begin
					if(!stopGame) begin
						secMSB <= secMSB - 1;
						secLSB <= 9;
					end
				end
			end
			
			else begin
				if(!stopGame)
					secLSB <= secLSB - 1;
			end		
		end	
	end // always
endmodule

