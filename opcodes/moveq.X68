*--------------------------------------------------------------------------------------
* Title			: MOVEQ Handler function
* Description	: Handles the MOVEQ opcode, outputs the full disassembled instruction
* Manual Page # : 238
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
MOVEQ_OUT			DC.B		'MOVEQ',0

LOAD_MOVEQ:			MOVE.L		#%0111,D0
					MOVEQ.L		#4,D1					 
					LEA			HANDLE_MOVEQ,A0								 
					JSR			TREE_ADD_NODE
					RTS

HANDLE_MOVEQ:		LEA			MOVEQ_OUT,A0
					JSR			PRINT_STR
					RTS










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
