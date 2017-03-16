`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:53:31 03/08/2017 
// Design Name: 
// Module Name:    GameControl 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description:    Control game flow and output text to display
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
////////////////////////////////////////////////////////////////////////////////
module GameControl(
    input reset,
    input [3:0] keyPress,
	input clk,
    output [160:0] txt
    );
    
	// state control
    reg [8:0] value  = 0;      // current value of game
    reg [2:0] state  = 3'b000; // state of FSM
    reg [1:0] nPlay  = 1;      // number of players (1 indexed)
    reg [1:0] player = 2'b01;  // whose turn it is  (1 indexed)
    
	// character control
    reg [3:0] firstDigit  = 0;
    reg [3:0] secondDigit = 0;
    reg [8:0] extraChar;
	reg [1:0] lastPlayer = 2'b01;
	
	// time control
	reg       keyClear    = 0;
	integer   count       = 0;
    
    // Initial text: "WELCOME. PLAYERS: "
    reg [160:0] text = " :SREYALP .EMOCLEW";
    assign      txt  = text;

    
    always @(posedge clk) begin
		count = count + 1;
		if (count == 12500000) begin
			keyClear = 1;
			count    = 0;
		end 
		
		if (keyClear == 1) begin
			// reset
			if (keyPress == 15) begin     
				state  = 3'b000;
				player = 2'b01;
				nPlay  = 1;
				value  = 0;
				text   = " :SREYALP .EMOCLEW";
			end else begin
				// everything else
				
				if (state == 0) begin
					
					// text = "STARTING VALUE: "
					if (keyPress == 1) begin
						nPlay  = 1;
						player = 1;
						state  = 1;
						text   = " :EULAV GNITRATS";
					end else if (keyPress == 2) begin
						nPlay  = 2;
						player = 1;
						state  = 1;
						text   = " :EULAV GNITRATS";
					end else if (keyPress == 3) begin
						nPlay  = 3;
						player = 1;
						state  = 1;
						text   = " :EULAV GNITRATS";
					end
					
					
				end else if (state == 1) begin
					// text = "STARTING VALUE: [firstDigit]"
					
					if (keyPress >= 1 && keyPress <= 9) begin
						firstDigit = keyPress;
						text       = "  :EULAV GNITRATS";
						text[135:128] = 48 + firstDigit; 
						state         = 2;
					end
					
					
				end else if (state == 2) begin
					// text = "A: Value ##"
					
					if (keyPress >= 0 && keyPress <= 9) begin
						secondDigit = keyPress;
						value = firstDigit*10 + secondDigit;
						state = 3;
						text = "   EULAV :A";
						text[87:80] = 48 + secondDigit;
						text[79:72] = 48 + firstDigit;
					end
					
					
				end else if (state == 3) begin
					
					// text = "[A, B, C]: Value ##"
					if (keyPress >= 1 && keyPress <= 3) begin
						if (nPlay == 2) begin
							case (player)
								1: player = 2;
								2: player = 1;
								default: player = 1;
							endcase
						end else if (nPlay == 3) begin
							case (player)
								1: player = 2;
								2: player = 3;
								3: player = 1;
								default: player = 1;
							endcase
						end
						
						case (player)
							1: extraChar = "A";
							2: extraChar = "B";
							3: extraChar = "C";
							default: extraChar = "A";
						endcase
						if (value == 1) begin
							value = 0;
						end
						else begin
							value   = value - keyPress;
					    end
						firstDigit  = value/10;
						secondDigit = value%10;
						text = "   EULAV :A";
						text[87:80] = 48 + secondDigit;
						text[79:72] = 48 + firstDigit;
						text[7:0]   = extraChar;
					end 
					
					if (value <= 0) begin
						state = 4;
						value = 0;
						// text = "PLAYER [A, B, C] WON."
						case (lastPlayer)
							1: text = ".NOW A REYALP";
							2: text = ".NOW B REYALP";
							3: text = ".NOW C REYALP";
							default: text = ".NOW YDOBON";
						endcase
					end
					lastPlayer = player;
				end
			end
		end
		keyClear = 0;
    end


endmodule
