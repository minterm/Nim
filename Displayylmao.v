`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company:  Swag L0rds Inc.
// Engineer: Ghandi
//
// Create Date:    12:15:03 02/27/2017
// Design Name:    Pretty
// Module Name:    Displayylmao
// Project Name:   Nim
// Target Devices: Nexys 3
// Tool versions:  0
// Description:    Display th game
//
// Dependencies:   Friends
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
////////////////////////////////////////////////////////////////////////////////
module Displayylmao(
	input wire dclk,         //pixel clock: 25MHz
	input wire [160:0] text, // string to display. 20 character max
	output wire hsync,	 //horizontal sync out
	output wire vsync,	 //vertical sync out
	output reg [2:0] red,	 //red vga output
	output reg [2:0] green,  //green vga output
	output reg [1:0] blue	 //blue vga output
	);

	// video structure constants
	parameter hpixels = 800; // horizontal pixels per line
	parameter vlines = 521;  // vertical lines per frame
	parameter hpulse = 96; 	 // hsync pulse length
	parameter vpulse = 2; 	 // vsync pulse length
	parameter hbp = 144; 	 // end of horizontal back porch
	parameter hfp = 784; 	 // beginning of horizontal front porch
	parameter vbp = 31; 	 // end of vertical back porch
	parameter vfp = 511; 	 // beginning of vertical front porch
	// active horizontal video is therefore: 784 - 144 = 640
	// active vertical video is therefore:   511 -  31 = 480

    parameter block_h      = 48;  // height of 1 character block
    parameter block_w      = 32;  // width of 1 character block
    parameter origin_top   = 192; //4*block_h;
    parameter origin_bot   = 240; //5*block_h;
    parameter origin_left  = 32;  // block_w
    parameter origin_right = 608; // 19*block_w

	// registers for storing the horizontal & vertical counters
	reg [9:0] hc;
	reg [9:0] vc;

    reg [9:0] rh;
    reg [9:0] rv;
    reg [9:0] nh;
    reg [9:0] nv;
    // LUNA IS THE BEST

	// Horizontal & vertical counters --
	// this is how we keep track of where we are on the screen.
	// ------------------------
	// Sequential "always block", which is a block that is
	// only triggered on signal transitions or "edges".
	// posedge = rising edge  &  negedge = falling edge
	// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
	always @(posedge dclk)
	begin

		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end

	end

	// generate sync pulses (active low)
	// ----------------
	// "assign" statements are a quick way to
	// give values to variables of type: wire
	assign hsync = (hc < hpulse) ? 0:1;
	assign vsync = (vc < vpulse) ? 0:1;

	// display 100% saturation colorbars
	// ------------------------
	// Combinational "always block", which is a block that is
	// triggered when anything in the "sensitivity list" changes.
	// The asterisk implies that everything that is capable of triggering the block
	// is automatically included in the sensitivty list.  In this case, it would be
	// equivalent to the following: always @(hc, vc)
	// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
	always @(*)
	begin
		// first check if we're within vertical active video range

        // Iterate through every block
        if (vc >= vbp && vc < vfp && hc >= hbp && hc < hfp) begin
            // Outside of character bar
            if (vc < (vbp + origin_top) || vc >= (vbp + origin_bot) ||
                hc < (hbp + origin_left) || hc >= (hbp + origin_right)) begin
                red   = 3'b000;
                green = 3'b000;
                blue  = 2'b11;
            end
            // Go through each character
            else if (hc >= (hbp + origin_left) &&
                     hc < (hbp + origin_left + block_w)) begin
                // Character 0
                rh = hc - (hbp + origin_left);
                rv = vc - (vbp + origin_top);
                charDisp(text[7:0], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + block_w) &&
                         hc < (hbp + origin_left + 2*block_w)) begin
                // Character 1
                rh = hc - (hbp + origin_left + block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*1 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 2*block_w) &&
                         hc < (hbp + origin_left + 3*block_w)) begin
                // Character 2
                rh = hc - (hbp + origin_left + 2*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*2 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 3*block_w) &&
                         hc < (hbp + origin_left + 4*block_w)) begin
                // Character 3
                rh = hc - (hbp + origin_left + 3*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*3 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 4*block_w) &&
                         hc < (hbp + origin_left + 5*block_w)) begin
                // Character 4
                rh = hc - (hbp + origin_left + 4*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*4 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 5*block_w) &&
                         hc < (hbp + origin_left + 6*block_w)) begin
                // Character 5
                rh = hc - (hbp + origin_left + 5*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*5 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 6*block_w) &&
                         hc < (hbp + origin_left + 7*block_w)) begin
                // Character 6
                rh = hc - (hbp + origin_left + 6*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*6 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 7*block_w) &&
                         hc < (hbp + origin_left + 8*block_w)) begin
                // Character 7
                rh = hc - (hbp + origin_left + 7*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*7 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 8*block_w) &&
                         hc < (hbp + origin_left + 9*block_w)) begin
                // Character 8
                rh = hc - (hbp + origin_left + 8*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*8 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 9*block_w) &&
                         hc < (hbp + origin_left + 10*block_w)) begin
                // Character 9
                rh = hc - (hbp + origin_left + 9*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*9 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 10*block_w) &&
                         hc < (hbp + origin_left + 11*block_w)) begin
                // Character 10
                rh = hc - (hbp + origin_left + 10*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*10 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 11*block_w) &&
                         hc < (hbp + origin_left + 12*block_w)) begin
                // Character 11
                rh = hc - (hbp + origin_left + 11*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*11 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 12*block_w) &&
                         hc < (hbp + origin_left + 13*block_w)) begin
                // Character 12
                rh = hc - (hbp + origin_left + 12*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*12 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 13*block_w) &&
                         hc < (hbp + origin_left + 14*block_w)) begin
                // Character 13
                rh = hc - (hbp + origin_left + 13*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*13 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 14*block_w) &&
                         hc < (hbp + origin_left + 15*block_w)) begin
                // Character 14
                rh = hc - (hbp + origin_left + 14*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*14 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 15*block_w) &&
                         hc < (hbp + origin_left + 16*block_w)) begin
                // Character 15
                rh = hc - (hbp + origin_left + 15*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*15 +: 8], rh, rv, red, green, blue);
            end else if (hc >= (hbp + origin_left + 16*block_w) &&
                         hc < (hbp + origin_left + 17*block_w)) begin
                // Character 16
                rh = hc - (hbp + origin_left + 16*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*16 +: 8], rh, rv, red, green, blue);
            end else begin//if (hc >= (hbp + origin_left + 17*block_w) &&
                          //    hc < (hbp + origin_left + 18*block_w)) begin
                // Character 17
                rh = hc - (hbp + origin_left + 17*block_w);
                rv = vc - (vbp + origin_top);
                charDisp(text[8*17 +: 8], rh, rv, red, green, blue);
            end

        end else begin
            red   = 0;
            green = 0;
            blue  = 0;
        end

	end

    task charDisp;
    input[8:0] char;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        // Given relative positions
        // 32 wide by 48 high
        
        case(char)
            "A": A_(rh, rv, r, g, b);
            "B": B_(rh, rv, r, g, b);
            "C": C_(rh, rv, r, g, b);
            "D": D_(rh, rv, r, g, b);
            "E": E_(rh, rv, r, g, b);
            "F": F_(rh, rv, r, g, b);
            "G": G_(rh, rv, r, g, b);
            "H": H_(rh, rv, r, g, b);
            "I": I_(rh, rv, r, g, b);
            "J": J_(rh, rv, r, g, b);
            "K": K_(rh, rv, r, g, b);
            "L": L_(rh, rv, r, g, b);
            "M": M_(rh, rv, r, g, b);
            "N": N_(rh, rv, r, g, b);
            "O": O_(rh, rv, r, g, b);
            "P": P_(rh, rv, r, g, b);
            "Q": Q_(rh, rv, r, g, b);
            "R": R_(rh, rv, r, g, b);
            "S": S_(rh, rv, r, g, b);
            "T": T_(rh, rv, r, g, b);
            "U": U_(rh, rv, r, g, b);
            "V": V_(rh, rv, r, g, b);
            "W": W_(rh, rv, r, g, b);
            "X": X_(rh, rv, r, g, b);
            "Y": Y_(rh, rv, r, g, b);
            "Z": Z_(rh, rv, r, g, b);
            "0": Zero(rh, rv, r, g, b);
            "1": One(rh, rv, r, g, b);
            "2": Two(rh, rv, r, g, b);
            "3": Three(rh, rv, r, g, b);
            "4": Four(rh, rv, r, g, b);
            "5": Five(rh, rv, r, g, b);
            "6": Six(rh, rv, r, g, b);
            "7": Seven(rh, rv, r, g, b);
            "8": Eight(rh, rv, r, g, b);
            "9": Nine(rh, rv, r, g, b);
            ":": Colon(rh, rv, r, g, b); // colon
            default: // space
            begin
                r = 0;
                b = 0;
                g = 0;
            end
        endcase
	end
	endtask

    // Letter A
    wire [0:3] letter_A[0:5];
    assign letter_A[0] = 4'b0100;
    assign letter_A[1] = 4'b1010;
    assign letter_A[2] = 4'b1010;
    assign letter_A[3] = 4'b1110;
    assign letter_A[4] = 4'b1010;
    assign letter_A[5] = 4'b1010;

    task A_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_A[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter B
	wire [0:3] letter_B [0:5];
	assign letter_B[0] = 4'b1100;
	assign letter_B[1] = 4'b1010;
	assign letter_B[2] = 4'b1100;
	assign letter_B[3] = 4'b1010;
	assign letter_B[4] = 4'b1010;
	assign letter_B[5] = 4'b1100;

    task B_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_B[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter C
	wire [0:3] letter_C [0:5];
	assign letter_C[0] = 4'b0110;
	assign letter_C[1] = 4'b1000;
	assign letter_C[2] = 4'b1000;
	assign letter_C[3] = 4'b1000;
	assign letter_C[4] = 4'b1000;
	assign letter_C[5] = 4'b0110;

    task C_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_C[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter D
	wire [0:3] letter_D [0:5];
	assign letter_D[0] = 4'b1100;
	assign letter_D[1] = 4'b1010;
	assign letter_D[2] = 4'b1010;
	assign letter_D[3] = 4'b1010;
	assign letter_D[4] = 4'b1010;
	assign letter_D[5] = 4'b1100;

    task D_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_D[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter E
	wire [0:3] letter_E [0:5];
	assign letter_E[0] = 4'b1110;
	assign letter_E[1] = 4'b1000;
	assign letter_E[2] = 4'b1110;
	assign letter_E[3] = 4'b1000;
	assign letter_E[4] = 4'b1000;
	assign letter_E[5] = 4'b1110;

    task E_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_E[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter F
	wire [0:3] letter_F [0:5];
	assign letter_F[0] = 4'b1110;
	assign letter_F[1] = 4'b1000;
	assign letter_F[2] = 4'b1110;
	assign letter_F[3] = 4'b1000;
	assign letter_F[4] = 4'b1000;
	assign letter_F[5] = 4'b1000;

    task F_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_F[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter G
	wire [0:3] letter_G [0:5];
	assign letter_G[0] = 4'b0110;
	assign letter_G[1] = 4'b1000;
	assign letter_G[2] = 4'b1000;
	assign letter_G[3] = 4'b1010;
	assign letter_G[4] = 4'b1010;
	assign letter_G[5] = 4'b0110;

    task G_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_G[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask


	// Letter H
	wire [0:3] letter_H [0:5];
	assign letter_H[0] = 4'b1010;
	assign letter_H[1] = 4'b1010;
	assign letter_H[2] = 4'b1110;
	assign letter_H[3] = 4'b1010;
	assign letter_H[4] = 4'b1010;
	assign letter_H[5] = 4'b1010;

    task H_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_H[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter I
	wire [0:3] letter_I [0:5];
	assign letter_I[0] = 4'b1110;
	assign letter_I[1] = 4'b0100;
	assign letter_I[2] = 4'b0100;
	assign letter_I[3] = 4'b0100;
	assign letter_I[4] = 4'b0100;
	assign letter_I[5] = 4'b1110;

    task I_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_I[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter J
	wire [0:3] letter_J [0:5];
	assign letter_J[0] = 4'b0110;
	assign letter_J[1] = 4'b0010;
	assign letter_J[2] = 4'b0010;
	assign letter_J[3] = 4'b0010;
	assign letter_J[4] = 4'b1010;
	assign letter_J[5] = 4'b0100;

    task J_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_J[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter K
	wire [0:3] letter_K [0:5];
	assign letter_K[0] = 4'b1000;
	assign letter_K[1] = 4'b1010;
	assign letter_K[2] = 4'b1100;
	assign letter_K[3] = 4'b1010;
	assign letter_K[4] = 4'b1010;
	assign letter_K[5] = 4'b1010;

    task K_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_K[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter L
	wire [0:3] letter_L [0:5];
	assign letter_L[0] = 4'b1000;
	assign letter_L[1] = 4'b1000;
	assign letter_L[2] = 4'b1000;
	assign letter_L[3] = 4'b1000;
	assign letter_L[4] = 4'b1000;
	assign letter_L[5] = 4'b1110;

    task L_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_L[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter M
	wire [0:3] letter_M [0:5];
	assign letter_M[0] = 4'b1100;
	assign letter_M[1] = 4'b1110;
	assign letter_M[2] = 4'b1110;
	assign letter_M[3] = 4'b1010;
	assign letter_M[4] = 4'b1010;
	assign letter_M[5] = 4'b1010;

    task M_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_M[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter N
	wire [0:3] letter_N [0:5];
	assign letter_N[0] = 4'b1100;
	assign letter_N[1] = 4'b1010;
	assign letter_N[2] = 4'b1010;
	assign letter_N[3] = 4'b1010;
	assign letter_N[4] = 4'b1010;
	assign letter_N[5] = 4'b1010;

    task N_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_N[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter O
	wire [0:3] letter_O [0:5];
	assign letter_O[0] = 4'b0100;
	assign letter_O[1] = 4'b1010;
	assign letter_O[2] = 4'b1010;
	assign letter_O[3] = 4'b1010;
	assign letter_O[4] = 4'b1010;
	assign letter_O[5] = 4'b0100;

    task O_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_O[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter P
	wire [0:3] letter_P [0:5];
	assign letter_P[0] = 4'b1100;
	assign letter_P[1] = 4'b1010;
	assign letter_P[2] = 4'b1010;
	assign letter_P[3] = 4'b1100;
	assign letter_P[4] = 4'b1000;
	assign letter_P[5] = 4'b1000;

    task P_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_P[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter Q
	wire [0:3] letter_Q [0:5];
	assign letter_Q[0] = 4'b0100;
	assign letter_Q[1] = 4'b1010;
	assign letter_Q[2] = 4'b1010;
	assign letter_Q[3] = 4'b1010;
	assign letter_Q[4] = 4'b1010;
	assign letter_Q[5] = 4'b0111;

    task Q_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_Q[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter R
	wire [0:3] letter_R [0:5];
	assign letter_R[0] = 4'b1100;
	assign letter_R[1] = 4'b1010;
	assign letter_R[2] = 4'b1010;
	assign letter_R[3] = 4'b1100;
	assign letter_R[4] = 4'b1010;
	assign letter_R[5] = 4'b1010;

    task R_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_R[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter S
	wire [0:3] letter_S [0:5];
	assign letter_S[0] = 4'b0110;
	assign letter_S[1] = 4'b1000;
	assign letter_S[2] = 4'b1100;
	assign letter_S[3] = 4'b0010;
	assign letter_S[4] = 4'b0010;
	assign letter_S[5] = 4'b1100;

    task S_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_S[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter T
	wire [0:3] letter_T [0:5];
	assign letter_T[0] = 4'b1110;
	assign letter_T[1] = 4'b0100;
	assign letter_T[2] = 4'b0100;
	assign letter_T[3] = 4'b0100;
	assign letter_T[4] = 4'b0100;
	assign letter_T[5] = 4'b0100;

    task T_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_T[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter U
	wire [0:3] letter_U [0:5];
	assign letter_U[0] = 4'b1010;
	assign letter_U[1] = 4'b1010;
	assign letter_U[2] = 4'b1010;
	assign letter_U[3] = 4'b1010;
	assign letter_U[4] = 4'b1010;
	assign letter_U[5] = 4'b1110;

    task U_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_U[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter V
	wire [0:3] letter_V [0:5];
	assign letter_V[0] = 4'b1010;
	assign letter_V[1] = 4'b1010;
	assign letter_V[2] = 4'b1010;
	assign letter_V[3] = 4'b1010;
	assign letter_V[4] = 4'b1010;
	assign letter_V[5] = 4'b0100;

    task V_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_V[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter W
	wire [0:3] letter_W [0:5];
	assign letter_W[0] = 4'b1010;
	assign letter_W[1] = 4'b1010;
	assign letter_W[2] = 4'b1010;
	assign letter_W[3] = 4'b1110;
	assign letter_W[4] = 4'b1110;
	assign letter_W[5] = 4'b1110;

    task W_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_W[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter X
	wire [0:3] letter_X [0:5];
	assign letter_X[0] = 4'b1010;
	assign letter_X[1] = 4'b1010;
	assign letter_X[2] = 4'b1010;
	assign letter_X[3] = 4'b0100;
	assign letter_X[4] = 4'b1010;
	assign letter_X[5] = 4'b1010;

    task X_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_X[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter Y
	wire [0:3] letter_Y [0:5];
	assign letter_Y[0] = 4'b1010;
	assign letter_Y[1] = 4'b1010;
	assign letter_Y[2] = 4'b1010;
	assign letter_Y[3] = 4'b0100;
	assign letter_Y[4] = 4'b0100;
	assign letter_Y[5] = 4'b0100;

    task Y_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_Y[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Letter Z
	wire [0:3] letter_Z [0:5];
	assign letter_Z[0] = 4'b1110;
	assign letter_Z[1] = 4'b0010;
	assign letter_Z[2] = 4'b0100;
	assign letter_Z[3] = 4'b1000;
	assign letter_Z[4] = 4'b1000;
	assign letter_Z[5] = 4'b1110;

    task Z_;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (letter_Z[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Zero
	wire [0:3] num_Zero [0:5];
	assign num_Zero[0] = 4'b0000;
	assign num_Zero[1] = 4'b1110;
	assign num_Zero[2] = 4'b1010;
	assign num_Zero[3] = 4'b1010;
	assign num_Zero[4] = 4'b1010;
	assign num_Zero[5] = 4'b1110;

    task Zero;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Zero[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number One
	wire [0:3] num_One [0:5];
	assign num_One[0] = 4'b0000;
	assign num_One[1] = 4'b1100;
	assign num_One[2] = 4'b0100;
	assign num_One[3] = 4'b0100;
	assign num_One[4] = 4'b0100;
	assign num_One[5] = 4'b1110;

    task One;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_One[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Two
	wire [0:3] num_Two [0:5];
	assign num_Two[0] = 4'b0000;
	assign num_Two[1] = 4'b1110;
	assign num_Two[2] = 4'b0010;
	assign num_Two[3] = 4'b1110;
	assign num_Two[4] = 4'b1000;
	assign num_Two[5] = 4'b1110;

    task Two;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Two[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Three
	wire [0:3] num_Three [0:5];
	assign num_Three[0] = 4'b0000;
	assign num_Three[1] = 4'b1110;
	assign num_Three[2] = 4'b0010;
	assign num_Three[3] = 4'b1110;
	assign num_Three[4] = 4'b0010;
	assign num_Three[5] = 4'b1110;

    task Three;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Three[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Four
	wire [0:3] num_Four [0:5];
	assign num_Four[0] = 4'b0000;
	assign num_Four[1] = 4'b1010;
	assign num_Four[2] = 4'b1010;
	assign num_Four[3] = 4'b1110;
	assign num_Four[4] = 4'b0010;
	assign num_Four[5] = 4'b0010;

    task Four;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Four[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Five
	wire [0:3] num_Five [0:5];
	assign num_Five[0] = 4'b0000;
	assign num_Five[1] = 4'b1110;
	assign num_Five[2] = 4'b1000;
	assign num_Five[3] = 4'b1110;
	assign num_Five[4] = 4'b0010;
	assign num_Five[5] = 4'b1110;

    task Five;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Five[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Six
	wire [0:3] num_Six [0:5];
	assign num_Six[0] = 4'b0000;
	assign num_Six[1] = 4'b1110;
	assign num_Six[2] = 4'b1000;
	assign num_Six[3] = 4'b1110;
	assign num_Six[4] = 4'b1010;
	assign num_Six[5] = 4'b1110;

    task Six;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Six[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Seven
	wire [0:3] num_Seven [0:5];
	assign num_Seven[0] = 4'b0000;
	assign num_Seven[1] = 4'b1110;
	assign num_Seven[2] = 4'b0010;
	assign num_Seven[3] = 4'b0010;
	assign num_Seven[4] = 4'b0010;
	assign num_Seven[5] = 4'b0010;

    task Seven;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Seven[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Eight
	wire [0:3] num_Eight [0:5];
	assign num_Eight[0] = 4'b0000;
	assign num_Eight[1] = 4'b1110;
	assign num_Eight[2] = 4'b1010;
	assign num_Eight[3] = 4'b1110;
	assign num_Eight[4] = 4'b1010;
	assign num_Eight[5] = 4'b1110;

    task Eight;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Eight[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Number Nine
	wire [0:3] num_Nine [0:5];
	assign num_Nine[0] = 4'b0000;
	assign num_Nine[1] = 4'b1110;
	assign num_Nine[2] = 4'b1010;
	assign num_Nine[3] = 4'b1110;
	assign num_Nine[4] = 4'b0010;
	assign num_Nine[5] = 4'b1110;

    task Nine;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (num_Nine[nv][nh] == 1) begin
            r = 3'b000;
            g = 3'b100;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

	// Symbol Colon
	wire [0:3] sym_Colon [0:5];
	assign sym_Colon[0] = 4'b0000;
	assign sym_Colon[1] = 4'b1100;
	assign sym_Colon[2] = 4'b1100;
	assign sym_Colon[3] = 4'b0000;
	assign sym_Colon[4] = 4'b1100;
	assign sym_Colon[5] = 4'b1100;

    task Colon;
    input[9:0] rh;
    input[9:0] rv;
    output[2:0] r;
    output[2:0] g;
    output[1:0] b;
	begin
        nh = rh >> 3;
        nv = rv >> 3;
        if (sym_Colon[nv][nh] == 1) begin
            r = 3'b100;
            g = 3'b000;
            b = 2'b00;
        end else begin
            r = 0;
            g = 0;
            b = 0;
        end
	end
	endtask

endmodule
