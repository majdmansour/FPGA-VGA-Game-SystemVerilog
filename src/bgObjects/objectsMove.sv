// (c) Technion IIT, Department of Electrical Engineering 2023 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updated Eyal Lev April 2023
// updated to state machine Dudy March 2023 
// update the hit and collision algoritm - Eyal Jan 2024

module	objectsMove	(	

			input	 logic clk,
			input	 logic resetN,
			input	 logic startOfFrame,      //short pulse every start of frame 30Hz  
			input	 logic keyIsPressed[9:0],
			input  logic bgMove,
			input  logic collision,
			input  logic [3:0] HitEdgeCode,

			output logic signed 	[10:0] topLeftX, // output the top left corner 
			output logic signed	[10:0] topLeftY,  // can be negative , if the object is partliy outside 
			output logic outOfScreenFlag
					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 0;
parameter int INITIAL_Y = 0;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
parameter int X_SPEED = -100;
parameter int Y_SPEED = -100;
parameter int Y_ACCEL = -10;

const int MAX_Y_SPEED = 500;
const int	FIXED_POINT_MULTIPLIER = 64; // note it must be 2^n 
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions


// movement limits 
const int   OBJECT_WIDTH_X = 32;
const int   OBJECT_HIGHT_Y = 32;
const int	SafetyMargin   =	2;

const int	x_FRAME_LEFT	=	-((512)* FIXED_POINT_MULTIPLIER); 
const int	x_FRAME_RIGHT	=	(1024)* FIXED_POINT_MULTIPLIER; 
const int	y_FRAME_TOP		=	(SafetyMargin) * FIXED_POINT_MULTIPLIER;
const int	y_FRAME_BOTTOM	=	(479 - SafetyMargin - OBJECT_HIGHT_Y ) * FIXED_POINT_MULTIPLIER; //- OBJECT_HIGHT_Y


enum  logic [2:0] {IDLE_ST,         	// initial state
						 MOVE_ST,
						 START_OF_FRAME_ST,// moving no colision 
						 POSITION_CHANGE_ST, // position interpolate 
						 POSITION_LIMITS_ST  // check if inside the frame  
						}  SM_Motion ;

int Xspeed;  
int Yspeed; 
int Xposition; //position   
int Yposition;  
logic [3:0] hit_reg = 4'b0;
 
 //---------
 
always_ff @(posedge clk or negedge resetN)
begin : fsm_sync_proc

	if (resetN == 1'b0) begin 
		SM_Motion <= IDLE_ST; 
		Xspeed <= 0; 
		Yspeed <= 0; 
		Xposition <= 0; 
		Yposition <= 0; 
		outOfScreenFlag <= 0;
	end 	
	
	else begin
	
		case(SM_Motion)
		
		//------------
			IDLE_ST: begin
		//------------
		
				Xspeed  <= INITIAL_X_SPEED ; 
				Yspeed  <= INITIAL_Y_SPEED  ; 
				Xposition <= INITIAL_X * FIXED_POINT_MULTIPLIER; 
				Yposition <= INITIAL_Y * FIXED_POINT_MULTIPLIER; 
				outOfScreenFlag <= 0;

				if (startOfFrame) 
					SM_Motion <= MOVE_ST ;
 	
			end
	
		//------------
			MOVE_ST:  begin     // moving no colision 
		//------------
				outOfScreenFlag <= 0;
				
				if(keyIsPressed[6]  && bgMove == 1) 
					Xspeed <= X_SPEED;
					
				if((!keyIsPressed[6] && !keyIsPressed[4]) || (keyIsPressed[6] && keyIsPressed[4])) 
					Xspeed <= INITIAL_X_SPEED;
									
				if(collision) begin
					hit_reg <= hit_reg | HitEdgeCode;
					SM_Motion <= START_OF_FRAME_ST;
				end
				
				else if(startOfFrame)
					SM_Motion <= POSITION_CHANGE_ST; 			
		end 
		
		//------------------------
			START_OF_FRAME_ST : begin  // position interpolate 
		//------------------------
				if(hit_reg[1] && Xspeed < 0)
					Xspeed <= 0;
			
				if(hit_reg[3] && Xspeed < 0)
					Xspeed <= 0;
					
				hit_reg <= 0;
			
				SM_Motion <= POSITION_CHANGE_ST;
			end
			
		//------------------------
			POSITION_CHANGE_ST : begin  // position interpolate 
		//------------------------
	
				Xposition <= Xposition + Xspeed ; 
				Yposition <= Yposition + Yspeed ;
	
				SM_Motion <= POSITION_LIMITS_ST ; 
			end
		
		//------------------------
			POSITION_LIMITS_ST : begin  //check if still inside the frame 
		//------------------------
				if (Xposition < x_FRAME_LEFT) begin
								Xposition <= x_FRAME_RIGHT;
								outOfScreenFlag <= 1'b1;

				end	
				if (Xposition > x_FRAME_RIGHT) begin
								Xposition <= x_FRAME_LEFT ; 
				end
				if (Yposition < y_FRAME_TOP) 
								Yposition <= y_FRAME_TOP ; 
				if (Yposition > y_FRAME_BOTTOM) 
								Yposition <= y_FRAME_BOTTOM ; 

				SM_Motion <= MOVE_ST ; 
			end
		
		endcase  // case 
		
	end 

end // end fsm_sync


//return from FIXED point  trunc back to prame size parameters 
  
assign 	topLeftX = Xposition / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign 	topLeftY = Yposition / FIXED_POINT_MULTIPLIER ;    
	

endmodule	
//---------------
 
