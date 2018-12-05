HEX_ALPHABET:		DC.B		'0',0,'1',0,'2',0,'3',0,'4',0,'5',0,'6',0,'7',0,'8',0,'9',0,'A',0,'B',0,'C',0,'D',0,'E',0,'F',0

*-----------------------------------------------------------------
* WRITEHEX_
* Write a full 32-bit hexadecimal string given in A0
*
* INPUTS
* D0 - Amount of letters to print
* A0 - Register to output
*
* REGISTER USE
* D7 - Store value of output
* D6 - Tracks which bit we are on
* D5 - Stores current letter
* D4 - Stores mask
* D3 - Temporary Swap Register
*-----------------------------------------------------------------					
WRITEHEX:			MOVEM.L		D0-D7/A0,-(SP)				; Save registers
					
					MOVE.L		A0,D7
					MOVE.L		#0,D6
					
					; Calculate the mask
					
					MOVE.L		#$F0000000,D4				; Initialize mask
					
					MOVE.B		D0,D3						; Save original value of D0
					
.SHIFT_MASK:		CMPI.B		#8,D0						; Check if done iterating
					BEQ			.CHAR_START

					LSR.L		#4,D4						; Shift the F right 4-bits
					ADDQ		#1,D0						; Subtract amount of iterations left
					BRA			.SHIFT_MASK					; Go back to start of loop					
					
					; Start of letter by letter loop

.CHAR_START:		MOVE.B		D3,D0						; Restore original value of D0

					CMP.L		D3,D6						; D3 holds length to write, check with D6 to see ...
					BEQ			.END						; ... if we are at nth hex char then quit (0 indexed)
					
					MOVE.L		D7,D5						; Copy over current buffer 
					AND.L		D4,D5						; Get current character 

.ALIGN_RIGHT:		CMPI.B		#1,D0
					BEQ			.ALIGN_END					; Letter is aligned at 1st spot, exit loop
					
					LSR.L		#4,D5						; Rotate the letter right 4 bits
					SUBQ		#1,D0						; Subtract 1 from iteration count
					BRA			.ALIGN_RIGHT				; Go back to start of loop
					
					; Print out letter in D5																 
					
.ALIGN_END:			LEA			HEX_ALPHABET,A1				; Load hexadecimal alphabet address into A1
					MULU.W		#2,D5						; Multiply D5 by 2 because each letter in the alphabet has itself and 0
					ADD.L		D5,A1						; Add that to the starting address
					MOVE.L		#1,D0						; Use Task 1
					MOVE.L		#2,D1						; Display 2 bytes (1st byte is letter, 2nd is null terminator)
					TRAP		#15							; Run Trap 15
					
					LSL.L		#4,D7						; Shift buffer left 4-bits (hexadecimal char)
					ADDQ		#1,D6						; Increment D6 (amount of bits displayed)
					
					BRA			.CHAR_START
	  
					; Done writing string

.END:				MOVEM.L		(SP)+,D0-D7/A0				; Restore registers
					RTS
					
*-----------------------------------------------------------------
* WRITEHEX_TRIM
* Write a 32-bit hexadecimal string given in A0 with no leading 0s
*
* INPUTS
* D0 - Amount of letters to print
* A0 - Register to output
*
* REGISTER USE
* D7 - Store value of output
* D6 - Tracks which bit we are on
* D5 - Stores current letter
* D4 - Stores mask
* D3 - Temporary Swap Register
* D2 - Holds boolean true or false if we've hit a non-zero letter
*-----------------------------------------------------------------
WRITEHEX_TRIM:		MOVEM.L		D0-D7/A0,-(SP)				; Save registers
					
					MOVE.L		A0,D7
					MOVE.L		#0,D6
					MOVE.L		#0,D2						; Set D2 to false (haven't printed a non-zero character yet)
					
					; Calculate the mask
					
					MOVE.L		#$F0000000,D4				; Initialize mask
					
					MOVE.B		D0,D3						; Save original value of D0
					
.SHIFT_MASK:		CMPI.B		#8,D0						; Check if done iterating
					BEQ			.CHAR_START

					LSR.L		#4,D4						; Shift the F right 4-bits
					ADDQ		#1,D0						; Subtract amount of iterations left
					BRA			.SHIFT_MASK					; Go back to start of loop	

					; Start of letter by letter loop

.CHAR_START:		MOVE.B		D3,D0						; Restore original value of D0

					CMP.L		D3,D6						; D3 holds length to write, check with D6 to see ...
					BEQ			.END						; ... if we are at nth hex char then quit (0 indexed)
					
					MOVE.L		D7,D5						; Copy over current buffer 
					AND.L		D4,D5						; Get current character 

.ALIGN_RIGHT:		CMPI.B		#1,D0
					BEQ			.ALIGN_END					; Letter is aligned at 1st spot, exit loop
					
					LSR.L		#4,D5						; Rotate the letter right 4 bits
					SUBQ		#1,D0						; Subtract 1 from iteration count
					BRA			.ALIGN_RIGHT				; Go back to start of loop
					
					; Print out letter in D5																 					
					; Check for leading 0s
.ALIGN_END:			CMPI.B		#0,D2						; Check if we still are with leading 0s
					BEQ			.CHECK_ZERO
					BRA			.PRINT_START				; Already hit non-zero, continue printing
					
.CHECK_ZERO:		CMPI.B		#0,D5						; Still haven't hit a non-zero check if number is zero
					BEQ			.PRINT_END					; Go to end of loop if is zero					
					
					MOVE.L		#1,D2						; Set to TRUE for hit non-zero and continue to printing					
					
.PRINT_START:		LEA			HEX_ALPHABET,A1				; Load hexadecimal alphabet address into A1
					MULU.W		#2,D5						; Multiply D5 by 2 because each letter in the alphabet has itself and 0
					ADD.L		D5,A1						; Add that to the starting address
					MOVE.L		#1,D0						; Use Task 1
					MOVE.L		#2,D1						; Display 2 bytes (1st byte is letter, 2nd is null terminator)
					TRAP		#15							; Run Trap 15

.PRINT_END:			LSL.L		#4,D7						; Shift buffer left 4-bits (hexadecimal char)
					ADDQ		#1,D6						; Increment D6 (amount of bits displayed)
					
					BRA			.CHAR_START
	  
					; Done writing string

.END:				MOVEM.L		(SP)+,D0-D7/A0				; Restore registers
					RTS



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
