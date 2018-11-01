*--------------------------------------------------------------------------------------
* Title			: OR Handler function
* Description	: Handles the OR opcode, outputs the full disassembled instruction
* Manual Page # : 254
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
OR_OUT				DC.B		'OR',0

LOAD_OR:			MOVE.L		#%1000,D0
					MOVE.L		#4,D1					 
					LEA			HANDLE_OR,A0							  
					JSR			TREE_ADD_NODE
					RTS

HANDLE_OR:			LEA			OR_OUT,A0
					JSR			PRINT_STR
					
					
					
					RTS














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
