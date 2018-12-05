*-----------------------------------------------------------
* Title		 : String Utils
* Description: Provides shortcuts for a lot of crap
*-----------------------------------------------------------
CR					EQU			$0D							; ASCII code for Carriage Return
LF					EQU			$0A							; ASCII code for Line Feed
TAB					EQU			$09							; ASCII code for Horizontal Tab	   

TAB_STR				DC.B		TAB,0
NEWLINE_STR			DC.B		CR,LF,0
D_REG_STR			DC.B		'D',0
A_REG_STR			DC.B		'A',0
LEFT_PAREN			DC.B		'(',0
RIGHT_PAREN			DC.B		')',0
DECREMENT			DC.B		'-',0
INCREMENT			DC.B		'+',0
DIVIDER			 	DC.B		',',0	
BACK_SLASH			DC.B		'/',0
ADDRESS_STR			DC.B		'$',0
DECDATA_STR			DC.B		'#',0
HEXDATA_STR			DC.B		'#$',0
SIZE_CODES			DC.B		'.B',0,'.W',0,'.L',0,'.$',0

*--------------------------------------------------------------------
* PRINT_STR
* Prints a string
*
* REGISTER USE
* A0 - address of string to print
*--------------------------------------------------------------------
PRINT_STR:			MOVEM.L		D0/A1,-(SP)					   
					MOVE.L		A0,A1
					MOVE.B		#14,D0
					TRAP		#15					   
					MOVEM.L		(SP)+,D0/A1
					RTS
					
*--------------------------------------------------------------------
* PRINT_ADDRESS
* Prints an address. For exmaple, If A0=A000 -> "$A000"
*
* INPUTS
* D0 - amount of letters to print. Use 4 for WORD, 8 for LONG
* A0 - address of string to print
*--------------------------------------------------------------------
PRINT_ADDRESS:		MOVEM.L		D0/A0-A1,-(SP)
					
					MOVEA.L		A0,A1						; Save A0 in A1
					LEA			ADDRESS_STR,A0
					JSR			PRINT_STR
					
					MOVEA.L		A1,A0						; Restore A1 from A0
					JSR			WRITEHEX_TRIM
					
					MOVEM.L		(SP)+,D0/A0-A1
					RTS
					
*--------------------------------------------------------------------
* PRINT_DATA
* Prints data. For exmaple, If A0=A000 -> "#$A000". 
* NOTE: If the data is < 10 then it is printed without the hex symbol.
*
* INPUTS
* D0 - amount of letters to print. Use 4 for WORD, 8 for LONG
* A0 - address of string to print
*
* REGISTER USE
* A1 - Temporary swap register for A0
*--------------------------------------------------------------------
PRINT_DATA:			MOVEM.L		A1,-(SP)
					
					MOVEA.L		A0,A1						; Save A0 in A1
					LEA			HEXDATA_STR,A0				' Write '#$'
					JSR			PRINT_STR
					
					MOVEA.L		A1,A0						; Restore A1 from A0
					JSR			WRITEHEX_TRIM
					
					MOVEM.L		(SP)+,A1
					RTS

*--------------------------------------------------------------------
* PRINT_TAB
* Prints a tab (\t)
*
* REGISTER USE
* D0 - Holds task codes
* A1 - Holds tab string
*--------------------------------------------------------------------
PRINT_TAB:			MOVEM.L		D0/A1,-(SP)					; Save registers			   
					LEA			TAB_STR,A1					; Load tab string
					MOVE.B		#14,D0						; Set task 14
					TRAP		#15							; Run trap 15					
					TRAP		#15							; print double tab to align better
					
					MOVEM.L		(SP)+,D0/A1					; Restore registers
					RTS										; Return

*--------------------------------------------------------------------
* PRINT_NEWLINE
* Prints a tab (\n)
*
* REGISTER USE
* D0 - Holds task codes
* A1 - Holds tab string
*--------------------------------------------------------------------
PRINT_NEWLINE:		MOVEM.L		D0/A1,-(SP)					; Save registers
					LEA			NEWLINE_STR,A1				; Load newline string
					MOVE.B		#14,D0						; Set task 14
					TRAP		#15							; Run trap 15
					MOVEM.L		(SP)+,D0/A1					; Restore registers
					RTS										; Return
*--------------------------------------------------------------------
* Get_SIZE
* Gets the size operand. 
*
* INPUTS
* D0 - Size code value
* D1 - Size mask. Because different opcodes have different meanings for
* sizes. Put mask for a BYTE in the first 2-bits, mask for WORD in the
* next 2-bits, and mask for LONG in the last 2-bits. For example:
* If 00 = BYTE, 01 = WORD, 10 = LONG, then put #%100100 in D1.
*
* OUTPUTS
* D1 - Size code. 0 = BYTE, 1 = WORD, 2 = LONG, 3 = INVALID
*
* REGISTER USE
* D2 - Holds mask data
* D3 - Holds iteration
*--------------------------------------------------------------------
GET_SIZE:			MOVEM.L		D0/D2-D3/A1,-(SP)
					
					; Test size code value with mask
					MOVE.B		#0,D3						; Initialize iteration at 1
					
.TEST_START:		CMPI.B		#3,D3
					BEQ			.TEST_END					; Exit if larger than LONG, 3rd iteration

					MOVE.W		D1,D2
					ANDI.B		#%11,D2					
					
					CMP.B		D2,D0						; Compare D2 with value
					BEQ			.TEST_END
					
					; Not the right mask, shift mask right and increase iteration
					LSR.W		#2,D1
					ADDQ		#1,D3
					BRA			.TEST_START
					
.TEST_END:			MOVE.L		D3,D1						; Set output in D1			
					MOVEM.L		(SP)+,D0/D2-D3/A1
					RTS


*--------------------------------------------------------------------
* PRINT_SIZE
* Prints the size operand. 
*
* INPUTS
* D0 - Size code value
* D1 - Size mask. Because different opcodes have different meanings for
* sizes. Put mask for a BYTE in the first 2-bits, mask for WORD in the
* next 2-bits, and mask for LONG in the last 2-bits. For example:
* If 00 = BYTE, 01 = WORD, 10 = LONG, then put #%100100 in D1.
*
* REGISTER USE
* A1 - Holds output string size
*--------------------------------------------------------------------
PRINT_SIZE:			MOVEM.L		D0-D1/A1,-(SP)
					
					JSR			GET_SIZE					; Calculate size

					LEA			SIZE_CODES,A1				; Load size codes address into A1
					MULU.W		#3,D1						; Multiply D3 by 3
					ADD.L		D1,A1						; Add that to the starting address
					MOVE.B		#1,D0						; Use Task 1
					MOVE.L		#3,D1						; Display 3 bytes for .,(size),0
					TRAP		#15							; Run Trap 15						
						
.END					MOVEM.L		(SP)+,D0-D1/A1
					RTS

*--------------------------------------------------------------------
* PRINT_D_REG
* Prints a data register Dn
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------
PRINT_D_REG:		MOVEM.L		D0-D1/A1,-(SP)				; Save registers
					MOVE.B		D0,D1						; Save 1st byte of D0 in D1
					LEA			D_REG_STR,A1				; Load D string
					MOVE.B		#14,D0						; Set task 14
					TRAP		#15							; Run trap 15
					MOVE.B		#3,D0						; Set task 3
					TRAP		#15							; Run trap 15
					MOVEM.L		(SP)+,D0-D1/A1				; Restore registers
					RTS										; Return

*--------------------------------------------------------------------
* PRINT_A_REG
* Prints a address register An
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------
PRINT_A_REG:		MOVEM.L		D0-D1/A1,-(SP)				; Save registers
					CLR.L		D1							; Clear D1 so only first byte from D0 is used
					MOVE.B		D0,D1						; Save D0 in D1
					LEA			A_REG_STR,A1				; Load A string
					MOVE.B		#14,D0						; Set task 14
					TRAP		#15							; Run trap 15
					MOVE.B		#3,D0						; Set task 3
					TRAP		#15							; Run trap 15
					MOVEM.L		(SP)+,D0-D1/A1				; Restore registers
					RTS										; Return

*--------------------------------------------------------------------
* PRINT_A_DIR
* Prints a address register in direct addressing mode (An)
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------
PRINT_A_DIR:		MOVEM.L		D0-D1/A1,-(SP)				; Save registers
					MOVE.L		D0,D1						; Save D0 in D1
					LEA			LEFT_PAREN,A1				; Load (
					MOVE.B		#14,D0						
					TRAP		#15							; Print (
					MOVE.L		D1,D0						; Put D1 back in D0
					JSR			PRINT_A_REG					; Print An
					LEA			RIGHT_PAREN,A1				; Load )
					MOVE.B		#14,D0
					TRAP		#15							; Print )
					MOVEM.L		(SP)+,D0-D1/A1				; Restore registers
					RTS										; Return

*--------------------------------------------------------------------
* PRINT_A_PRE
* Prints a address register in pre-decrement mode -(An)
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------
PRINT_A_PRE:		MOVEM.L		D0-D1/A1,-(SP)				; Save registers
					MOVE.L		D0,D1						; Save D0 in D1
					LEA			DECREMENT,A1				; Load -
					MOVE.B		#14,D0				
					TRAP		#15							; Print -
					MOVE.L		D1,D0						; Put D1 back in D0
					JSR			PRINT_A_DIR					; Print (An)
					MOVEM.L		(SP)+,D0-D1/A1				; Restore registers
					RTS										; Return

*--------------------------------------------------------------------
* PRINT_A_POST
* Prints a address register in post-decrement mode (An)+
*
* INPUTS
* D0 - Register number
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------					 
PRINT_A_POST:		MOVEM.L		D0-D1/A1,-(SP)				; Save registers			   
					JSR			PRINT_A_DIR					; Print (An)
					LEA			INCREMENT,A1				; Load +
					MOVE.B		#14,D0
					TRAP		#15							; Print +
					MOVEM.L		(SP)+,D0-D1/A1				; Restore registers
					RTS										; Return
					
*--------------------------------------------------------------------
* PRINT_DIVIDER
* Prints a comma, used to separate source and destination
*
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------					 
PRINT_DIVIDER:		MOVEM.L		D0-D1/A1,-(SP)				; Save registers	
					LEA			DIVIDER,A1				   	; Load ,
					MOVE.B		#14,D0
					TRAP		#15							; Print ,
					MOVEM.L		(SP)+,D0-D1/A1				; Restore registers
					RTS										; Return
*--------------------------------------------------------------------
* PRINT_DASH
* Prints a -, used to separate registers in a range
*
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------					 
PRINT_DASH:			MOVEM.L		D0-D1/A1,-(SP)				; Save registers	
					LEA			DECREMENT,A1				   	; Load ,
					MOVE.B		#14,D0
					TRAP		#15							; Print ,
					MOVEM.L		(SP)+,D0-D1/A1				; Restore registers
					RTS										; Return

*--------------------------------------------------------------------
* PRINT_BACK_SLASH
* Prints a /, used to separate An and Dn registers in a list
*
*
* REGISTER USE
* A1 - Holds register string
*--------------------------------------------------------------------					 
PRINT_BACK_SLASH:	MOVEM.L		D0-D1/A1,-(SP)				; Save registers	
					LEA			BACK_SLASH,A1				   	; Load ,
					MOVE.B		#14,D0
					TRAP		#15							; Print ,
					MOVEM.L		(SP)+,D0-D1/A1				; Restore registers
					RTS										; Return


*--------------------------------------------------------------------
* PRINT_OPCODE_TAB
* Goes to the correct index for a tab after an OPCODE has been printed
* instead of just printing 4 spaces for a horizontal tab.
* For example, printing tabs produces the following output:
* 00000000    MOVE.B    D0,D1
* 00000002    NOT.B    D1
* 
* Which looks unaligned. Using PRINT_OPCODE_TAB puts the cursor at
* column 24. 8 for the address, 8 for the double tab and 12 for the opcode space.
*
* REGISTER USE
* D0 - Holds task number
* D1 - Holds row and column position
* D2 - Holds temporary value of LINE_NUMBER
*--------------------------------------------------------------------
PRINT_OPCODE_TAB:	MOVEM.L		D0-D2,-(SP)
					MOVE.L		#11,D0
					MOVE.B		#32,D1
					LSL.W		#8,D1
					MOVE.L		LINE_NUMBER,D2
					MOVE.B		D2,D1
					TRAP		#15
					MOVEM.L		(SP)+,D0-D2
					RTS

*--------------------------------------------------------------------
* PRINT_PARAM
* Uses the default table in the 68k manual to write the parameter 
* from machine code format using the mode and register. 
* Mode 000 = Dn
* Mode 001 = An
* Mode 010 = (An)
* Mode 011 = (An)+
* Mode 100 = -(An)
* Mode 111, Register 000 = (xxx).W
* Mode 111, Register 001 = (xxx).L
* Mode 111, Register 100 = #data
*
* INPUTS
* D0 - Register
* D1 - Mode
* D2 - Size value
* D3 - Size mask
* A4 - Machine code pointer
*
* A0 - Holds value of address being printed
*--------------------------------------------------------------------						
PRINT_PARAM:		MOVEM.L		D0-D1/A0,-(SP)
					CMPI.B		#%000,D1
					BEQ			.PRINT_DN
					CMPI.B		#%001,D1
					BEQ			.PRINT_AN
					CMPI.B		#%010,D1
					BEQ			.PRINT_A_DIR
					CMPI.B		#%011,D1
					BEQ			.PRINT_A_POST
					CMPI.B		#%100,D1
					BEQ			.PRINT_A_PRE
					CMPI.B		#%111,D1
					BNE			.END
					
					CMPI.B		#%000,D0
					BEQ			.PRINT_WORD
					CMPI.B		#%001,D0
					BEQ			.PRINT_LONG
					CMPI.B		#%100,D0
					BEQ			.PRINT_DATA
					
					BRA			.END
					
.PRINT_DN:			JSR			PRINT_D_REG
					BRA			.END
					
.PRINT_AN:			JSR			PRINT_A_REG
					BRA			.END
					
.PRINT_A_DIR:		JSR			PRINT_A_DIR
					BRA			.END

.PRINT_A_POST:		JSR			PRINT_A_POST
					BRA			.END
					
.PRINT_A_PRE:		JSR			PRINT_A_PRE
					BRA			.END
					
.PRINT_WORD:		MOVE.W		(A4)+,A0
					MOVE.B		#4,D0
					JSR			PRINT_ADDRESS
					BRA			.END
					
.PRINT_LONG:		MOVE.L		(A4)+,A0
					MOVE.B		#8,D0
					JSR			PRINT_ADDRESS
					BRA			.END
					
.PRINT_DATA:		MOVE.L		D2,D0
					MOVE.L		D3,D1
					JSR			GET_SIZE
					
					CMPI.B		#0,D1
					BEQ			.PRINT_DATA_W
					CMPI.B		#1,D1
					BEQ			.PRINT_DATA_W
					CMPI.B		#2,D1
					BEQ			.PRINT_DATA_L
					BRA			.END
					
.PRINT_DATA_W:		MOVE.W		(A4)+,A0
					MOVE.L		#4,D0
					JSR			PRINT_DATA
					BRA			.END

.PRINT_DATA_L:		MOVE.L		(A4)+,A0
					MOVE.L		#8,D0
					JSR			PRINT_DATA	
					BRA			.END				
					
.END:				MOVEM.L		(SP)+,D0-D1/A0
					RTS					
				
*--------------------------------------------------------------------
* WAIT_FOR_ENTER
* Waits for the enter key to be pressed, then returns
*
* REGISTER USE
* D0 - Holds task number
* D1 - Holds value for tasks
*--------------------------------------------------------------------					
WAIT_FOR_ENTER:		MOVEM.L		D0-D2,-(SP)
					
					; Turn echo off
					MOVE.B		#12,D0							; Set task 12
					MOVE.B		#0,D1							; Set 0 to turn off
					TRAP		#15								; Run trap 15 task 12
					
					; Read key 
.READ_KEY			MOVE.B		#5,D0
					TRAP		#15
					
					CMPI.B		#$D,D1
					BEQ			.ENTER_HIT
					
					; Enter key was not key, read key again
					BRA			.READ_KEY
					
					; Turn echo back on
.ENTER_HIT:			MOVE.B		#12,D0							; Set task 12
					MOVE.B		#1,D1							; Set 1 to turn on				
					TRAP		#15								; Run trap 15 task 12
					MOVEM.L		(SP)+,D0-D2
					RTS
                    
*--------------------------------------------------------------------
* GET_INPUT_KEY
* Waits for a key to be pressed
*
* OUTPUTS
* D1 - Holds key press data
*
* REGISTER USE
* D0 - Holds task number
* D7 - Holds temporary output
*--------------------------------------------------------------------					
GET_INPUT_KEY:		MOVEM.L		D0/D7,-(SP)
					
					; Turn echo off
					MOVE.B		#12,D0							; Set task 12
					MOVE.B		#0,D1							; Set 0 to turn off
					TRAP		#15								; Run trap 15 task 12
					
					; Read key 
					MOVE.B		#5,D0
					TRAP		#15
					
					MOVE.L		D1,D7							; Save key

					MOVE.B		#12,D0							; Set task 12
					MOVE.B		#1,D1							; Set 1 to turn on				
					TRAP		#15								; Run trap 15 task 12
					
					MOVE.L		D7,D1							; Restore key
					
					MOVEM.L		(SP)+,D0/D7
					RTS					




















































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
