*--------------------------------------------------------------------------------------
* Title			: BEQ Handler function
* Description	: Handles the BEQ opcode, outputs the full disassembled instruction
* Manual Page # : 129
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*
* REGISTER USE
* D6 - Holds register value
* D7 - Register used to hold Opcode data
*--------------------------------------------------------------------------------------  
BEQ_OUT				DC.B		'BEQ',0

LOAD_BEQ:			MOVE.L		#%01100111,D0
					MOVE.L		#8,D1
					LEA			HANDLE_BEQ,A0
					JSR			TREE_ADD_NODE
					RTS

HANDLE_BEQ:			MOVEM.L		D0-D7/A0,-(SP)				; Save registers
					LEA			BEQ_OUT,A0
					JSR			PRINT_STR

					JSR			PRINT_OPCODE_TAB

					; Read word of displacement

					MOVEA.W		(A4)+,A0
					MOVE.L		#4,D0
					JSR			PRINT_ADDRESS					
.END:				
					MOVEM.L		(SP)+,D0-D7/A0				; Restore registers
					RTS
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
