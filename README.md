# Nim
This is a Verilog project for programming a version of the subtraction game on an FPGA. Specifically, this was created on the Nexys 3 by Digilent.

The basics of this game may be found at https://en.wikipedia.org/wiki/Nim. This version was adapted to allow 1, 2, or 3 players. On each player's turn, he or she may subtract 1, 2, or 3 from the current value. The player to reach 0 wins.

This implementation utilizes a keypad for input and VGA for output. The VGA module (Displayylmao.v) has its own font ROM. It accepts up to 18 characters of text as an input and displays the text in the center of the output. It is easily modified.

It was created by Micah Cliffe (https://github.com/minterm) and Alex Waz (https://github.com/alexmwaz).
