// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.
  // Initialize result as 0
  @res
  M=0
(LOOP)

  // Stop and return result if R0 is 0
  @R0
  D=M
  @STOP
  D;JEQ

  // Stop and return result if R1 is 0
  @R1
  D=M
  @STOP
  D;JEQ

  // Add R0 to result
  @R0
  D=M
  @res
  M=M+D

  // Stop and return result if R1-1 = 0
  @R1
  D=M-1
  @STOP
  D;JEQ

  // Subtract 1 from R1 for next run
  @R1
  M=D

  // Unconditional jump
  @LOOP
  0;JMP
(STOP)
  // Store result in R2
  @res
  D=M
  @R2
  M=D
(END)
  @END
  0;JMP
