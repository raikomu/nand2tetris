// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// Put your code here.
  // for counting screen blocks
  @BLOCK
  M=0
(LOOP)
  // Go to BLACKEN if KBD=1
  @KBD
  D=M
  @BLACKEN
  D;JGT

  // Go to CLEAR otherwise
  @CLEAR
  D;JMP
(BLACKEN)
  @BLOCK
  D=M

  // Select the current screen block and blacken it by setting value to -1 (111111111111111)
  @SCREEN
  A=A+D
  M=-1

  // Immediately jump to LOOP if screen is fully blackened (last screen block was selected)
  D=A
  @24575
  D=A-D
  @LOOP
  D;JEQ

  // Otherwise increase screen block counter by 1 and jump to LOOP
  @BLOCK
  M=M+1
  @LOOP
  0;JMP
(CLEAR)
  @BLOCK
  D=M

  // Select the current screen block and clear it by setting value to 0
  @SCREEN
  A=A+D
  M=0

  // Immediately jump to LOOP if screen is fully cleared (first screen block was selected)
  D=A
  @SCREEN
  D=A-D
  @LOOP
  D;JEQ

  // Otherwise decrease screen block counter by one and jump to LOOP
  @BLOCK
  M=M-1
  @LOOP
  0;JMP
