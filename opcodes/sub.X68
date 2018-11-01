*--------------------------------------------------------------------------------------
* Title			: SUB Handler function
* Description	: Handles the SUB opcode, outputs the full disassembled instruction
* Manual Page # : 278
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
SUB_OUT				DC.B		'SUB',0

LOAD_SUB:			MOVE.L		#%1001,D0
					MOVE.L		#4,D1					 
					LEA			HANDLE_SUB,A0							   
					JSR			TREE_ADD_NODE
					RTS

HANDLE_SUB:			LEA			SUB_OUT,A0
					JSR			PRINT_STR
					RTS













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
