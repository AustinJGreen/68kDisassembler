*--------------------------------------------------------------------------------------
* Title			: ASL Handler function
* Description	: Handles the ASL opcode, outputs the full disassembled instruction
* Manual Page # : 126
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*
* REGISTER USE
* D6 - Holds register value
* D7 - Register used to hold Opcode data
*--------------------------------------------------------------------------------------  
LOAD_ASL:			MOVE.L		#%11100001,D0
					MOVE.L		#8,D1
					LEA			HANDLE_ASL,A0
					JSR			TREE_ADD_NODE
					RTS

HANDLE_ASL:			RTS

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
