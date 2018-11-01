*--------------------------------------------------------------------------------------
* Title			: NOT Handler function
* Description	: Handles the NOT opcode, outputs the full disassembled instruction
* Manual Page # : 252
* 
* INPUTS
* D0 - Opcode data (16-bits)
* D7 - Console line number
* A4 - Current machine code pointer
*
* REGISTER USE
* D5 - Holds register value
* D6 - Register used to hold Opcode data
*--------------------------------------------------------------------------------------  
NOT_OUT				DC.B		'NOT',0


LOAD_NOT:			MOVEQ.L		#%01000110,D0
					MOVEQ.L		#8,D1
					LEA			HANDLE_NOT,A0
					JSR			TREE_ADD_NODE
					RTS

HANDLE_NOT:			MOVEM.L		D0-D7,-(SP)

					MOVE		D0,D6					 	; D6 holds opcode data
					LEA			NOT_OUT,A0
					JSR			PRINT_STR					; Output "NOT."
					
					; Next, read size code
					
					MOVE.L		D6,D1						; Put opcode data in D1
					AND.L		#%11000000,D1
					LSR.L		#6,D1						; D1 holds size code

					; Output the size code
					
					MOVE.L		D1,D0						; Put size value in D0
					MOVEQ.L		#%010001000,D1				; Put size mask for NOT in D1
					JSR			PRINT_SIZE
					MOVE.L		D0,D1						; put D0 back in D1
					
					JSR			PRINT_OPCODE_TAB			; Print a tab
					
					; Read effective address register
					
					MOVE.L		D6,D1						; Put opcode data in D1		
					AND.L		#%111,D1
					MOVE.L		D1,D5						; D5 contains ea register
					
					; Read effective address mode
					
					MOVE.L		D6,D1						; Put opcode data in D1
					ANDI.L		#%111000,D1
					LSR.L		#3,D1						; D1 contains ea mode
					
					; Go to correct mode
					
					CMPI		#%000,D1
					BEQ			.DN
					
					CMPI		#%010,D1
					BEQ			.DIRECTAN
					
					CMPI		#%011,D1
					BEQ			.POSTINCAN
					
					CMPI		#%100,D1
					BEQ			.PREDECAN
					
					BRA			.INVALID
.DN: 
					MOVE.L		D5,D0
					JSR			PRINT_D_REG
					BRA			.END
.DIRECTAN:			
					MOVE.L		D5,D0		
					JSR			PRINT_A_DIR
					BRA			.END
.POSTINCAN:		 
					MOVE.L		D5,D0		
					JSR			PRINT_A_POST	  
					BRA			.END
.PREDECAN:			
					MOVE.L		D5,D0		
					JSR			PRINT_A_PRE 
					BRA			.END
.INVALID:
					; TODO: I'm not sure what to do here...
					SIMHALT
.END		 
					MOVEM.L		(SP)+,D0-D7
					RTS























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
