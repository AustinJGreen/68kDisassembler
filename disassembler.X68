*--------------------------------------------------------------------------
* Title		 : 68k Disassembler
* Written by : Austin Green, Damian Forrester, Jacob Lefeat
* Date		 : 10/20/2018
* Description: Disassmbles 68k machine code back into readable 68k opcodes
*--------------------------------------------------------------------------

					ORG			$1000						; Organize code at 0x1000 (Specification 5)

ERROR_FLAG			DC.B		1

					INCLUDE		"binarytree.X68"			; Load Binary tree object
					INCLUDE		"stringutils.X68"			; Load String Utils
					INCLUDE		"readhex.X68"				; Load ReadHex Function
					INCLUDE		"writehex.X68"				; Load WriteHex Function
					INCLUDE		"goto.X68"					; Load Goto function

					INCLUDE		"opcodes_header.X68"		; Load all opcodes, all opcodes should have access to the included files above

					; Load information for tree

START:				JSR			TREE_INIT					; Initialize binary tree

					;--------------------------------------------------------------------------
					; Add OpCodes to tree
					;--------------------------------------------------------------------------

					JSR		 	LOAD_ADDQ
					JSR		 	LOAD_MOVEQ
					JSR			LOAD_MOVE_MOVEA
					JSR			LOAD_MOVEM
					JSR		 	LOAD_OR
					JSR			LOAD_SUB
					JSR			LOAD_NOT
					JSR			LOAD_NOP
					JSR			LOAD_RTS
					JSR			LOAD_JSR
					JSR			LOAD_ASL_ASR_LSL_LSR
					JSR			LOAD_LEA
					JSR			LOAD_BRA
					JSR			LOAD_BEQ
					JSR			LOAD_BLE
					JSR			LOAD_BGT
					JSR			LOAD_BLT
					JSR			LOAD_DIVU
					JSR			LOAD_MULS
					JSR			LOAD_ADD_ADDA
					JSR			LOAD_AND

					;--------------------------------------------------------------------------
					; Prompt user for start and end memory address
					;--------------------------------------------------------------------------

BEGIN:				MOVE.B		#0,ERROR_FLAG				; Set ERROR_FLAG to 0 (False)

					; Display about
					LEA			ABOUT_STR,A0				; Load about string
					JSR			PRINT_STR					; Print about information

					LEA			BEGIN_PROMPT,A0				; Load information about input
					JSR			PRINT_STR
					
					LEA			EXTRA_PROMPT,A0				; Load extra constraints about input
					JSR			PRINT_STR

					; At startup, prompt the user for the starting location and
					; ending location in hexadecimal format. (Specification 6)

IO_START:			LEA			START_ADDR_STR,A0			; Load question and prompt to user
					JSR			PRINT_STR					; Print question
					JSR			READHEX

					CMPI.L		#$FFFFFF,D2					; Too big of input
					BGE			IO_START_ERR

					CMPI.B		#0,ERROR_FLAG				; Check if IO error occured for start address
					BNE			IO_START_ERR
					BRA			IO_END
					
IO_START_ERR:		MOVE.B		#0,ERROR_FLAG				; Reset ERROR_FLAG
					MOVE.B		#11,D0
					MOVE.W		#3,D1
					TRAP		#15							; Set cursor back to start of line (row 2)
					JSR			CLEAR_LINE					; Clear line
					MOVE.B		#11,D0					
					MOVE.W		#3,D1
					TRAP		#15							; Set cursor back to start of line
					BRA			IO_START					; Go back to question

IO_END:				MOVE.L		D2,A4						; Move start address to A4

					LEA			END_ADDR_STR,A0				; Load question and prompt to user
					JSR			PRINT_STR					; Print question
					JSR			READHEX

					CMPI.B		#0,ERROR_FLAG				; Check if IO error occured for end address
					BNE			IO_END_ERR
					
					CMPI.L		#$FFFFFF,D2					; Too big of input
					BGE			IO_END_ERR
					
					BRA			VALID_INPUT
					
IO_END_ERR:			MOVE.B		#0,ERROR_FLAG				; Reset ERROR_FLAG
					MOVE.B		#11,D0
					MOVE.W		#4,D1
					TRAP		#15							; Set cursor back to start of line (row 4)
					JSR			CLEAR_LINE					; Clear line
					MOVE.B		#11,D0					
					MOVE.W		#4,D1
					TRAP		#15							; Set cursor back to start of line
					BRA			IO_END						; Go back to question

VALID_INPUT:		MOVE.L		D2,A5						; Move end address to A5

					;--------------------------------------------------------------------------
					; Read and process memory
					;--------------------------------------------------------------------------

					MOVE.B		#11,D0
					MOVE.W		#$FF00,D1
					TRAP		#15							; Clear screen to separate input from disassembled code

					MOVE.L		#0,LINE_NUMBER				; Keep track of line number (ROW) (0-31)

					; Begin reading at start address

READ_START:			CMPA.L		A4,A5
					BLT			END_PROMPT					; Go to end if reached end address

					; Read from binary stream

					MOVE.L		#0,D0						; Clear all 32-bits so handler files are looking at a clean 16-bits just to be safe
					MOVE.W		(A4)+,D0					; Read 16-bits at a time

					CMPI.W		#$FFFF,D0					; Check if data is 0xFFFF (no opcode)
					BEQ			READ_START					; Go to next line if 0xFFFF

					; Write current memory location (Specification 10)

					EXG.L		D1,D0						; Swap D1 with D0 temporarily for writehex

					MOVE.L		A4,D2
					SUB.L		#2,D2						; Subtract word length to get start address
					MOVE.L		D2,A0
					MOVE.L		#8,D0
					JSR			WRITEHEX
					JSR			PRINT_TAB					; Print tab

					EXG.L		D1,D0						; Swap back D1 and D0 so D0 can be used in tree lookup

					; Lookup value in opcode tree

					MOVE.L		#16,D1						; Set tree to use 16-bits from
					JSR			TREE_LOOKUP					; Looks for opcode handler, stores result in A0

					; Check if invalid operator (unhandled opcode)

					CMP.L		#$FFFFFFFF,A0
					BEQ			INVALID_OPCODE
					BRA			VALID_OPCODE

					; Opcode error occured, reset cursor
OPCODE_ERROR:		MOVE.B		#0,ERROR_FLAG				; Reset ERROR_FLAG
					JSR			CLEAR_OPCODE_DATA			; Clear opcode data
					JSR			GOTO_OPCODE_START			; Go to opcode start			
	
					BRA			INVALID_OPCODE

					; Print invalid opcode as DATA $ABCD (Specification 8)
INVALID_OPCODE:		LEA			DATA_STR,A0
					JSR			PRINT_STR
					JSR			PRINT_OPCODE_TAB

					; Print unreadable data in D0

					MOVE.L		D0,A0
					MOVE.L		#4,D0
					JSR			PRINT_ADDRESS
					JSR			PRINT_NEWLINE
					ADDI.L		#1,LINE_NUMBER				; Add 1 to line number
					
					CMPI.L		#31,LINE_NUMBER
					BEQ			BOTTOM_PAGE
					BRA			READ_START

					BRA			READ_START

					; Print valid opcode

VALID_OPCODE:		JSR			GOTO_ADDR					; Goto A0 found in tree

					; Check if ERROR_FLAG is set, if so, set cursor back and goto INVALID_OPCODE
					CMPI.B		#0,ERROR_FLAG
					BNE			OPCODE_ERROR					

					JSR			PRINT_NEWLINE				; Print newline
					ADDI.L		#1,LINE_NUMBER				; Add 1 to line number

					CMPI.L		#31,LINE_NUMBER
					BEQ			BOTTOM_PAGE
					BRA			READ_START

					; We've reached the bottom of the page, display message to press enter

BOTTOM_PAGE:		LEA			ENTER_STR,A0
					JSR			PRINT_STR
					JSR			WAIT_FOR_ENTER				; Wait for enter

					MOVE.B		#11,D0
					MOVE.W		#$FF00,D1
					TRAP		#15							; Clear screen to get rid of old lines of code

					MOVE.L		#0,LINE_NUMBER				; Reset LINE_NUMBER

					BRA			READ_START					; Go back to start

					; TODO: prompt the user to disassemble another memory range, or prompt the user to quit (Specification 11)

END_PROMPT:			LEA			DONE_STR,A0
					JSR			PRINT_STR
					JSR			GET_INPUT_KEY

					CMPI.B		#$D,D1
					BEQ			.RESET
					BRA			.END

.RESET:				MOVE.B		#11,D0
					MOVE.W		#$FF00,D1
					TRAP		#15							; Clear screen for prompt

					MOVE.L		#0,LINE_NUMBER				; Reset LINE_NUMBER

					BRA			BEGIN

.END:				MOVE.B		#11,D0
					MOVE.W		#$FF00,D1
					TRAP		#15							; Clear screen on end

					SIMHALT									; Halt simulator

LINE_NUMBER			DS.L		1							; 1 long for line number

ABOUT_STR			DC.B		'68k Disassembler by Austin Green, Damian Forrester, Jacob Lefeat.',CR,LF,0
BEGIN_PROMPT		DC.B		'Please enter hexadecimal characters only. (0123456789abcdefABCDEF).',CR,LF,0
EXTRA_PROMPT		DC.B		'Please enter addresses between 0 and FFFFFF.',CR,LF,0
START_ADDR_STR		DC.B		'Starting address : ',0
END_ADDR_STR		DC.B		'Ending address   : ',0
DATA_STR			DC.B		'DATA',0
ENTER_STR			DC.B		'Press <ENTER> to display next page...',0
DONE_STR			DC.B		'Done. Press <ENTER> to disassemble another range, or press the any key to exit.',0

					END			START						; Last line of source














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
