*--------------------------------------------------------------------------------------
* Title			: NOP Handler function
* Description	: Handles the NOP opcode, outputs the full disassembled instruction
* Manual Page # : 251
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*--------------------------------------------------------------------------------------  
NOP_OUT				DC.B		'NOP',0

LOAD_NOP:			MOVE.L		#%0100111001110001,D0
					MOVE.L		#16,D1					  
					LEA			HANDLE_NOP,A0							   
					JSR			TREE_ADD_NODE
					RTS

HANDLE_NOP:			LEA			NOP_OUT,A0
					JSR			PRINT_STR
					RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
