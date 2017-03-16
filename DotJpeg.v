`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company:  Swag L0rds Inc.
// Engineer: Ghandi
// 
// Create Date:    12:13:04 02/27/2017 
// Design Name:    Pretty
// Module Name:    DotJpeg 
// Project Name:   Nim
// Target Devices: Nexys 3
// Tool versions:  0
// Description:    Play th game
//
// Dependencies:   Friends
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
////////////////////////////////////////////////////////////////////////////////

// This is the tippiest toppiest level bruhh
module DotJpeg(
    input wire clk,
    input wire Rst,            // unused
    inout [7:0] JA,
    output wire [2:0] vgaRed,   //red vga output - 3 bits
    output wire [2:0] vgaGreen, //green vga output - 3 bits
    output wire [1:0] vgaBlue,  //blue vga output - 2 bits
    output wire Hsync,	        //horizontal sync out
    output wire Vsync	        //vertical sync out
    );
    
    wire dclk;
    wire Rst_d;
    wire [3:0] key;
    wire [160:0] text;
    
    PespsiCola PC (
        .clk(clk),
        .dclk(dclk)
    );
    
    
    // keypad input
    Decoder KeyPad(
		.clk(dclk),
		.Row(JA[7:4]),
		.Col(JA[3:0]),
		.DecodeOut(key)
	);
    
    // game logic controller
    GameControl GC(
        .reset(Rst_d),
        .keyPress(key),
		.clk(dclk),
        .txt(text)
    );
    
    // VGA controller
    Displayylmao VGA(
        .dclk(dclk),
        .text(text),
        .hsync(Hsync),
        .vsync(Vsync),
        .red(vgaRed),
        .green(vgaGreen),
        .blue(vgaBlue)
	);
endmodule
