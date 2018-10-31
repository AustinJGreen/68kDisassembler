*--------------------------------------------------------------------------------------
* Title			: ASL and ASR Handler function
* Description	: Handles the ASL and ASR opcodes, outputs the full disassembled instruction
* Manual Page # : 126
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*
* REGISTER USE
* D7 - Holds opcode data
* D6 - Size field
* D5 - Count/Register field and Destination register field
*--------------------------------------------------------------------------------------
ASL_OUT				DC.B		'ASL',0
ASR_OUT				DC.B		'ASR',0
  
LOAD_ASL_ASR:		MOVE.L		#%1110,D0
					MOVE.L		#4,D1
					LEA			HANDLE_ASL_ASR,A0
					JSR			TREE_ADD_NODE
					RTS

HANDLE_ASL_ASR:		MOVEM.L		D0-D7,-(SP)
					MOVE.L		D0,D7			; Transfer D0 to D7 so D0 can be used as a parameter
					
					; Read direction bit
					
					BTST		#8,D7
					BEQ			.RIGHT_SHIFT
					BRA			.LEFT_SHIFT
					
.RIGHT_SHIFT:		LEA			ASR_OUT,A0			; Print ASR
					JSR			PRINT_STR
					BRA			.READ_SIZE
					
.LEFT_SHIFT:		LEA			ASL_OUT,A0			; Print ASL
					JSR			PRINT_STR
					BRA			.READ_SIZE
					
.READ_SIZE:			; Read size field

					MOVE.L		D7,D6
					AND.L		#%11000000,D6
					LSR.L		#6,D6
					
					; Check for a size of 11, which means ASL,ASR is shifting just an <ea>
					CMPI.L		#%11,D6
					BEQ			.EA_MODE
					
					; Print size field
					
					MOVE.L		D6,D0
					MOVE.L		#%010001000,D1
					JSR			PRINT_SIZE			; Print size field					
					JSR			PRINT_OPCODE_TAB	; Print tab

					; Read count/register field
					MOVE.L		D7,D5
					AND.L		#%111000000000,D5
					LSR.L		#8,D5
					LSR.L		#1,D5				; Shift 9(8+1) to the right
					
					; Read ir bit
					BTST		#5,D7
					BEQ			.SRC_IS_SHIFT
					BRA			.SRC_IS_REG
					
.SRC_IS_SHIFT:		; Source is shift count, display data
					CMPI.L		#0,D5
					BNE			.CONTINUE		
					ADDQ		#8,D5				; D5 is 0, meaning shift count is 8
.CONTINUE:					
					MOVE.L		D5,A0
					MOVE.L		#1,D0
					JSR			PRINT_DATA
					BRA			.DESTINATION		; Continue with destination
					
.SRC_IS_REG:		; Source is register, display register
					
					MOVE.L		D5,D0
					JSR			PRINT_D_REG
					BRA			.DESTINATION		; Continue with destination
			
.DESTINATION:		; Write out destination register
										
					JSR			PRINT_DIVIDER		; Write out divider
					
					; Read destination register (can just use D5 since we are done with source)
					
					MOVE		D7,D5
					AND.L		#%111,D5
					
					MOVE.L		D5,D0
					JSR			PRINT_D_REG			; Print destination register	
					BRA			.END				; Goto end
			
.EA_MODE:			; ASL and ASR is shifting an effective adress
					
					JSR			PRINT_OPCODE_TAB	; Print tab
					
					; Read the regsiter
					MOVE.L		D7,D0
					AND.L		#%111,D0

					; Read the mode
					MOVE.L		D7,D6
					AND.L		#%111000,D6
					LSR.L		#3,D6
					
					CMPI		#%111,D6
					BEQ			.ABSOLUTE
					
					CMPI		#%010,D6
					BEQ			.DIRECT
					
					CMPI		#%011,D6
					BEQ			.POST
					
					CMPI		#%100,D6
					BEQ			.PRE
					
					
.ABSOLUTE:			CMPI		#%000,D0
					BEQ			.WORD
					BRA			.LONG
					
.WORD:				MOVE.W		(A4)+,A0
					MOVE.L		#4,D0
					JSR			PRINT_ADDRESS
					BRA			.END
					
.LONG:				MOVE.L		(A4)+,A0
					MOVE.L		#8,D0
					JSR			PRINT_ADDRESS
					BRA			.END

.DIRECT:			JSR			PRINT_A_DIR
					BRA			.END

.POST:				JSR			PRINT_A_POST
					BRA			.END

.PRE:				JSR			PRINT_A_PRE
					BRA			.END	

.INVALID:			; TODO: Return invalid
					SIMHALT
					BRA			.END
	
.END				MOVEM.L		(SP)+,D0-D7
					RTS






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
