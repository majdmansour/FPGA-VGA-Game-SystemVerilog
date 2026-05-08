// (c) Technion IIT, Department of Electrical Engineering 2023 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updated Eyal Lev April 2023
// updated to state machine Dudy March 2023 
// update the hit and collision algoritm - Eyal Jan 2024

module	playerMove	(	
 
					input	 logic clk,
					input	 logic resetN,
					input	 logic startOfFrame,      //short pulse every start of frame 30Hz 
					input  logic keyIsPressed[9:0],
					input  logic collision,         //collision if smiley hits an object
					input  logic [3:0] HitEdgeCode, //one bit per edge

					output logic signed 	[10:0] topLeftX, // output the top left corner 
					output logic signed	[10:0] topLeftY, // can be negative , if the object is partliy outside 
					output logic mirrorLeft,
					output logic bgMove

					
);


// a module used to generate the  ball trajectory.  

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
parameter int X_SPEED = 100;
parameter int Y_SPEED = 80;
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

const int	x_FRAME_LEFT	=	(SafetyMargin)* FIXED_POINT_MULTIPLIER; 
const int	x_FRAME_RIGHT	=	(306)* FIXED_POINT_MULTIPLIER; 
const int	y_FRAME_TOP		=	(SafetyMargin) * FIXED_POINT_MULTIPLIER;
const int	y_FRAME_BOTTOM	=	(479 -SafetyMargin - OBJECT_HIGHT_Y - 54) * FIXED_POINT_MULTIPLIER; //- OBJECT_HIGHT_Y


enum  logic [2:0] {IDLE_ST,         	// initial state
						 MOVE_ST, 				// moving no colision 
						 START_OF_FRAME_ST, 	          // startOfFrame activity-after all data collected 
						 POSITION_CHANGE_ST, // position interpolate 
						 POSITION_LIMITS_ST  // check if inside the frame  
						}  SM_Motion ;

int Xspeed  ; // speed    
int Yspeed  ; 
int Xposition ; //position   
int Yposition ;  

//logic toggle_x_key_D ;
 

logic [3:0] hit_reg = 4'b0;  // register to collect all the collisions in the frame. |corner|left|top|right|bottom|

 //---------
 
always_ff @(posedge clk or negedge resetN)
begin : fsm_sync_proc

	if (resetN == 1'b0) begin 
		SM_Motion <= IDLE_ST ; 
		Xspeed <= 0   ; 
		Yspeed <= 0  ; 
		Xposition <= 0  ; 
		Yposition <= 0   ; 
//		toggle_x_key_D <= 0 ;
		hit_reg <= 16'b0 ;	
	
	end 	
	
	else begin
	
//		toggle_x_key_D <= toggle_x_key ;  //shift register to detect edge 

	
		case(SM_Motion)
		
		//------------
			IDLE_ST: begin
		//------------
		
				Xspeed  <= INITIAL_X_SPEED ; 
				Yspeed  <= INITIAL_Y_SPEED; 
				Xposition <= INITIAL_X*FIXED_POINT_MULTIPLIER; 
				Yposition <= INITIAL_Y*FIXED_POINT_MULTIPLIER; 

				// if (startOfFrame && enable_sof)   if want to stop the smiley move
				if (startOfFrame) 
					SM_Motion <= MOVE_ST ;
 	
			end
	
		//------------
			MOVE_ST:  begin     // moving no colision 
		//------------
				if(keyIsPressed[4]) begin 
					mirrorLeft <= 1;
					if(Xposition > x_FRAME_LEFT)
						Xspeed <= -X_SPEED;
				end
				if(keyIsPressed[6]) begin
					mirrorLeft <= 0;
					if(Xposition < x_FRAME_RIGHT) begin
						Xspeed <= X_SPEED;
						bgMove = 0;
					end
					else begin
						Xspeed <= INITIAL_X_SPEED;
						bgMove = 1;
					end
				end
					
				if(keyIsPressed[8]) 
					Yspeed <= -Y_SPEED;
					
				if(keyIsPressed[2]) 
					Yspeed <= Y_SPEED;
					
				if((!keyIsPressed[4] && !keyIsPressed[6]) || (keyIsPressed[4] && keyIsPressed[6])) 
					Xspeed <= INITIAL_X_SPEED;	
				
				if((!keyIsPressed[2] && !keyIsPressed[8]) || (keyIsPressed[2] && keyIsPressed[8])) 
					Yspeed <= INITIAL_Y_SPEED;
				
	
       // collcting collisions 	
				if (collision) begin
					bgMove = 0;
					hit_reg <= hit_reg | HitEdgeCode;
					SM_Motion <= START_OF_FRAME_ST;

				end
				

				if (startOfFrame )
					SM_Motion <= POSITION_CHANGE_ST; 
					
					
				
		end 
		
		//------------
			START_OF_FRAME_ST:  begin      //check if any colisin was detected 
		//------------
		
//				case (hit_reg)
//				
//				16'h0000:  // no collision in the frame 
//					begin
//							Yspeed <= Yspeed ;
//							Xspeed <= Xspeed ;
//					end
//				//   CH       6H		3H         9H
//				16'h1000,16'h0040,16'h0008,16'h0200:	// one of the four corners 	
//
//				  begin
//							Yspeed <= 0 ;
//							Xspeed <= 0 ;
//					end
//			//   8H   ; (CH & 8H) ; (8H & 9H) ; (cH & 9H) ;(cH & 9H & 8H)   
//				16'h0100,16'h1100,16'h0300,16'h1200,16'h1300:  // left side 
//				  begin
//							if (Xspeed < 0)
//							  Xspeed <= 0 ;
//				  end
//				//  4H     (CH & 4H)  (4H & 6H) (CH & 6H)  (CH & 4H & 6H)
//				16'h0010,16'h1010,16'h0050, 16'h1040 , 16'h1050 : //  top side 
//				  begin 
//							if (Yspeed < 0)
//							  Yspeed <= 0 ;
//				  end
//				//   2H  (2H & 6H) (2H & 3H) (6H & 3H )  (6H & 2H &3H )
//				16'h0004,16'h0044,16'h000C, 16'h0048 , 16'h004C: // right side 
//				 begin
//								if (Xspeed > 0) begin
//									Xspeed <= 0 ;
//									//bgMove <= 0;
//								end
//			  end
//				//   1H  (1H & 9H) (1H & 3H) (3H & 9H ) (3H & 1H & 9H )
//				16'h00000002,16'h00000202,16'h0000000A, ,16'h00000028 ,16'h0000002A: // bottom side 
//				  begin
//							if (Yspeed > 0)
//							  Yspeed <= 0 ;
//				  end
//				 default:  //complex corner 
//				  begin
//							Yspeed <= Yspeed ;
//							Xspeed <= Xspeed ;
//					end
				 

//				 endcase
				
				if(hit_reg[0] == 1 && Yspeed > 0)
					Yspeed <= 0;
				
				if(hit_reg[1] == 1 && Xspeed > 0)
					Xspeed = 0;
				
				if(hit_reg[2] == 1 && Yspeed < 0)
					Yspeed <= 0;
				
				if(hit_reg[3] == 1 && Xspeed < 0)
					Xspeed = 0;
					
				hit_reg <= 4'b0;  //clear for next time 
				
				if(startOfFrame)
					SM_Motion <= POSITION_CHANGE_ST ; 
			end 

		//------------------------
			POSITION_CHANGE_ST : begin  // position interpolate 
		//------------------------
	
				Xposition <= Xposition + Xspeed; 
				Yposition <= Yposition + Yspeed;
			 
				// accelerate 
			
				if (Yspeed < MAX_Y_SPEED ) //  limit the speed while going down 
   				Yspeed <= Yspeed - Y_ACCEL ; // deAccelerate : slow the speed down every clock tick 
	
//				if ((Yspeed < MAX_Y_speed)&&(Yspeed >0 ))	
//					Yspeed <= Yspeed - Y_ACCEL ; // deAccelerate : slow the speed down every clock tick 
//	
//				else if ((Yspeed > (-MAX_Y_speed))&&(Yspeed < 0 ))
//					Yspeed <= Yspeed + Y_ACCEL ; // deAccelerate : slow the speed down every clock tick
					
				SM_Motion <= POSITION_LIMITS_ST ; 
			end
		
		//------------------------
			POSITION_LIMITS_ST : begin  //check if still inside the frame 
		//------------------------
		if (Xposition < x_FRAME_LEFT) 
						Xposition <= x_FRAME_LEFT ; 
		if (Xposition > x_FRAME_RIGHT)
						Xposition <= x_FRAME_RIGHT ; 
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
 
