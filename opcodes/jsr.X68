*--------------------------------------------------------------------------------------
* Title			: JSR Handler function
* Description	: Handles the JSR opcode, outputs the full disassembled instruction
* Manual Page # : 213
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*
* REGISTER USE
* D6 - Holds register value
* D7 - Register used to hold Opcode data
*--------------------------------------------------------------------------------------  
JSR_OUT				DC.B		'JSR',0

LOAD_JSR:			MOVE.L		#%0100111010,D0
					MOVE.L		#10,D1
					LEA			HANDLE_JSR,A0
					JSR			TREE_ADD_NODE
					RTS

HANDLE_JSR:			MOVEM.L		D0-D7/A0,-(SP)				; Save registers

					LEA			JSR_OUT,A0					; Load "JSR"
					JSR			PRINT_STR
					
					JSR			PRINT_OPCODE_TAB			; Print special opcode tab
					
					; Read effective address mode
					
					MOVE.L		D0,D7						; Copy over D0 to D7
					AND.L		#%111000,D0					; AND 5 4 3 bits
					LSR.L		#3,D0						; Shift over to right
					
					; Read effective address register
					
					MOVE.L		D7,D6						; Copy D7 over to D6
					AND.L		#%111,D6					; D6 is register value
					
					; Go to correct address mode handler
					
					CMPI.B		#%010,D0
					BEQ			.DIRECTAN					; Goto direct addressing mode
					
					CMPI.B		#%111,D0
					BEQ			.DATA						; Goto data to figure out if WORD or LONG addressing mode
					
					BRA			.INVALID
					
.DIRECTAN:			; Direct addressing mode

					MOVE.L		D6,A0
				 
					JSR			PRINT_A_DIR					; Print direct address
					
					BRA			.END

.DATA:				; Check for WORD or LONG addressing

					CMPI.B		#%000,D6					; Check if WORD addressing mode
					BEQ			.WORD
					
					CMPI.B		#%001,D6					; Check if LONG addressing mode
					BEQ			.LONG
					
					BRA			.INVALID
					
.WORD:				; WORD addressing mode, read in word from A4
					
					MOVE.W		(A4)+,D5
					
					MOVE.L		#4,D0
					MOVE.L		D5,A0
					JSR			PRINT_ADDRESS				; Print the word part of the address
					
					BRA			.END
					
.LONG:				; LONG addressing mode, read in long from A4
				 
					MOVE.L		(A4)+,D5
  
					MOVE.L		#8,D0
					MOVE.L		D5,A0
					JSR			PRINT_ADDRESS				; Print the full address
					
					BRA			.END
					
.INVALID:			; TODO: I'm not sure what to do here...

					SIMHALT									
					
.END:				
					MOVEM.L		(SP)+,D0-D7/A0				; Restore registers
					RTS






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
