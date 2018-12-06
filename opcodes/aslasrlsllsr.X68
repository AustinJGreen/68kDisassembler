*--------------------------------------------------------------------------------------
* Title			: ASL,ASR,LSL,LSR Handler function
* Description	: Handles ASL,ASR,LSL,LSR opcodes, outputs the full disassembled instruction
* Manual Page # : 125 (ASL and ASR) and 217 (LSL and LSR)
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
ASL_OUT						DC.B		'ASL',0
ASR_OUT						DC.B		'ASR',0
LSL_OUT						DC.B		'LSL',0
LSR_OUT						DC.B		'LSR',0

ASL_SIZE_CODE				DS.L	1
  
LOAD_ASL_ASR_LSL_LSR:		MOVE.L		#%1110,D0
							MOVE.L		#4,D1
							LEA			HANDLE_ASL_ASR_LSL_LSR,A0
							JSR			TREE_ADD_NODE
							RTS

PRINT_ARITH:				; Read direction bit for arithmetic shift				
							BTST		#8,D7
							BEQ			.A_RIGHT
							BRA			.A_LEFT
					
.A_RIGHT:					LEA			ASR_OUT,A0			; Print ASR
							JSR			PRINT_STR
							RTS
					
.A_LEFT						LEA			ASL_OUT,A0			; Print ASL
							JSR			PRINT_STR
							RTS

PRINT_LOGICAL:				; Read direction bit for logical shift					
							BTST		#8,D7
							BEQ			.L_RIGHT
							BRA			.L_LEFT
					
.L_RIGHT:					LEA			LSR_OUT,A0			; Print LSR
							JSR			PRINT_STR
							RTS
					
.L_LEFT:					LEA			LSL_OUT,A0			; Print LSL
							JSR			PRINT_STR
							RTS
							

HANDLE_ASL_ASR_LSL_LSR:		MOVEM.L		D0-D7,-(SP)
							MOVE.L		D0,D7				; Transfer D0 to D7 so D0 can be used as a parameter
					
							; Read size field
							MOVE.L		D7,D6
							ANDI.L		#%11000000,D6
							LSR.L		#6,D6
							MOVE.L		D6,ASL_SIZE_CODE
					
							; Check for a size of 11, which means ASL,ASR,LSL,LSR is shifting just an <ea>
							CMPI.B		#%11,D6
							BEQ			.EA_MODE
							
							; We have a size code, but first read opcode bit							
							MOVE.L		D7,D6
							ANDI.L		#%11000,D6
							LSR.L		#3,D6
							
							CMPI.B		#%00,D6				; Check if arithmetic shift
							BEQ			.A_SIZE
							
							CMPI.B		#%01,D6				; Check if logical shift
							BEQ			.L_SIZE
							
							; Opcode bit is invalid or supported
							BRA			.INVALID

.A_SIZE:					JSR			PRINT_ARITH
							BRA			.READ_SIZE
							
.L_SIZE:					JSR			PRINT_LOGICAL
							BRA			.READ_SIZE
					
.READ_SIZE					; Print size field				
							MOVE.L		ASL_SIZE_CODE,D0
							MOVE.L		#%100100,D1
							JSR			PRINT_SIZE			; Print size field					
							JSR			PRINT_OPCODE_TAB	; Print tab

							; Read count/register field
							MOVE.L		D7,D5
							ANDI.L		#%111000000000,D5
							LSR.L		#8,D5
							LSR.L		#1,D5				; Shift 9(8+1) to the right
					
							; Read ir bit
							BTST		#5,D7
							BEQ			.SHIFT_SRC
							BRA			.REG_SRC
					
.SHIFT_SRC:					; Source is shift count, display data
							CMPI.L		#0,D5
							BNE			.CONTINUE		
							ADDQ		#8,D5				; D5 is 0, meaning shift count is 8
.CONTINUE:					
							MOVE.L		D5,A0
							MOVE.L		#1,D0
							JSR			PRINT_DATA
							BRA			.DEST				; Continue with destination
					
.REG_SRC:					; Source is register, display register
					
							MOVE.L		D5,D0
							JSR			PRINT_D_REG
							BRA			.DEST				; Continue with destination
			
.DEST:						; Write out destination register
										
							JSR			PRINT_DIVIDER		; Write out divider
					
							; Read destination register (can just use D5 since we are done with source)
					
							MOVE		D7,D5
							ANDI.L		#%111,D5
					
							MOVE.L		D5,D0
							JSR			PRINT_D_REG			; Print destination register	
							BRA			.END				; Goto end
			
.EA_MODE:					; ASL,ASR,LSL,LSR is shifting an effective adress
										
							BTST		#9,D7				; Check if arithmetic shift
							BEQ			.A_EA
							BRA			.L_EA

.A_EA:						JSR			PRINT_ARITH
							BRA			.READ_REG
							
.L_EA:						JSR			PRINT_LOGICAL
							BRA			.READ_REG				
					
.READ_REG					; Read the regsiter

							JSR			PRINT_OPCODE_TAB	; Print tab

							MOVE.L		D7,D0
							ANDI.L		#%111,D0

							; Read the mode
							MOVE.L		D7,D6
							ANDI.L		#%111000,D6
							LSR.L		#3,D6
					
							CMPI.B		#%111,D6
							BEQ			.ABSOLUTE
					
							CMPI.B		#%010,D6
							BEQ			.DIRECT
					
							CMPI.B		#%011,D6
							BEQ			.POST
					
							CMPI.B		#%100,D6
							BEQ			.PRE
					
					
.ABSOLUTE:					CMPI.B		#%000,D0
							BEQ			.WORD
							BRA			.LONG
					
.WORD:						MOVE.W		(A4)+,A0
							MOVE.L		#4,D0
							JSR			PRINT_ADDRESS
							BRA			.END
					
.LONG:						MOVE.L		(A4)+,A0
							MOVE.L		#8,D0
							JSR			PRINT_ADDRESS
							BRA			.END

.DIRECT:					JSR			PRINT_A_DIR
							BRA			.END

.POST:						JSR			PRINT_A_POST
							BRA			.END

.PRE:						JSR			PRINT_A_PRE
							BRA			.END	

							; Set error flag and return
.INVALID:					MOVE.B		#1,ERROR_FLAG
							BRA			.END
	
.END						MOVEM.L		(SP)+,D0-D7
							RTS


































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
