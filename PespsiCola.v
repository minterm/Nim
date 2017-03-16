`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company:  $w@gL0rds Inc.
// Engineer: Ghandi
// 
// Create Date:    13:18:44 02/27/2017 
// Design Name:    Pretty
// Module Name:    PespsiCola 
// Project Name:   Nim
// Target Devices: Nexys 3
// Tool versions:  0
// Description:    Play th Game
//
// Dependencies:   Friends
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
////////////////////////////////////////////////////////////////////////////////
module PespsiCola(
	input wire clk,		//master clock: 100MHz
	output wire dclk		//pixel clock: 25MHz
	);

	// 17-bit counter variable
	reg [16:0] q;
	
	// Clock divider --
	// Each bit in q is a clock signal that is
	// only a fraction of the master clock.
	always @(posedge clk)
	begin
		q <= q + 1;
	end
	
	// 50Mhz ÷ 2^17 = 381.47Hz
	assign segclk = q[16];
	
	// 100Mhz ÷ 2^2 = 25MHz
	assign dclk = q[1];

endmodule
