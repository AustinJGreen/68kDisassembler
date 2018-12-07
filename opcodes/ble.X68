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
					MOVE.L		#8,D1
					LEA			HANDLE_BLE,A0
					JSR			TREE_ADD_NODE
					RTS

HANDLE_BLE:			MOVEM.L		D0-D7/A0/A5,-(SP)				; Save registers
					LEA			BLE_OUT,A0
					JSR			PRINT_STR

					JSR			PRINT_OPCODE_TAB
					
					MOVE.L		A4,D3							; Store next address
					
					; Read 8-bit displacement into D0
					AND.B		#%11111111,D0	

					; Check for 00, which means WORD displacement
					CMPI.B		#$00,D0
					BEQ			.WORD_ADDR
					
					; Check for FF which means LONG displacement
					CMPI.B		#$FF,D0
					BEQ			.LONG_ADDR
						
					; No extra data, display data and continue to end
					MOVE.L		D0,D5
					MOVE.L		D3,D4
					AND.L		#%11111111,D5
					ADD.B		D5,D4
					BVS			.OVERFLOW
					BRA			.CONTINUE
					
.OVERFLOW:			MOVE.L		D3,D4
					ADD.W		D5,D4
					BRA			.CONTINUE
					
.CONTINUE:			MOVE.W		D4,A0
					MOVE.L		#4,D0
					JSR			PRINT_ADDRESS	
					
					BRA			.END	
						
					; Read word of displacement and calculate absolute address
.WORD_ADDR:			MOVE.W		(A4)+,D5
					MOVE.L		D3,D4
					ADD.W		D5,D4
					MOVE.W		D4,A0
					MOVE.L		#4,D0
					JSR			PRINT_ADDRESS	
					BRA			.END
					
					; Read long of displacement
.LONG_ADDR:			MOVE.L		(A4)+,D5
					MOVE.L		D3,D4
					ADD.L		D5,D4
					MOVE.L		D4,A0
					MOVE.L		#8,D0
					JSR			PRINT_ADDRESS	
					BRA			.END
				
.END:				MOVEM.L		(SP)+,D0-D7/A0/A5				; Restore registers
					RTS

































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
