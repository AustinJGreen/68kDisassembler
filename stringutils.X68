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
					JSR			WRITEHEX
					
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
* D1 - Used for testing size
*--------------------------------------------------------------------
PRINT_DATA:			MOVEM.L		D0-D1/A0-A1,-(SP)
					
					MOVE.L		A0,D1						; Move value to D1 to be tested
					CMPI.L		#10,D1						; Check if first letter is < 10 (same written in dec as hex)
					BLT			.PRINT_DEC
					BRA			.PRINT_HEX
					
.PRINT_DEC:			MOVEA.L		A0,A1						; Save A0 in A1
					LEA			DECDATA_STR,A0				; Write '#'
					JSR			PRINT_STR
					BRA			.WRITE_DATA
					
.PRINT_HEX:			MOVEA.L		A0,A1						; Save A0 in A1
					LEA			HEXDATA_STR,A0				' Write '#$'
					JSR			PRINT_STR
					BRA			.WRITE_DATA
					
.WRITE_DATA:		MOVEA.L		A1,A0						; Restore A1 from A0
					JSR			WRITEHEX
					
					MOVEM.L		(SP)+,D0-D1/A0-A1
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
* PRINT_SIZE
* Prints the size operand. 
*
* INPUTS
* D0 - Size code value
* D1 - Size mask. Because different opcodes have different meanings for
* sizes. Put mask for a BYTE in the first 3-bits, mask for WORD in the
* 3-bits, and mask for LONG in the last 3-bits. For example:
* If 000 = BYTE, 001 = WORD, 010 = LONG, then put #%010001000 in D1.
*
* REGISTER USE
* D2 - Holds mask data
* D3 - Holds iteration
* A1 - Holds output string size
*--------------------------------------------------------------------
PRINT_SIZE:			MOVEM.L		D0-D3/A1,-(SP)
					
					; Test size code value with mask
					MOVE.L		#0,D3						; Initialize iteration at 0
					
.TEST_START:		CMPI		#3,D3
					BEQ			.TEST_END					; Exit if on 3th iteration

					MOVE.L		D1,D2
					ANDI.B		#%111,D2					
					
					CMP.B		D2,D0						; Compare D2 with value
					BEQ			.TEST_END
					
					; Not the right mask, shift mask right and increase iteration
					LSR.W		#3,D1
					ADDQ		#1,D3
					BRA			.TEST_START
					
.TEST_END:			; The mask was matched, use iteration to pull correct str from
					; memory

					LEA			SIZE_CODES,A1				; Load size codes address into A1
					MULU.W		#3,D3						; Multiply D1 by 3
					ADD.L		D3,A1						; Add that to the starting address
					MOVE.B		#1,D0						; Use Task 1
					MOVE.L		#3,D1						; Display 3 bytes for .,(size),0
					TRAP		#15							; Run Trap 15						
						
					MOVEM.L		(SP)+,D0-D3/A1
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
					MOVE.L		D0,D1						; Save D0 in D1
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
					MOVE.L		D0,D1						; Save D0 in D1
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
* WAIT_FOR_ENTER
* Waits for the enter key to be pressed, then returns
*
* REGISTER USE
* D0 - Holds task number
* D1 - Holds row and column position
* D2 - Holds temporary value of LINE_NUMBER
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
					
.ENTER_HIT:			; Turn echo back on
					MOVE.B		#12,D0							; Set task 12
					MOVE.B		#1,D1							; Set 1 to turn on				
					TRAP		#15								; Run trap 15 task 12
					MOVEM.L		(SP)+,D0-D2
					RTS
                    
					





































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
