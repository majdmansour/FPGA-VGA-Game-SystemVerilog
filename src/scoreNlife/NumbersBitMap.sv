// coding convention dudy December 2018
// (c) Technion IIT, Department of Electrical Engineering 2021
// generating a number bitmap 



module NumbersBitMap	(	

					input	logic	clk,
					input	logic	resetN,
					input logic	[10:0] offsetX,// offset from top left  position 
					input logic	[10:0] offsetY,
					input	logic	InsideRectangle, //input that the pixel is within a bracket 
					input logic	[3:0] digit, // digit to display
					
					output	logic	drawingRequest, //output that the pixel should be dispalyed 
					output	logic	[7:0]	RGBout
);

localparam logic [7:0] TRANSPARENT_ENCODING = 8'hff ;// RGB value in the bitmap representing a transparent pixel  

logic[0:9][0:15][0:15][7:0] numbers_bitmap = {
	//0
	{{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'h00,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'h00,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff}
	},//1
	{{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'h00,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'hc0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'hc0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'hc0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff}
	},//2													
	{{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h6d,8'h00,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h64,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hb0,8'h91,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hb0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff}
	},//3														
	{{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'h24,8'h00,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h30,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h91,8'h30,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h34,8'h34,8'h34,8'h34,8'h34,8'h34,8'h78,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h38,8'h38,8'h38,8'h38,8'h38,8'h38,8'h78,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h91,8'h30,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h30,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'h91,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h04,8'h00,8'hb6,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff}
	},//4
	{{8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'h00,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h12,8'h12,8'h12,8'h12,8'h12,8'h12,8'h16,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff}
	},//5													
	{{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h04,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'h00,8'hda,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff,8'hff}
	},//6
	{{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'h00,8'h00,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'h00,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'h00,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'h00,8'h00,8'h00,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'he0,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff}
	}, //7																
	{{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'hfc,8'hfc,8'hfc,8'hfc,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff}
	}, //8												
	{{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h00,8'h00,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h00,8'h00,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h34,8'h34,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h00,8'h00,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h00,8'h00,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h78,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff}
	}, //9		
	{{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'h00,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h16,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h17,8'h00,8'hff,8'hff},
	{8'hff,8'hff,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'h00,8'hff,8'hff}}
}; 
																	
	


// pipeline (ff) to get the pixel color from the array 	 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
		RGBout <=	8'h00; 
	end
	else begin
		RGBout <= TRANSPARENT_ENCODING ; // default  
	
		if (InsideRectangle == 1'b1) begin
			RGBout <= (numbers_bitmap[digit][offsetY][offsetX]);	//get value from bitmap  
		end
	end 
end

assign drawingRequest = (RGBout != TRANSPARENT_ENCODING ) ? 1'b1 : 1'b0 ; // get optional transparent command from the bitmpap   

endmodule