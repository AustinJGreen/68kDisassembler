*--------------------------------------------------------------------------------------
* Title			: RTS Handler function
* Description	: Handles the RTS opcode, outputs the full disassembled instruction
* Manual Page # : 273
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*-------------------------------------------------------------------------------------- 
RTS_OUT				DC.B		'RTS',0

LOAD_RTS:			MOVE.L		#%0100111001110101,D0
					MOVE.L		#16,D1
					LEA			HANDLE_RTS,A0					 
					JSR			TREE_ADD_NODE
					RTS

HANDLE_RTS:			LEA			RTS_OUT,A0
					JSR			PRINT_STR
					RTS








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
