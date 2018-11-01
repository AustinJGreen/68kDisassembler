*--------------------------------------------------------------------------------------
* Title			: LEA Handler function
* Description	: Handles the BRA opcode, outputs the full disassembled instruction
* Manual Page # : 214
* 
* INPUTS
* D0 - Opcode data (16-bits)
* A4 - Current machine code pointer
*
* REGISTER USE
* D6 - Holds register value
* D7 - Register used to hold Opcode data
*--------------------------------------------------------------------------------------  
LEA_OUT				DC.B		'LEA',0

LOAD_LEA:			MOVE.L		#10,D1						; All nodes below have 10 bits
					
					MOVE.L		#%0100000111,D0				; Add for A0 / (xxx).W
					LEA			HANDLE_LEA,A0
					JSR			TREE_ADD_NODE
					
					MOVE.L		#%0100001111,D0				; Add for A1 / (xxx).L
					LEA			HANDLE_LEA,A0
					JSR			TREE_ADD_NODE
					
					MOVE.L		#%0100010111,D0				; Add for A2
					LEA			HANDLE_LEA,A0
					JSR			TREE_ADD_NODE
					
					MOVE.L		#%0100011111,D0				; Add for A3
					LEA			HANDLE_LEA,A0
					JSR			TREE_ADD_NODE
					
					MOVE.L		#%0100100111,D0				; Add for A4
					LEA			HANDLE_LEA,A0
					JSR			TREE_ADD_NODE
					
					MOVE.L		#%0100101111,D0				; Add for A5
					LEA			HANDLE_LEA,A0
					JSR			TREE_ADD_NODE
					
					MOVE.L		#%0100110111,D0				; Add for A6
					LEA			HANDLE_LEA,A0
					JSR			TREE_ADD_NODE
					
					RTS

HANDLE_LEA:			MOVEM.L		D0-D7/A0,-(SP)				; Save registers
					LEA			LEA_OUT,A0
					JSR			PRINT_STR
				
.END:				
					MOVEM.L		(SP)+,D0-D7/A0				; Restore registers
					RTS


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
