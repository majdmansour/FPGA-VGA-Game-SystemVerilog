// (c) Technion IIT, Department of Electrical Engineering 2020 

module soundControl (

	input clk,
	input resetN,
	input logic oneSecPulse,
	input logic birdCollision,
	input logic coinCollision,
	input logic gameWon,
	input logic gameLost,
	
	output logic [3:0] frequency,
	output logic enable
	);
	
	
enum logic [8:0] {s_idle,s_coin1,s_coin2, s_bird1, s_bird2, s_win1, s_win2, s_win3
						,s_win4, s_win5, s_win6, s_loss1, s_loss2, s_loss3, s_end} soundState_ps;

							 
always_ff @(posedge clk or negedge resetN)
begin 

	if ( !resetN ) begin
		soundState_ps <= s_idle;
		frequency = 4'b0000;
		enable = 1'b0;
	end
	else begin
		case(soundState_ps) 
        s_idle: begin 
            frequency <= 4'b0000;
            enable <= 1'b0;
				
				if(gameWon == 1'b1)
					soundState_ps <= s_win1;
				else if(gameLost == 1'b1)
					soundState_ps <= s_loss1;
				else if(birdCollision == 1'b1)
					soundState_ps <= s_bird1;
				else if(coinCollision == 1'b1)
					soundState_ps <= s_coin1;
        end
		
			s_win1: begin 
				frequency <= 4'h8;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_win2;
			end 
		

			s_win2: begin 
				frequency <= 4'h1;
				enable <= 1'b1;
				
				if(oneSecPulse)
					soundState_ps <= s_win3;
			end 

			s_win3: begin 
				frequency <= 4'h5;
				enable <= 1'b1;
				
				if(oneSecPulse)
					soundState_ps <= s_win4;				
			end 

			s_win4: begin 
				
				frequency <= 4'h8;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_win5;
			end 

			s_win5: begin 
				
				frequency <= 4'h5;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_win6;				
			end 

			s_win6: begin 
				frequency <= 4'h1;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_end;
			end 
					
			s_coin1: begin 
				frequency <= 4'h4;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_coin2;
			end 

			s_coin2: begin 
				frequency <= 4'h2;
				enable <= 1'b1;
				
				if(oneSecPulse)
					//enable <= 1'b0;

					soundState_ps <= s_end;	
			end

			s_bird1: begin 
				frequency <= 4'h7;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_bird2;
			end 

			s_bird2: begin 
				frequency <= 4'h8;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_end;
			end

			s_loss1: begin 
				frequency <= 4'h5;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_loss2;				
			end 

			s_loss2: begin 
				frequency <= 4'h6;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_loss3;		
			end

			s_loss3: begin 
				frequency <= 4'h7;
				enable <= 1'b1;
				
				if(oneSecPulse) 
					soundState_ps <= s_end;

			end
			
			s_end: begin 
				enable <= 1'b0;
				soundState_ps <= s_idle;
			end
		endcase
	end 
end
endmodule