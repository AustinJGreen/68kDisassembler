*--------------------------------------------------------------------------------------
* Title			: BLE Handler function
* Description	: Handles the BLE opcode, outputs the full disassembled instruction
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
BLE_OUT				DC.B		'BLE',0

LOAD_BLE:			MOVE.L		#%01101111,D0
					MOVEQ.L		#8,D1
					LEA			HANDLE_BLE,A0
					JSR			TREE_ADD_NODE
					RTS

HANDLE_BLE:			MOVEM.L		D0-D7/A0,-(SP)				; Save registers
					LEA			BLE_OUT,A0
					JSR			PRINT_STR

					JSR			PRINT_OPCODE_TAB

					; Read word of displacement

					MOVEA.W		(A4)+,A0
					MOVEQ.L		#4,D0
					JSR			PRINT_ADDRESS					
.END:				
					MOVEM.L		(SP)+,D0-D7/A0				; Restore registers
					RTS


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
